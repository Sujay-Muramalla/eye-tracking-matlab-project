#ifndef EYETRACKERBROWSER_H
#define EYETRACKERBROWSER_H

#include <QObject>
#include <QSharedPointer>

#include <tobii/sdk/cpp/MainLoop.hpp>
#include "eyetrackerbrowsereventargs.h"

namespace tetio = tobii::sdk::cpp;

//Qt wrapper for tetio::eyetracker_browser class
class QtEyeTrackerBrowser : public QObject
{
    Q_OBJECT

public:
	QtEyeTrackerBrowser(tetio::MainLoop& mainloop);
    
signals:
    void browserEvent(QSharedPointer<QtEyeTrackerBrowserEventArgs>);

public slots:

private:
    void handleBrowserEvent(tetio::EyeTrackerBrowser::event_type_t type,
                       tetio::EyeTrackerInfo::pointer_t info);

    tetio::EyeTrackerBrowser::pointer_t m_browser;
};

#endif // EYETRACKERBROWSER_H
