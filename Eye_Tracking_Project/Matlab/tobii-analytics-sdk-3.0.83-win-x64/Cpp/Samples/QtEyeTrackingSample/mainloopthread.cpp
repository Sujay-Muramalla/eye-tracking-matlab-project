#include "mainloopthread.h"

using namespace tetio;

MainLoopThread::MainLoopThread() 
	: QThread()
{
}

MainLoopThread::~MainLoopThread()
{
    //Tell the mainLoop to stop doing work and return execution from the blocking call to run().
    quit();
    //Wait untill thread has finished execution for synchronous termination
    wait();
}

MainLoop& MainLoopThread::getMainLoop()
{
    return m_mainLoop;
}

void MainLoopThread::run()
{
    m_mainLoop.run();
}

void MainLoopThread::quit()
{
    m_mainLoop.quit();
}
