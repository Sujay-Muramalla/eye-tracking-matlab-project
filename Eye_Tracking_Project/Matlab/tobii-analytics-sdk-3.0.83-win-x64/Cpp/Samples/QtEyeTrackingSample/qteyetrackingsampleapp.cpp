#include <QMessageBox>

#include "qteyetrackingsampleapp.h"
#include "appversion.h"

using namespace tetio;

QtEyeTrackingSampleApp::QtEyeTrackingSampleApp(int &argc, char **argv) :
    QApplication(argc, argv),
    m_mainWindow(NULL)
{
    setApplicationVersion(VERSION_NUMBER);
}

QtEyeTrackingSampleApp::~QtEyeTrackingSampleApp()
{
    delete m_mainWindow;
}

bool QtEyeTrackingSampleApp::notify(QObject *receiver, QEvent *event)
{
    try {
        return QApplication::notify(receiver, event);
    }
    catch (const EyeTrackerException &ex) {
        QMessageBox msgBox;
        msgBox.setText(ex.what());
        msgBox.setIcon(QMessageBox::Critical);
        msgBox.exec();
    }
    return false;
}

QWidget* QtEyeTrackingSampleApp::getMainWindow()
{
    if (!m_mainWindow)
        initMainWindow();
    return m_mainWindow;
}


void QtEyeTrackingSampleApp::initMainWindow()
{
    m_mainWindow = new MainWindow(m_mainLoopThread);
    m_mainLoopThread.start();
}

