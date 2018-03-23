#include "eyetrackerbrowser.h"
#include <tobii/sdk/cpp/EyeTrackerBrowserFactory.hpp>

using namespace tetio;

QtEyeTrackerBrowser::QtEyeTrackerBrowser(MainLoop& mainLoop) :
    QObject(),
    m_browser(EyeTrackerBrowserFactory::createBrowser(mainLoop))
{
    m_browser->addEventListener(boost::bind(&QtEyeTrackerBrowser::handleBrowserEvent, this, _1, _2));
    m_browser->start();
}

void QtEyeTrackerBrowser::handleBrowserEvent(EyeTrackerBrowser::event_type_t type,
				EyeTrackerInfo::pointer_t info)
{
    QSharedPointer<QtEyeTrackerBrowserEventArgs> args(new QtEyeTrackerBrowserEventArgs(info, type));
    emit browserEvent(args);
}
