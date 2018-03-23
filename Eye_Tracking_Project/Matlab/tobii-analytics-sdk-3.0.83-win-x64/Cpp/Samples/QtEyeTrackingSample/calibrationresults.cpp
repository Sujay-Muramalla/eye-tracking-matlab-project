#include "calibrationresults.h"
#include "ui_calibrationresults.h"
#include "plotframe.h"

using namespace tetio;

CalibrationResults::CalibrationResults(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::CalibrationResults)
{
    ui->setupUi(this);
}

CalibrationResults::~CalibrationResults()
{
    delete ui;
}

void CalibrationResults::setPlotData(Calibration::pointer_t calibrationData)
{
    ui->_leftPlot->setPlotData(calibrationData, PlotFrame::Left);
    ui->_rightPlot->setPlotData(calibrationData, PlotFrame::Right);
}


