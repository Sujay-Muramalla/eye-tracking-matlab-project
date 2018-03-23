#include "App.h"
#include "MainLoopRunner.h"
#include <iostream>
#include <iomanip>
#include <boost/program_options.hpp>
#include <boost/thread.hpp>
#include <tobii/sdk/cpp/EyeTrackerBrowser.hpp>
#include <tobii/sdk/cpp/EyeTrackerBrowserFactory.hpp>
#include <tobii/sdk/cpp/EyeTrackerInfo.hpp>
#include <tobii/sdk/cpp/EyeTracker.hpp>
#include <tobii/sdk/cpp/UpgradePackage.hpp>
#include <tobii/sdk/cpp/SyncManager.hpp>

using ::std::string;
using ::std::cout;
using ::std::cerr;
using ::std::endl;
using ::std::ostream;

namespace options = boost::program_options;

using namespace tetio;

static const char tab = '\t';

App::App() :
	trackerId_(""), 
	trackerFound_(false)
{
}

int App::run(int argc, char *argv[]) 
{
	string infoTrackerId;
	string trackTrackerId;
	options::options_description desc("Usage");
	desc.add_options()
		("help,h", "Produce help message.")
		("list,l", "List available eyetrackers.")
		("info,i", options::value<string>(&infoTrackerId), "Print information about the specified eyetracker.")
		("track,t", options::value<string>(&trackTrackerId), "Track gaze data using the specified eyetracker.")
	;

	options::variables_map vm;
	try {
		options::store(options::command_line_parser(argc, argv)
			.options(desc)
			.run(), vm);
		options::notify(vm);
	}
	catch (options::error) {
		cerr << "Invalid command-line options given." << endl;
	}

	try	{
		if (vm.empty() || vm.count("help")) {
			cout << desc;
		}
		else if (vm.count("list")) {
			listEyeTrackers();
		}
		else if (vm.count("info")){
			printEyeTrackerInfo(infoTrackerId);
		}
		else if (vm.count("track")) {
			trackGazeData(trackTrackerId);
		}
	}
	catch(tetio::EyeTrackerException &e) {
		cerr << "\n*** Error! Caught EyeTrackerException with error code " << e.getErrorCode() << " ***\n\n";
	}
	catch(std::exception &e) {
		cerr << "\n*** Error! Caught unknown exception: '" << e.what() << "'***\n\n";
	}

	return 0;
}

void App::onEyeTrackerBrowserEventList(EyeTrackerBrowser::event_type_t type, EyeTrackerInfo::pointer_t info)
{
	if (type == EyeTrackerBrowser::TRACKER_FOUND) {
		cout
			<< std::setw(18) << std::left << info->getProductId() << tab
			<< std::setw(5) << std::left << info->getStatus() << tab
			<< std::setw(5) << std::left << info->getGeneration() << tab
			<< std::setw(13) << std::left << info->getModel() << tab
			<< std::setw(15) << std::left << info->getGivenName() << tab
			<< info->getVersion()
			<< endl;
	}
}

void startEyeTrackerLookUp(EyeTrackerBrowser::pointer_t browser, std::string browsingMessage)
{
	browser->start();
	// wait for eye trackers to respond.
#ifdef __APPLE__
    // Slight different bonjuor behaviour on Mac vs Linux/Windows, ... On MAC this needs to be > 30 seconds
	cout << browsingMessage << endl;
	boost::this_thread::sleep(boost::posix_time::milliseconds(60000)); 
#else		
	boost::this_thread::sleep(boost::posix_time::milliseconds(1000));
#endif
	browser->stop(); // NOTE this is a blocking operation.
}

void App::listEyeTrackers()
{
	cout << "Browsing for Eye Trackers..." << endl;

	MainLoopRunner runner;
	runner.start();
	EyeTrackerBrowser::pointer_t browser(EyeTrackerBrowserFactory::createBrowser(runner.getMainLoop()));
	browser->addEventListener(boost::bind(&App::onEyeTrackerBrowserEventList, this, _1, _2));
	startEyeTrackerLookUp(browser, "Browsing for eye trackers, please wait ...");
}

void App::onEyeTrackerBrowserEventPrintInfo(EyeTrackerBrowser::event_type_t type, EyeTrackerInfo::pointer_t info)
{
	if (type == EyeTrackerBrowser::TRACKER_FOUND && info->getProductId() == trackerId_) 
	{
		trackerFound_ = true;

		cout
			<< "Product ID: " << info->getProductId() << endl
			<< "Given name: " << info->getGivenName() << endl
			<< "Model:      " << info->getModel() << endl
			<< "Version:    " << info->getVersion() << endl
			<< "Status:     " << info->getStatus() << endl;
	}
}

void App::printEyeTrackerInfo(std::string& trackerId)
{
	cout << "Printing info about Eye Tracker: " << trackerId << endl;
	trackerId_ = trackerId;
	trackerFound_ = false;

	MainLoopRunner runner;
	runner.start();
	EyeTrackerBrowser::pointer_t browser(EyeTrackerBrowserFactory::createBrowser(runner.getMainLoop()));
	browser->addEventListener(boost::bind(&App::onEyeTrackerBrowserEventPrintInfo, this, _1, _2));
	startEyeTrackerLookUp(browser, "Browsing for " + trackerId + ", please wait ...");
	
	if(!trackerFound_)
	{
		cout << "Could not find any tracker with name: " << trackerId_ << endl;
	}
}

static std::string format_short(const tetio::Point2d& p) 
{
	std::ostringstream out;
	out << '(' << p.x << ',' << ' ' << p.y << ')';
	return out.str();
}

void App::onGazeDataReceived(tetio::GazeDataItem::pointer_t data)
{
	cout 
		<< data->timestamp << tab
		<< format_short(data->leftGazePoint2d) << tab
		<< format_short(data->rightGazePoint2d) << tab
		<< endl;
}

void App::trackGazeData(const std::string& trackerId)
{
	uint32_t tetserverPort = 0;
	uint32_t syncPort = 0;

	cout << "Tracking with Eye Tracker: " << trackerId << endl;

	try 
	{
		EyeTrackerFactory::pointer_t eyeTrackerFactory = EyeTrackerBrowserFactory::createEyeTrackerFactoryByIpAddressOrHostname(trackerId, tetserverPort, syncPort);

		if (eyeTrackerFactory) {
			cout << "Connecting ..." << endl;
			MainLoopRunner runner;
			runner.start();

			EyeTracker::pointer_t tracker(eyeTrackerFactory->createEyeTracker(runner.getMainLoop()));

			tracker->addGazeDataReceivedListener(boost::bind(&App::onGazeDataReceived, this, _1));
			tracker->startTracking();

			// sleep for a while. gaze data will be delivered on the MainloopRunner's thread.
			boost::this_thread::sleep(boost::posix_time::seconds(3));

			tracker->stopTracking();
			// stop the mainloop before the EyeTracker object is destroyed, to ensure that gaze data events
			// won't be delivered when the EyeTracker is gone.
			runner.stop();
		}
		else {
			cerr << "The specified eyetracker could not be found." << endl;
		}

	}
	catch (EyeTrackerException e)
	{
        cout << " " << e.what() << " " << e.getErrorCode() << endl;
	}
}