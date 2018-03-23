#include "plotframe.h"
#include <QPainter>
#include <algorithm>

using namespace std;
using namespace tetio;

PlotFrame::PlotFrame(QWidget *parent) :
    QFrame(parent),
    m_paddingRatio(0.07F),
    m_circleRadius(5)
{
}

	void PlotFrame::setPlotData(Calibration::pointer_t calibrationData, EyeOption eyeOption)
{
    m_calibrationPlotData = calibrationData->getPlotData();
    m_eyeOption = eyeOption;
    extractCalibrationPoints();
    update();
}

void PlotFrame::extractCalibrationPoints()
{
    m_calibrationPoints.clear();

    int itemCount = static_cast<int>(m_calibrationPlotData->size());
    for (int i = 0; i < itemCount; i++)
    {
        CalibrationPlotItem item = m_calibrationPlotData->at(i);
        Point2d p(item.truePosition.x, item.truePosition.y);
        point_2d_ex pex(p);
        if(std::find(m_calibrationPoints.begin(), m_calibrationPoints.end(), pex) == m_calibrationPoints.end()) {
            m_calibrationPoints.push_back(pex);
        }
    }
}

QRect PlotFrame::getCalibrationCircleBounds(Point2d center, int radius)
{
    QPoint pixelCenter = pixelPointFromNormalizedPoint(center);
    int d = 2*radius;
    return QRect(pixelCenter.x() - radius, pixelCenter.y() - radius, d, d);
}

QPoint PlotFrame::pixelPointFromNormalizedPoint(Point2d normalizedPoint)
{
    int xPadding = (int)(m_paddingRatio * width());
    int yPadding = (int)(m_paddingRatio * height());
    int canvasWidth = width() - 2 * xPadding;
    int canvasHeight = height() - 2 * yPadding;
    QPoint pixelPoint;
    pixelPoint.setX(xPadding + (int)(normalizedPoint.x * canvasWidth));
    pixelPoint.setY(yPadding + (int)(normalizedPoint.y * canvasHeight));
    return pixelPoint;
}

QRect PlotFrame::getCanvasBounds()
{
    QPoint upperLeft = pixelPointFromNormalizedPoint(Point2d(0, 0));
    QPoint lowerRight = pixelPointFromNormalizedPoint(Point2d(1, 1));
    QRect bounds;
    bounds.moveTopLeft(upperLeft);
    bounds.setWidth(lowerRight.x() - upperLeft.x());
    bounds.setHeight(lowerRight.y() - upperLeft.y());
    return bounds;
}

void PlotFrame::paintEvent(QPaintEvent *event)
{
    QFrame::paintEvent(event);
    QPainter painter(this);

    if(m_calibrationPlotData != 0 && !m_calibrationPoints.empty()) {
        // Draw calibration points
        painter.setPen(QColor(Qt::darkGray));
        int pointCount = static_cast<int>(m_calibrationPoints.size());
        for (int j = 0; j < pointCount; j++) {
            point_2d_ex pex = m_calibrationPoints.at(j);
            QRect r = getCalibrationCircleBounds(pex.point_, m_circleRadius);
            painter.drawEllipse(r);
        }

        // Draw bounds
        painter.setPen(QColor(Qt::lightGray));
        QRect canvasBounds =  getCanvasBounds();
        painter.drawRect(canvasBounds);

        // Draw errors
        int itemCount = static_cast<int>(m_calibrationPlotData->size());
        for (int i = 0; i < itemCount; i++) {
            CalibrationPlotItem item = m_calibrationPlotData->at(i);
            if ((m_eyeOption & Left) == Left) {
                if (item.leftStatus == 1) {
                    painter.setPen(QColor(Qt::red));
                    QPoint p1 = pixelPointFromNormalizedPoint(Point2d(item.truePosition.x, item.truePosition.y));
                    QPoint p2 = pixelPointFromNormalizedPoint(Point2d(item.leftMapPosition.x, item.leftMapPosition.y));
                    painter.drawLine(p1, p2);
                }
            }

            if ((m_eyeOption & Right) == Right) {
                if (item.rightStatus == 1) {
                    painter.setPen(QColor(Qt::green));
                    QPoint p1 = pixelPointFromNormalizedPoint(Point2d(item.truePosition.x,item.truePosition.y));
                    QPoint p2 = pixelPointFromNormalizedPoint(Point2d(item.rightMapPosition.x, item.rightMapPosition.y));
                    painter.drawLine(p1, p2);
                }
            }
        }
    }
}
