
import os

import pygtk
pygtk.require('2.0')
import gtk

glib_idle_add = None
glib_timeout_add = None
try:
    import glib
    glib_idle_add = glib.idle_add
    glib_timeout_add = glib.timeout_add
except:
    glib_idle_add = gtk.idle_add
    glib_timeout_add = gtk.timeout_add


import tobii.eye_tracking_io.mainloop
import tobii.eye_tracking_io.browsing
import tobii.eye_tracking_io.eyetracker

from tobii.eye_tracking_io.time.clock import Clock
from tobii.eye_tracking_io.time import sync

def show_message_box(parent, message, title="", buttons=gtk.BUTTONS_OK):
    def close_dialog(dlg, rid):
        dlg.destroy()

    msg = gtk.MessageDialog(parent=parent, buttons=buttons)
    msg.set_markup(message)
    msg.set_modal(False)
    msg.connect("response", close_dialog)
    msg.show()     

class EyetrackerBrowser(gtk.VBox):
    def __init__(self, mainloop):
        gtk.VBox.__init__(self)
        
        self.mainloop = mainloop
        
        self.eyetrackers = {}
        
        self.label = gtk.Label()
        self.label.set_alignment(0.0, 0.5)
        self.label.set_markup("<b>Discovered Eyetrackers:</b>")
        
        # add label to vbox
        self.pack_start(self.label, expand=False)
        
        self.liststore = gtk.ListStore(str, str, str)
        self.treeview = gtk.TreeView(self.liststore)

        self.pid_column = gtk.TreeViewColumn("PID")
        self.pid_cell = gtk.CellRendererText()
        self.treeview.append_column(self.pid_column)
        self.pid_column.pack_start(self.pid_cell, True)
        self.pid_column.set_attributes(self.pid_cell, text=0)

        self.model_column = gtk.TreeViewColumn("Model")
        self.model_cell = gtk.CellRendererText()
        self.treeview.append_column(self.model_column)
        self.model_column.pack_start(self.model_cell, True)
        self.model_column.set_attributes(self.model_cell, text=1)

        self.status_column = gtk.TreeViewColumn("Status")
        self.status_cell = gtk.CellRendererText()
        self.treeview.append_column(self.status_column)
        self.status_column.pack_start(self.status_cell, True)
        self.status_column.set_attributes(self.status_cell, text=2)
        
        self.pack_end(self.treeview)
        
        self.browser = tobii.eye_tracking_io.browsing.EyetrackerBrowser(self.mainloop, 
                                                            lambda t, n, i: glib_idle_add(self.on_eyetracker_browser_event, t, n, i))

    def stop(self):
        self.browser.stop()
        self.browser = None

    def on_eyetracker_browser_event(self, event_type, event_name, eyetracker_info):
        if event_type == tobii.eye_tracking_io.browsing.EyetrackerBrowser.FOUND:
            self.eyetrackers[eyetracker_info.product_id] = eyetracker_info
            self.liststore.append(('%s' % eyetracker_info.product_id, eyetracker_info.model, eyetracker_info.status))
            return False
        
        del self.eyetrackers[eyetracker_info.product_id]
        iter = self.liststore.get_iter_first()
        while iter is not None:
            if self.liststore.get_value(iter, 0) == str(eyetracker_info.product_id):
                self.liststore.remove(iter)
                break
            iter = self.liststore.iter_next(iter)
        
        if event_type == tobii.eye_tracking_io.browsing.EyetrackerBrowser.UPDATED:
            self.eyetrackers[eyetracker_info.product_id] = eyetracker_info
            self.liststore.append([eyetracker_info.product_id, eyetracker_info.model, eyetracker_info.status])
        return False


