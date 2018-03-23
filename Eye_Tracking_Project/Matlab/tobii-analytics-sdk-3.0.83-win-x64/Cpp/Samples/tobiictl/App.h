#ifndef __APP_H__
#define __APP_H__

#include <string>
#include <tobii/sdk/cpp/EyeTrackerBrowser.hpp>
#include <tobii/sdk/cpp/EyeTrackerBrowserFactory.hpp>

namespace tetio = tobii::sdk::cpp;

// Main class for this sample application.
class App
{
public:
	App();
	int run(int argc, char *argv[]);

private:
	void listEyeTrackers();
	void printEyeTrackerInfo(std::string& tracker_id);
	void trackGazeData(const std::string& tracker_id);

	void onEyeTrackerBrowserEventList(tetio::EyeTrackerBrowser::event_type_t type, tetio::EyeTrackerInfo::pointer_t info);
	void onEyeTrackerBrowserEventPrintInfo(tetio::EyeTrackerBrowser::event_type_t type, tetio::EyeTrackerInfo::pointer_t info);
	void onGazeDataReceived(tetio::GazeDataItem::pointer_t data);

	std::string trackerId_;
	bool trackerFound_;
};

#endif // __APP_H__
