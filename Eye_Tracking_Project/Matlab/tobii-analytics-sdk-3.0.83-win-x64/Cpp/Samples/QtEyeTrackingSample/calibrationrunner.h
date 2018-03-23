#ifndef CALIBRATIONRUNNER_H
#define CALIBRATIONRUNNER_H

#include "calibrationdialog.h"
#include "qteyetracker.h"
#include <queue>
#include <QTimer>
#include <boost/shared_ptr.hpp>

#include <tobii/sdk/cpp/EyeTracker.hpp>

namespace tetio = tobii::sdk::cpp;

//Class for handling of the calibration procedure
class CalibrationRunner : QObject
{
    Q_OBJECT

public:
    explicit CalibrationRunner(QtEyeTracker *tracker, QWidget *parent = 0);
	tetio::Calibration::pointer_t runCalibration();

signals:
    void pointCompletedEvent();
    void computeCompletedEvent();
    void computeFailedEvent();
    void abortCalibrationEvent();

private slots:
    void startNextOrFinish();
    void timerTickHandler();
    void pointCompletedHandler();
    void abortCalibrationHandler();
    void computeCompletedHandler();
    void computeFailedHandler();

private:
    void createPointList();
    void pointCompleted(uint32_t e);
    void computeCompleted(uint32_t e);

private:
    QtEyeTracker *m_tracker;
    QTimer m_sleepTimer;
    CalibrationDialog m_calibrationDlg;
    std::queue<tetio::Point2d> m_calibrationPoints;
	tetio::Calibration::pointer_t m_calibrationResult;
};

#endif // CALIBRATIONRUNNER_H
