#!/usr/bin/python

import pygtk
pygtk.require('2.0')
import gtk
import gobject

glib_idle_add = None
glib_timeout_add = None
try:
    import glib
    glib_idle_add = glib.idle_add
    glib_timeout_add = glib.timeout_add
except:
    glib_idle_add = gtk.idle_add
    glib_timeout_add = gtk.timeout_add

import os

import tobii.eye_tracking_io
from tobii.eye_tracking_io import upgrade
from tobii.eye_tracking_io.browsing import EyetrackerBrowser
from tobii.eye_tracking_io.mainloop import MainloopThread

def show_message_box(parent, message, title="", buttons=gtk.BUTTONS_OK):
    def close_dialog(dlg, rid):
        dlg.destroy()

    msg = gtk.MessageDialog(parent=parent, buttons=buttons)
    msg.set_markup(message)
    msg.set_modal(False)
    msg.connect("response", close_dialog)
    msg.show() 

class EyetrackerSelector(gtk.ComboBox):
    def __init__(self, mainloop, on_selected):
        gtk.ComboBox.__init__(self)
        
        self.mainloop = mainloop
        self.model = gtk.ListStore(gobject.TYPE_PYOBJECT,
                                   gobject.TYPE_STRING)
        self.set_model(self.model)
        self._on_selected_cb = on_selected
        self._cell = gtk.CellRendererText()
        self.pack_start(self._cell, True)
        self.add_attribute(self._cell, 'text', 1)
        
        self.connect('changed', self._on_changed)
        
        self.browser = EyetrackerBrowser(self.mainloop,
                                         lambda event, event_name, device_info:
                                            glib_idle_add(self._on_eyetracker, event, event_name, device_info))
    
    def _on_eyetracker(self, event, event_name, device_info):
        if event == EyetrackerBrowser.FOUND:
            self.model.append([device_info, device_info.product_id])
        else:
            iter = self.model.get_iter_first()
            while iter is not None:
                current_device = self.model.get_value(iter, 0)
                if current_device.product_id == device_info.product_id:
                    break
                iter = self.model.iter_next(iter)
            
            if iter is None:
                return False
            
            if event == EyetrackerBrowser.REMOVED:
                self.model.remove(iter)
            if event == EyetrackerBrowser.UPDATED:
                self.model.set_value(iter, 0, device_info)
        
        return False
    
    def _on_changed(self, combobox):
        iter = self.get_active_iter()
        if iter is None:
            return
        
        if callable(self._on_selected_cb):
            self._on_selected_cb(self.model.get_value(iter, 0))
    
