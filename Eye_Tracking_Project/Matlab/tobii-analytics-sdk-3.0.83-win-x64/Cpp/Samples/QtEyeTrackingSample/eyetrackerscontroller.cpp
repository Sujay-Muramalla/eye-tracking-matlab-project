#include <tobii/sdk/cpp/EyeTrackerException.hpp>

#include "eyetrackerscontroller.h"
#include "listviewdelegate.h"

using namespace tetio;

EyeTrackersController::EyeTrackersController(MainLoopThread& mainLoopThread) :
    QObject(),
    m_model(new QStandardItemModel()),
    m_mainLoopThread(mainLoopThread)
{
    registerMetaTypes();
    initQtEyeTrackerBrowser();
}

EyeTrackersController::~EyeTrackersController()
{
    delete m_model;
}

QAbstractItemModel* EyeTrackersController::getModel()
{
    return m_model;
}

bool EyeTrackersController::isExist(QString productId)
{
    DataMap::iterator dataIt = m_dataMap.find(productId);
    return dataIt != m_dataMap.end();
}

QtEyeTracker* EyeTrackersController::connectTo(QString productId)
{
    DataMap::iterator dataIt = m_dataMap.find(productId);
    if (dataIt != m_dataMap.end()) {
		QtEyeTracker *eyetracker = new QtEyeTracker(dataIt.value()->getInfo());
        try {
            eyetracker->connectTo(m_mainLoopThread.getMainLoop());
        }
        catch(const EyeTrackerException&) {
            delete eyetracker;
            throw;
        }
        return eyetracker;
    }
    return NULL;
}

void EyeTrackersController::initQtEyeTrackerBrowser()
{
    m_eyetrackerBrowser =
            QSharedPointer<QtEyeTrackerBrowser>(new QtEyeTrackerBrowser(m_mainLoopThread.getMainLoop()));
    connect(m_eyetrackerBrowser.data(), SIGNAL(browserEvent(QSharedPointer<QtEyeTrackerBrowserEventArgs>)),
        this, SLOT(handleBrowserEvent(QSharedPointer<QtEyeTrackerBrowserEventArgs>)), Qt::QueuedConnection);
}

void EyeTrackersController::registerMetaTypes()
{
    qRegisterMetaType<QSharedPointer<QtEyeTrackerBrowserEventArgs> >("QSharedPointer<QtEyeTrackerBrowserEventArgs>");
    qRegisterMetaType<uint32_t>("uint32_t");
    qRegisterMetaType<GazeDataItem::pointer_t>("tetio::GazeDataItem::pointer_t"); 
}

void EyeTrackersController::handleBrowserEvent(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    switch (args->getType()) {
        case EyeTrackerBrowser::TRACKER_FOUND:
            addEyeTracker(args);
            break;
        case EyeTrackerBrowser::TRACKER_REMOVED:
            removeEyeTracker(args);
            break;
        case EyeTrackerBrowser::TRACKER_UPDATED:
            updateEyeTracker(args);
            break;
    }
}

void EyeTrackersController::addEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    QString productId = QString::fromStdString(args->getInfo()->getProductId());
    QStandardItem *item = new QStandardItem();
    updateItemData(item, args);
    m_listViewItemMap.insert(productId, item);
    m_dataMap.insert(productId, args);
    m_model->appendRow(item);
}

void EyeTrackersController::removeEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    QString productId = QString::fromStdString(args->getInfo()->getProductId());
    m_dataMap.remove(productId);
    QMap<QString, QStandardItem*>::const_iterator it = m_listViewItemMap.constFind(productId);
    if(it != m_listViewItemMap.constEnd()) {
        QStandardItem *itemToRemove = it.value();
        QModelIndex index = m_model->indexFromItem(itemToRemove);
        m_model->removeRow(index.row());
    }
}

void EyeTrackersController::updateEyeTracker(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    QString productId = QString::fromStdString(args->getInfo()->getProductId());
    m_dataMap[productId] = args;
    QMap<QString, QStandardItem*>::const_iterator it = m_listViewItemMap.constFind(productId);
    if(it != m_listViewItemMap.constEnd()) {
        QStandardItem *itemToUpdate = it.value();
        updateItemData(itemToUpdate, args);
    }
}

void EyeTrackersController::updateItemData(QStandardItem *item, QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    QString productId = QString::fromStdString(args->getInfo()->getProductId());
    QPixmap icon = getIconFromArgs(args);
    QString header = getHeaderTextFromArgs(args);
    QString subHeader = getSubHeaderTextFromArgs(args);
    QString model = getModelFromArgs(args);
    QString status = getStatusFromArgs(args);
    QString generation = getGenerationFromArgs(args);
    QString givenName = getGivenNameFromArgs(args);
    QString firmwareVersion = getFirmwareVersionFromArgs(args);
    item->setData(header, ListviewDelegate::HeaderTextRole);
    item->setData(subHeader, ListviewDelegate::SubHeaderTextRole);
    item->setData(icon, ListviewDelegate::IconRole);
    item->setData(productId, ListviewDelegate::ProductIdRole);
    item->setData(model, ListviewDelegate::ModelRole);
    item->setData(status, ListviewDelegate::StatusRole);
    item->setData(generation, ListviewDelegate::GenerationRole);
    item->setData(givenName, ListviewDelegate::GivenNameRole);
    item->setData(firmwareVersion, ListviewDelegate::FirmwareVersionRole);
    //TODO: Add tooltip
}

QString EyeTrackersController::getProductIdFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getProductId());
}

QPixmap EyeTrackersController::getIconFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs>)
{
    QPixmap emptyIcon(4, 64);
    emptyIcon.fill(QColor::fromRgb(255,255,255));
    return emptyIcon;
}

QString EyeTrackersController::getHeaderTextFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    if(args->getInfo()->getGivenName() != "")
        return QString::fromStdString(args->getInfo()->getGivenName());
    return QString::fromStdString(args->getInfo()->getProductId());
}

QString EyeTrackersController::getSubHeaderTextFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    if(args->getInfo()->getStatus() == "ok") {
        QString name = QString::fromStdString(args->getInfo()->getGivenName());
        if(name == "")
            return QString::fromStdString(args->getInfo()->getModel());
        else
            return QString::fromStdString(args->getInfo()->getProductId()) + " (" + QString::fromStdString(args->getInfo()->getModel()) + ")";
    }
    else if(args->getInfo()->getStatus() == "upgrading")
        return QString("Upgrading...");
    else if(args->getInfo()->getStatus() == "not-working")
        return QString("EyeTracker not working as expected.");
    return QString("");
}

QString EyeTrackersController::getModelFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getModel());
}

QString EyeTrackersController::getStatusFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getStatus());
}

QString EyeTrackersController::getGenerationFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getGeneration());
}

QString EyeTrackersController::getGivenNameFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getGivenName());
}

QString EyeTrackersController::getFirmwareVersionFromArgs(QSharedPointer<QtEyeTrackerBrowserEventArgs> args)
{
    return QString::fromStdString(args->getInfo()->getVersion());
}
