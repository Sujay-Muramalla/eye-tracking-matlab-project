#include "calibrationrunner.h"
#include <boost/make_shared.hpp>

using namespace std;
using namespace tetio;

#define CALIBRATION_POINT_INTERVAL	1000 //ms

CalibrationRunner::CalibrationRunner(QtEyeTracker *tracker, QWidget *parent) :
    QObject(parent),
    m_tracker(tracker)
{
    connect(&m_sleepTimer, SIGNAL(timeout()), this, SLOT(timerTickHandler()), Qt::QueuedConnection);
    connect(&m_calibrationDlg, SIGNAL(calibrationDialogLoaded()), this, SLOT(startNextOrFinish()));
    connect(this, SIGNAL(pointCompletedEvent()), this, SLOT(pointCompletedHandler()),  Qt::QueuedConnection);
    connect(this, SIGNAL(computeCompletedEvent()), this, SLOT(computeCompletedHandler()),  Qt::QueuedConnection);
    connect(this, SIGNAL(computeFailedEvent()), this, SLOT(computeFailedHandler()),  Qt::QueuedConnection);
    connect(m_tracker, SIGNAL(connectionError(uint32_t)), this, SLOT(abortCalibrationHandler()),  Qt::QueuedConnection);
}


Calibration::pointer_t CalibrationRunner::runCalibration()
{
    createPointList();

    // Inform the eyetracker that we want to run a calibration
    m_tracker->startCalibration();

    QPalette pal = m_calibrationDlg.palette();
    pal.setColor(m_calibrationDlg.backgroundRole(), Qt::gray);
    m_calibrationDlg.setPalette(pal);
    m_calibrationDlg.setWindowState(m_calibrationDlg.windowState() | Qt::WindowFullScreen );
    m_calibrationDlg.clearCalibrationPoint();
    m_calibrationDlg.exec();

    // Inform the eyetracker that we have finished
    // the calibration routine
    m_tracker->stopCalibration();

    return m_calibrationResult;
}


void CalibrationRunner::startNextOrFinish()
{
    if(m_calibrationPoints.size() > 0) {
        Point2d point = m_calibrationPoints.front();
        m_calibrationPoints.pop();
        m_calibrationDlg.drawCalibrationPoint(point);
        m_sleepTimer.start(CALIBRATION_POINT_INTERVAL);
    } else {
        // Use the async version of ComputeCalibration since
        // this call takes some time
        m_tracker->computeCalibrationAsync(boost::bind(&CalibrationRunner::computeCompleted,this,_1));
    }
}


void CalibrationRunner::timerTickHandler()
{
    m_sleepTimer.stop();
    Point2d point = m_calibrationDlg.getCalibrationPoint();
    m_tracker->addCalibrationPointAsync(point, boost::bind(&CalibrationRunner::pointCompleted,this,_1) );
}

void CalibrationRunner::pointCompleted(uint32_t)
{
    emit pointCompletedEvent();
}

void CalibrationRunner::pointCompletedHandler()
{
    m_calibrationDlg.clearCalibrationPoint();
    startNextOrFinish();
}

void CalibrationRunner::computeCompleted(uint32_t e)
{
	if(e == 0)
		emit computeCompletedEvent();
	else 
		emit computeFailedEvent();
}

void CalibrationRunner::computeCompletedHandler()
{
    m_calibrationDlg.close();
	Calibration::pointer_t temp = m_tracker->getCalibration();
	m_calibrationResult = boost::make_shared<CalibrationImpl>(temp->getRawData());
}

void CalibrationRunner::computeFailedHandler()
{
    m_calibrationDlg.close();
	m_calibrationResult = boost::shared_ptr<CalibrationImpl>();
}

void CalibrationRunner::createPointList()
{
    m_calibrationPoints.push(Point2d(0.1, 0.1));
    m_calibrationPoints.push(Point2d(0.5, 0.5));
    m_calibrationPoints.push(Point2d(0.9, 0.1));
    m_calibrationPoints.push(Point2d(0.9, 0.9));
    m_calibrationPoints.push(Point2d(0.1, 0.9));
}

void CalibrationRunner::abortCalibrationHandler()
{
    m_sleepTimer.stop();
    m_calibrationDlg.close();
}
