#ifndef MAINLOOPTHREAD_H
#define MAINLOOPTHREAD_H

#include <QThread>
#include <tobii/sdk/cpp/MainLoop.hpp>

namespace tetio = tobii::sdk::cpp;

// Background thread for run tobii::sdk::cpp::MainLoop. All asynchronous events will be delivered on this thread.
class MainLoopThread : public QThread
{
    Q_OBJECT

public:
    explicit MainLoopThread();
    virtual ~MainLoopThread();

	tetio::MainLoop& getMainLoop();
    void quit();

protected:
    virtual void run();

private:
	tobii::sdk::cpp::MainLoop m_mainLoop;
};

#endif // MAINLOOPTHREAD_H
