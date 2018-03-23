#ifndef QTEYETRACKINGSAMPLEAPP_H
#define QTEYETRACKINGSAMPLEAPP_H

#include <QApplication>

#include "mainloopthread.h"
#include "mainwindow.h"

namespace tetio = tobii::sdk::cpp;

class QtEyeTrackingSampleApp : public QApplication
{
    Q_OBJECT

public:
    QtEyeTrackingSampleApp(int &argc, char **argv);
    virtual ~QtEyeTrackingSampleApp();

    virtual bool notify(QObject *receiver, QEvent *event);
    QWidget* getMainWindow();

signals:
    
public slots:

private:
    void initMainWindow();

    MainLoopThread m_mainLoopThread;
    MainWindow *m_mainWindow;
};

#endif // QTEYETRACKINGSAMPLEAPP_H
