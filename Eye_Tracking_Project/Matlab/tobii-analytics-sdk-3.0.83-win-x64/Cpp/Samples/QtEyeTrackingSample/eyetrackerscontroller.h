#ifndef EYETRACKERSCONTROLLER_H
#define EYETRACKERSCONTROLLER_H

#include <QObject>
#include <QSharedPointer>
#include <QStandardItem>
#include <QString>
#include <QMap>

#include "mainloopthread.h"
#include "eyetrackerbrowser.h"
#include "eyetrackerbrowsereventargs.h"
#include "qteyetracker.h"

namespace tetio = tobii::sdk::cpp;

//Class handles the event from EyeTrackerBrowser and manipulate with EyeTrackers list.
class EyeTrackersController : public QObject
{
    Q_OBJECT

public:
    EyeTrackersController(MainLoopThread& mainLoopThread);
    ~EyeTrackersController();

    QAbstractItemModel* getModel();
    bool isExist(QString productId);
    QtEyeTracker* connectTo(QString productId);

signals:
    
public slots:
    void handleBrowserEvent(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);

private:
    typedef QMap<QString, QSharedPointer<QtEyeTrackerBrowserEventArgs> > DataMap;

    void initQtEyeTrackerBrowser();
    void registerMetaTypes();

    void addEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    void removeEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    void updateEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);

    QString getProductIdFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QPixmap getIconFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getHeaderTextFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getSubHeaderTextFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getModelFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getStatusFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getGenerationFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getGivenNameFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);
    QString getFirmwareVersionFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args);

    void updateItemData(QStandardItem *item, QSharedPointer<QtEyeTrackerBrowserEventArgs> args);

    QStandardItemModel *m_model;
    MainLoopThread& m_mainLoopThread;
    QSharedPointer<QtEyeTrackerBrowser> m_eyetrackerBrowser;
    QMap<QString, QStandardItem*> m_listViewItemMap;
    DataMap m_dataMap;
};

#endif // EYETRACKERSCONTROLLER_H