class UpgradeTool(object):
    def __init__(self):
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title("Upgrade Tool")
        self.window.connect("delete_event", self.delete_event)
        self.window.connect("destroy", self.destroy)
        self.window.set_border_width(3)              
        self.window.set_size_request(550, -1)
        
        self.mainloop = MainloopThread()
        self.mainloop.start()
        
        self.vbox = gtk.VBox()
        self.vbox.set_spacing(3)

        self.selector = EyetrackerSelector(self.mainloop, self._on_selected)
        
        self.file_filter = gtk.FileFilter()
        self.file_filter.set_name("Tobii Upgrade Packages")
        self.file_filter.add_pattern("*.tobiipkg")

        self.chooser = gtk.FileChooserButton(title="Select Firmware File")
        self.chooser.add_filter(self.file_filter)
        self.chooser.connect('file-set', self._on_file_selected)

        self.hbox1 = gtk.HBox()
        self.hbox1.pack_start(self.selector)
        self.hbox1.pack_end(self.chooser)

        self.progress = gtk.ProgressBar()
        self.cancel = gtk.Button("Cancel")
        self.cancel.set_sensitive(False)
        self.start = gtk.Button("Start Upgrade")
        self.start.set_sensitive(False)
        self.start.connect('clicked', self._start_upgrade)
        
        self.hbox2 = gtk.HBox()
        self.hbox2.pack_start(self.progress)
        self.hbox2.pack_end(self.cancel, expand=False)
        self.hbox2.pack_end(self.start, expand=False)
        
        self.vbox.pack_start(self.hbox1, expand=False)
        self.vbox.pack_end(self.hbox2, expand=False)
        
        self.window.add(self.vbox)
        self.window.show_all()
        
        self.upgrading_device = None
        self.selected_file = None
        self.upgrade_started = False

    def _on_file_selected(self, chooser):
        self.selected_file = self.chooser.get_filename()
        self._check_match()

    def _on_selected(self, device_info):
        self.upgrading_device = device_info
        self._check_match()

    def _check_match(self):
        if self.upgrading_device is None or self.selected_file is None:
            return
        
        self.chooser.set_sensitive(False)
        self.selector.set_sensitive(False)
        self.start.set_sensitive(False)
        self.cancel.set_sensitive(False)
        
        try:
            code = upgrade.package_is_compatible_with_device(self.mainloop,
                                                             self.selected_file,
                                                             self.upgrading_device)
            
            if code == 0:
                self.progress.set_text("")
                self.start.set_sensitive(True)
            else:
                msg = tobii.eye_tracking_io.error_code_to_string(code)
                if msg.startswith("TOBII_SDK_ERROR_"):
                    msg = msg[len("TOBII_SDK_ERROR_"):]
                self.progress.set_text("Not compatible: %s" % (msg)) 
                self.start.set_sensitive(False)

        finally:
            self.chooser.set_sensitive(True)
            self.selector.set_sensitive(True)
    
    def _start_upgrade(self, button):
        if self.upgrade_started or self.upgrading_device is None:
            return
        
        self.start.set_sensitive(False)
        self.cancel.set_sensitive(False)
        self.upgrade_started = True
        
        try:
            self._upgrade_progress_init = False
            upgrade.begin_upgrade(self.mainloop, 
                                  self.selected_file, 
                                  self.upgrading_device, 
                                  lambda code: glib_idle_add(self._on_upgrade_complete, code), 
                                  lambda c, n, p: glib_idle_add(self._on_upgrade_progress, c, n, p), 
                                  lambda c: glib_idle_add(self._on_upgrade_cancancel_changed, c))
            
        except Exception, ex:
            self.upgrade_started = False
            self.start.set_sensitive(True)
            print "ERROR: ", ex 
    
    def _on_upgrade_complete(self, code):
        try:
            show_message_box(self.window, "Upgrade Complete", "Upgrade of unit %s completed with code: %d" % (self.upgrading_device, code), gtk.BUTTONS_OK)
            self.upgrade_started = False
            self.progress.set_fraction(0)
            self._check_match()
        except Exception, ex:
            print "UC: EXXX:", ex
        return False
    
    def _on_upgrade_progress(self, current_step, number_of_steps, percentage):
        try:
            progress = float(current_step * 100 + percentage)
            total = float((number_of_steps + 1) * 100)
            print "Progress:", progress, "of", total, "(", current_step, "of", number_of_steps, "at", percentage, ")"
            self.progress.set_fraction(progress / total)
        except Exception, ex:
            print "PROGR EXXX:", ex
        return False

    
    def _on_upgrade_cancancel_changed(self, cancancel):
        try:
            print "Cancancel:", cancancel
            self.cancel.set_sensitive(cancancel)
        except Exception, ex:
            print "CC EXXX:", ex
        
        return False
    
    def delete_event(self, widget, event, data=None):
        # Change FALSE to TRUE and the main window will not be destroyed
        # with a "delete_event".
        if self.upgrading_device is not None and self.upgrade_started:
            md = gtk.MessageDialog(parent=self.window,
                                   type=gtk.MESSAGE_INFO,
                                   buttons=gtk.BUTTONS_OK,
                                   message_format="Upgrade of unit %s currently in progress, you cannot quit now." % (self.upgrading_device))
            md.run()
            md.destroy()
            return True
        return False

    def destroy(self, widget, data=None):
        self.selector.browser.stop()
        gtk.main_quit()  
    
    def main(self):
        gtk.main()
        self.mainloop.stop()

if __name__ == "__main__":
    gtk.gdk.threads_init()
    if 'TETIO_LOG_LEVEL' not in os.environ:
        os.environ['TETIO_LOG_LEVEL'] = 'ERROR'    
    tobii.eye_tracking_io.init()
    tool = UpgradeTool()
    tool.main()
