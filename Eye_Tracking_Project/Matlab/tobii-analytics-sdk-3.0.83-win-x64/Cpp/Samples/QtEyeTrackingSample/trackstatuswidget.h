#ifndef TRACKSTATUSWIDGET_H
#define TRACKSTATUSWIDGET_H

#include <QWidget>
#include <QBrush>
#include <QList>

QT_BEGIN_NAMESPACE
class QPainter;
class QPaintEvent;
QT_END_NAMESPACE

#include <tobii/sdk/cpp/GazeDataItem.hpp>

namespace tetio = tobii::sdk::cpp;

//QWidget for visualization received Gaze Data
class TrackStatusWidget : public QWidget
{
    Q_OBJECT

public:
    explicit TrackStatusWidget(QWidget *parent = 0);
    void clear();

signals:
    
public slots:
    void gazeDataReceived(tetio::GazeDataItem::pointer_t gazeDataItem);

protected:
    void paintEvent(QPaintEvent *event);

private:
    typedef QList<tetio::GazeDataItem::pointer_t> DataHistory;

    void paintStatusBar(const QPaintEvent *event, QPainter *painter);
    void paintEyes(const QPaintEvent *event, QPainter *painter);
    void paintLeftEye(const QPaintEvent *event, QPainter *painter);
    void paintRightEye(const QPaintEvent *event, QPainter *painter);
    void paintEye(const QPaintEvent *event, QPainter *painter,
                  const tetio::Point3d &eyePoint,
                  int eyeValidity);
    QRectF calcEyeRect(const tetio::Point3d &eyePoint, const QPaintEvent *event);

    QBrush calcStatusBarBrush();
    double calcDataQuality();

    DataHistory m_dataHistory;
    QBrush m_backgroundBrush;
    QBrush m_eyeBrush;

    tetio::Point3d m_leftEye;
    tetio::Point3d m_rightEye;
    int m_leftValidity;
    int m_rightValidity;

    static const int StatusBarHeight = 25;
    static const int HistorySize = 30;
    static const int EyeRadius = 8;

    //Tobii SDK Guide
    enum ValidityCode {
        FoundTwoEyes = 0,
        FoundOneUnknownEye = 2,
        FoundOneEye = 3,
        NoEyesFound = 4
    };
};

#endif // TRACKSTATUSWIDGET_H
