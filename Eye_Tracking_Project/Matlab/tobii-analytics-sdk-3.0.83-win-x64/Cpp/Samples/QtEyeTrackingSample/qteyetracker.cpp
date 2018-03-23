#include "qteyetracker.h"
#include <boost/make_shared.hpp>
#include <tobii/sdk/cpp/EyeTrackerInfo.hpp>
#include <tobii/sdk/cpp/EyeTrackerFactory.hpp>
#include <tobii/sdk/cpp/EyeTracker.hpp>

using namespace tetio;

QtEyeTracker::QtEyeTracker(EyeTrackerInfo::pointer_t info) 
	: QObject(), m_etInfo(info)
{
}

bool QtEyeTracker::isConnected()
{
    return m_eyetracker != NULL;
}

void QtEyeTracker::connectTo(MainLoop& mainLoop)
{
	m_eyetracker = m_etInfo->getEyeTrackerFactory()->createEyeTracker(mainLoop);
    m_eyetracker->addConnectionErrorListener(boost::bind(&QtEyeTracker::handleConnectionError, this, _1));
    m_eyetracker->addGazeDataReceivedListener(boost::bind(&QtEyeTracker::handleGazeDataReceived, this, _1));
    m_eyetracker->addFrameRateChangedListener(boost::bind(&QtEyeTracker::handleFrameRateChanged, this, _1));
}

void QtEyeTracker::startTracking()
{
    if (isConnected())
        m_eyetracker->startTracking();
}

void QtEyeTracker::stopTracking()
{
    if (isConnected())
        m_eyetracker->stopTracking();
}

float QtEyeTracker::getFrameRate()
{
    if (isConnected())
        return m_eyetracker->getFrameRate();
    return 0;
}

QVector<float> QtEyeTracker::enumerateFrameRates()
{
    if (isConnected())
        return QVector<float>::fromStdVector(m_eyetracker->enumerateFrameRates());
    return QVector<float>();
}

void QtEyeTracker::setFrameRate(float framerate)
{
    if (isConnected())
        m_eyetracker->setFrameRate(framerate);
}

void QtEyeTracker::startCalibration()
{
    if (isConnected())
        m_eyetracker->startCalibration();
}

void QtEyeTracker::stopCalibration()
{
    if (isConnected())
        m_eyetracker->stopCalibration();
}

void QtEyeTracker::computeCalibrationAsync(const EyeTracker::async_callback_t &completedHandler)
{
    if (isConnected())
        m_eyetracker->computeCalibrationAsync(completedHandler);
}

void QtEyeTracker::addCalibrationPointAsync(const Point2d &point2d,
                              const EyeTracker::async_callback_t &completedHandler)
{
    if (isConnected())
        m_eyetracker->addCalibrationPointAsync(point2d, completedHandler);
}

Calibration::pointer_t QtEyeTracker::getCalibration()
{
    if (isConnected())
        return m_eyetracker->getCalibration();
	return boost::make_shared<CalibrationImpl>();
}

void QtEyeTracker::handleConnectionError(uint32_t errorCode)
{
    m_eyetracker.reset();
    emit connectionError(errorCode);
}

void QtEyeTracker::handleGazeDataReceived(GazeDataItem::pointer_t gazeDataItem)
{
    uint32_t trig_signal;
    if (gazeDataItem->tryGetExtensionValue(GazeDataItem::EXTENSION_TRIG_SIGNAL, trig_signal)) {
		std::cout << "Trig signal: " << trig_signal << std::endl;
    }

    emit gazeDataReceived(gazeDataItem);
}

void QtEyeTracker::handleFrameRateChanged(float framerate)
{
    emit framerateChanged(framerate);
}
