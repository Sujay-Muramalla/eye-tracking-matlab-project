#include "calibrationdialog.h"
#include "ui_calibrationdialog.h"
#include <QPainter>

using namespace tetio;

#define RADIUS	22

CalibrationDialog::CalibrationDialog(QWidget *parent) :
    QDialog(parent),
    m_pixelRadius(RADIUS),
    ui(new Ui::CalibrationDialog)
{
    ui->setupUi(this);
}

CalibrationDialog::~CalibrationDialog()
{
    delete ui;
}

void CalibrationDialog::drawCalibrationPoint(Point2d point)
{

    m_calibrationPoint = point;
    m_pointColor = QColor(Qt::yellow);
    update();
}

void CalibrationDialog::clearCalibrationPoint()
{
    m_pointColor = QColor(Qt::transparent); 
    update();
}

Point2d CalibrationDialog::getCalibrationPoint()
{
    return m_calibrationPoint;
}

void CalibrationDialog::paintEvent(QPaintEvent *event)
{
    QDialog::paintEvent(event);
    QPainter painter(this);
    
    // Draw calibration circle
    const QSize appSize = this->size();

    QRect circleBounds;
    circleBounds.setX((int) (appSize.width() * m_calibrationPoint.x - m_pixelRadius));
    circleBounds.setY((int) (appSize.height() * m_calibrationPoint.y - m_pixelRadius));
    circleBounds.setWidth(2 * m_pixelRadius);
    circleBounds.setHeight(2 * m_pixelRadius);
      
    QRect smallCircleBounds;
    smallCircleBounds.setX((int)(appSize.width() * m_calibrationPoint.x - 1));
    smallCircleBounds.setY((int)(appSize.height() * m_calibrationPoint.y - 1));
    smallCircleBounds.setWidth(2);
    smallCircleBounds.setHeight(2);

    QColor penColor = m_pointColor == QColor(Qt::transparent) ? QColor(Qt::transparent) : QColor(Qt::black);
    painter.setPen( QPen(QColor(penColor) ) );
    painter.setBrush(QBrush(m_pointColor));
	
    painter.setRenderHint(QPainter::Antialiasing);
    painter.drawEllipse(circleBounds);

    QColor brushColor = m_pointColor == QColor(Qt::transparent) ? QColor(Qt::transparent) : QColor(Qt::black);
    painter.setBrush(QBrush(brushColor));
    painter.drawEllipse(smallCircleBounds);
}

void CalibrationDialog::showEvent(QShowEvent *event)
{
    emit calibrationDialogLoaded();
    QDialog::showEvent( event );
}
