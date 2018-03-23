#ifndef EYETRACKER_H
#define EYETRACKER_H

#include <stdint.h>

#include <QObject>
#include <QVector>

#include <tobii/sdk/cpp/EyeTrackerInfo.hpp>
#include <tobii/sdk/cpp/EyeTrackerFactory.hpp>
#include <tobii/sdk/cpp/EyeTracker.hpp>
#include <tobii/sdk/cpp/Types.hpp>
#include <tobii/sdk/cpp/MainLoop.hpp>

namespace tetio = tobii::sdk::cpp;

//Qt wrapper for tetio::eyetracker class
class QtEyeTracker : public QObject
{
    Q_OBJECT

public:
	QtEyeTracker(tetio::EyeTrackerInfo::pointer_t info);
	void connectTo(tetio::MainLoop& mainLoop);
    bool isConnected();
    void startTracking();
    void stopTracking();
    float getFrameRate();
    QVector<float> enumerateFrameRates();
    void setFrameRate(float framerate);
    void startCalibration();
    void stopCalibration();
    void computeCalibrationAsync(const tetio::EyeTracker::async_callback_t &completedHandler);
    void addCalibrationPointAsync(const tetio::Point2d &point2d,
                                  const tetio::EyeTracker::async_callback_t &completedHandler);
	tetio::Calibration::pointer_t getCalibration();

signals:
    void connectionError(uint32_t errorCode);
    void gazeDataReceived(tetio::GazeDataItem::pointer_t gazeDataItem);
    void framerateChanged(float framerate);

public slots:

private:
    void handleConnectionError(uint32_t errorCode);
    void handleGazeDataReceived(tetio::GazeDataItem::pointer_t gazeDataItem);
    void handleFrameRateChanged(float framerate);
	tobii::sdk::cpp::EyeTrackerInfo::pointer_t m_etInfo;
    tobii::sdk::cpp::EyeTracker::pointer_t m_eyetracker;
};

#endif // EYETRACKER_H
