#ifndef __MAINLOOP_RUNNER_H__
#define __MAINLOOP_RUNNER_H__

#include <boost/noncopyable.hpp>
#include <boost/thread.hpp>
#include <tobii/sdk/cpp/MainLoop.hpp>

namespace tetio = tobii::sdk::cpp;

// Thread hosting the main loop.
class MainLoopRunner : public boost::noncopyable
{
public:
	MainLoopRunner();
	virtual ~MainLoopRunner();
	tetio::MainLoop& getMainLoop();
	void start();
	void stop();

private:
	tetio::MainLoop mainLoop_;
	volatile bool threadStarted_;
	boost::thread* thread_;

	void run();
};

#endif // __MAINLOOP_RUNNER_H__
