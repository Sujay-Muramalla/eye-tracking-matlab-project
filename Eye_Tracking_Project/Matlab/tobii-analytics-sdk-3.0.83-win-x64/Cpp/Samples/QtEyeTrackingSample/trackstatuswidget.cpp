#include <QtGui>

#include "trackstatuswidget.h"

using namespace tetio;

TrackStatusWidget::TrackStatusWidget(QWidget *parent) :
    QWidget(parent),
    m_leftEye(),
    m_rightEye(),
    m_leftValidity(0),
    m_rightValidity(0)
{
    m_backgroundBrush = QBrush(QColor(Qt::black));
    m_eyeBrush = QBrush(QColor(Qt::white));
}

void TrackStatusWidget::clear()
{
    m_dataHistory.clear();
    m_leftEye = Point3d();
    m_rightEye = Point3d();
    m_leftValidity = 0;
    m_rightValidity = 0;
    repaint();
}

void TrackStatusWidget::gazeDataReceived(GazeDataItem::pointer_t gazeDataItem)
{
    m_dataHistory.append(gazeDataItem);
    while (m_dataHistory.size() > TrackStatusWidget::HistorySize)
        m_dataHistory.removeFirst();
    m_leftEye = gazeDataItem->leftEyePosition3dRelative;
    m_rightEye = gazeDataItem->rightEyePosition3dRelative;
    m_leftValidity = gazeDataItem->leftValidity;
    m_rightValidity = gazeDataItem->rightValidity;
    repaint();
}

void TrackStatusWidget::paintEvent(QPaintEvent *event)
{
    QPainter painter;
    painter.begin(this);
    painter.fillRect(event->rect(), m_backgroundBrush);
    paintStatusBar(event, &painter);
    paintEyes(event, &painter);
    painter.end();
}

void TrackStatusWidget::paintStatusBar(const QPaintEvent *event, QPainter *painter)
{
    painter->save();
    QBrush brush = calcStatusBarBrush();
    QRect rect = QRect(0, event->rect().height() - TrackStatusWidget::StatusBarHeight,
                       event->rect().width(), TrackStatusWidget::StatusBarHeight);
    painter->fillRect(rect, brush);
    painter->restore();
}

void TrackStatusWidget::paintEyes(const QPaintEvent *event, QPainter *painter)
{
    if (!isEnabled())
        return;
    paintLeftEye(event, painter);
    paintRightEye(event, painter);
}

void TrackStatusWidget::paintLeftEye(const QPaintEvent *event, QPainter *painter)
{
    paintEye(event, painter, m_leftEye, m_leftValidity);
}

void TrackStatusWidget::paintRightEye(const QPaintEvent *event, QPainter *painter)
{
    paintEye(event, painter, m_rightEye, m_rightValidity);
}

QBrush TrackStatusWidget::calcStatusBarBrush()
{
    if (!isEnabled())
        return QBrush(QColor(Qt::gray));
    double dataQuality = calcDataQuality();
    if (dataQuality > 0.8)
        return QBrush(QColor(Qt::green));
    return QBrush(QColor(Qt::red));
}

double TrackStatusWidget::calcDataQuality()
{
    int quality = 0;
    int count = 0;
    for (DataHistory::const_iterator it = m_dataHistory.constBegin(); it != m_dataHistory.constEnd(); ++it) {
        GazeDataItem::pointer_t item = *it;
        if ((item->leftValidity == TrackStatusWidget::NoEyesFound) &&
                (item->rightValidity == TrackStatusWidget::NoEyesFound))
            quality += 0;
        else if ((item->leftValidity == TrackStatusWidget::FoundTwoEyes) &&
                 (item->rightValidity == TrackStatusWidget::FoundTwoEyes))
            quality += 2;
        else
            quality++;
        count++;
    }
    return (count == 0 ? 0 : quality / (2.0 * count));
}

void TrackStatusWidget::paintEye(const QPaintEvent *event, QPainter *painter,
                                 const Point3d &eyePoint,
                                 int eyeValidity)
{
    if (eyeValidity <= 2) {
        painter->save();
        painter->setBrush(m_eyeBrush);
        painter->drawEllipse(calcEyeRect(eyePoint, event));
        painter->restore();
    }
}

QRectF TrackStatusWidget::calcEyeRect(const Point3d &eyePoint, const QPaintEvent *event)
{
    return QRectF(
                ((1.0 - eyePoint.x) * event->rect().width() - TrackStatusWidget::EyeRadius),
                (eyePoint.y * event->rect().height() - TrackStatusWidget::EyeRadius),
                2 * TrackStatusWidget::EyeRadius,
                2 * TrackStatusWidget::EyeRadius);
}




