#include "eyetrackerbrowsereventargs.h"

using namespace tetio;

QtEyeTrackerBrowserEventArgs::QtEyeTrackerBrowserEventArgs(
        EyeTrackerInfo::pointer_t info,
        EyeTrackerBrowser::event_type_t type) :
    QObject(),
    m_info(info),
    m_type(type)
{
}

EyeTrackerInfo::pointer_t QtEyeTrackerBrowserEventArgs::getInfo()
{
    return m_info;
}

EyeTrackerBrowser::event_type_t QtEyeTrackerBrowserEventArgs::getType()
{
    return m_type;
}