class SyncWatcher(object):
    def __init__(self):
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title("Synchronization Watcher")
        self.window.connect("delete_event", self.delete_event)
        self.window.connect("destroy", self.destroy)        
        self.window.set_border_width(5)
        self.window.set_size_request(400, 300)
        
        self.table = gtk.Table(2, 2)
        self.table.set_col_spacings(5)
        
        self.mainloop = tobii.eye_tracking_io.mainloop.MainloopThread()
        
        self.eyetracker_browser = EyetrackerBrowser(self.mainloop)
        self.eyetracker_browser.treeview.connect("row-activated", self.eyetracker_activated)
        self.table.attach(self.eyetracker_browser, 0, 1, 0, 1)

        #
        # build sync box        
        self.label = gtk.Label()
        self.label.set_markup("<b>Synchronization Data:</b>")
        self.label.set_alignment(0.0, 0.5)
        
        self.sync_store = gtk.ListStore(str, str, str, str, str)
        self.sync_view = gtk.TreeView(self.sync_store)
        
        i = 0
        self.sync_cells = []
        self.sync_cols = []
        for column in ["", "Local (us)", "Remote (us)", "Roundtrip (us)", "Error Approximation (us)"]:
            cell = gtk.CellRendererText()
            col = gtk.TreeViewColumn(column, cell)
            col.add_attribute(cell, 'markup', i)
            self.sync_view.append_column(col)
            self.sync_cols.append(col)
            self.sync_cells.append(cell) 
            i += 1
        
        self.sync_box = gtk.VBox(False)
        self.sync_box.set_spacing(5)
        self.sync_box.pack_start(self.label, fill=False, expand=False)
        self.sync_box.pack_end(self.sync_view)
        
        self.table.attach(self.sync_box, 1, 2, 0, 1)
    
        self.window.add(self.table)
        self.window.show_all()
    
    def eyetracker_activated(self, treeview, path, user_data=None):
        model = treeview.get_model()
        iter = model.get_iter(path)
        
        eyetracker_info = self.eyetracker_browser.eyetrackers[model.get_value(iter, 0)]
        print "Connecting to:", eyetracker_info
        tobii.eye_tracking_io.eyetracker.Eyetracker.create_async(self.mainloop,
                                                     eyetracker_info,
                                                     lambda error, eyetracker: glib_idle_add(self.on_eyetracker_created, error, eyetracker, eyetracker_info))

    def on_eyetracker_created(self, error, eyetracker, eyetracker_info):
        if error:
            print "  Connection to %s failed because of an exception: %s" % (eyetracker_info, error)
            show_message_box(parent=self.window, message="Could not connect to %s" % (eyetracker_info))
            return False
        
        self.eyetracker = eyetracker
        self.eyetracker.events.OnError += self.on_eyetracker_error
        self.clock = Clock()
        self.sync_manager = sync.SyncManager(self.clock,
                                         eyetracker_info,
                                         self.mainloop,
                                         lambda e: glib_idle_add(self.on_sync_error, e),
                                         lambda s: glib_idle_add(self.on_sync_status, s))
        return False

    def on_eyetracker_error(self, error):
        show_message_box(self.window, "An error occured, the connection to the eyetracker will be disconnected.\n\n<b>Details:</b> <i>0x%08x</i>" % error)
        self.eyetracker = None

    def on_sync_error(self, error):
        if error:
            show_message_box(self.window, "An error occued during synchronization:\n\n<b>Details:</b> <i>0x%08x</i>" % error)
        return False

    def on_sync_status(self, state):
        p = state.points_in_use[-1]
        
        state_flag = ""
        if state.state_flag == 0:
            state_flag = "Unsynchronized"
        elif state.state_flag == 1:
            state_flag = "Stabilizing"
        else:
            state_flag = "Synchronized"
        self.sync_store.append([state_flag, p[0], p[1], p[2], state.error_approximation])
        
        return False
    
    def delete_event(self, widget, event, data=None):
        # Change FALSE to TRUE and the main window will not be destroyed
        # with a "delete_event".
        return False

    def destroy(self, widget, data=None):
        self.eyetracker_browser.stop()
        gtk.main_quit()    

    def main(self):
        gtk.main()
        self.mainloop.stop()
        

if __name__ == "__main__":
    gtk.gdk.threads_init()
    if 'TETIO_LOG_LEVEL' not in os.environ:
        os.environ['TETIO_LOG_LEVEL'] = 'ERROR'    
    tobii.eye_tracking_io.init()
    sync_watcher = SyncWatcher()
    sync_watcher.main()

