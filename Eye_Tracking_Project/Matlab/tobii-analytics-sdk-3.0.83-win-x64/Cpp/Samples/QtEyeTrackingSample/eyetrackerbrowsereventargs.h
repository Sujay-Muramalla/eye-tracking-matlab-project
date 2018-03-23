#ifndef EYETRACKERBROWSEREVENTARGS_H
#define EYETRACKERBROWSEREVENTARGS_H

#include <QObject>

#include <tobii/sdk/cpp/EyeTrackerBrowser.hpp>
#include <tobii/sdk/cpp/EyeTrackerInfo.hpp>

namespace tetio = tobii::sdk::cpp;

//Qt wrapper for tetio::eyetracker_browser::browser_event_listener params
class QtEyeTrackerBrowserEventArgs : public QObject
{
    Q_OBJECT

public:
    QtEyeTrackerBrowserEventArgs(
            tetio::EyeTrackerInfo::pointer_t info,
            tetio::EyeTrackerBrowser::event_type_t type);

    tetio::EyeTrackerInfo::pointer_t getInfo();
    tetio::EyeTrackerBrowser::event_type_t getType();

private:
    tetio::EyeTrackerInfo::pointer_t m_info;
    tetio::EyeTrackerBrowser::event_type_t m_type;
};

#endif // EYETRACKERBROWSEREVENTARGS_H
