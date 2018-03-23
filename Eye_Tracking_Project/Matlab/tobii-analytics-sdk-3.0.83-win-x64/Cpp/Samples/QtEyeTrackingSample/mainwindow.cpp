#include <QMessageBox>
#include <QFileDialog>
#include <QFile>

#include "mainwindow.h"
#include "frameratedialog.h"
#include "ui_mainwindow.h"
#include "calibrationrunner.h"
#include "calibrationresults.h"

using namespace tetio;

MainWindow::MainWindow(MainLoopThread &mainloopThread, QWidget *parent) :
    QMainWindow(parent),
    m_ui(new Ui::MainWindow),
    m_eyetrackersController(mainloopThread),
    m_eyetracker(0),
    m_gazeDataSerializer(),
    m_isTracking(false)
{
    init();
}

MainWindow::~MainWindow()
{
    disconnectEyeTracker();
    delete m_ui;
    delete m_connectionStatusLabel;
    delete m_trackStatusWidget;
    delete m_listdelegate;
}

void MainWindow::init()
{
    setWindowFlags(windowFlags() & ~Qt::WindowMaximizeButtonHint);
    m_ui->setupUi(this);

    //Create a ListviewDelegate for custom drawing
    m_listdelegate = new ListviewDelegate();
    m_ui->listView->setItemDelegate(m_listdelegate);

    m_ui->listView->setModel(m_eyetrackersController.getModel());

    m_connectionStatusLabel = new QLabel();
    m_connectionStatusLabel->setFrameShadow(QFrame::Plain);
    m_connectionStatusLabel->setFrameShape(QFrame::NoFrame);
    m_connectionStatusLabel->setText("Disconnected");
    m_ui->statusBar->addWidget(m_connectionStatusLabel);

    // Listen for selection changes
    QItemSelectionModel *selectionModel = m_ui->listView->selectionModel();
    connect(selectionModel, SIGNAL(currentChanged(QModelIndex,QModelIndex)),
            this, SLOT(currentItemChanged(QModelIndex)));

    connect(m_ui->connectButton, SIGNAL(clicked()), this, SLOT(connectSelectedEyeTracker()));
    connect(m_ui->startTrackingButton, SIGNAL(clicked()), this, SLOT(startTracking()));
    connect(m_ui->changeFrameRateButton, SIGNAL(clicked()), this, SLOT(changeFrameRate()));
    connect(m_ui->runCalibrationButton, SIGNAL(clicked()), this, SLOT(runCalibration()));

    m_trackStatusWidget = new TrackStatusWidget();
    m_trackStatusWidget->setEnabled(false);
    m_ui->trackStatusLayout->addWidget(m_trackStatusWidget);
}


void MainWindow::currentItemChanged(const QModelIndex &current)
{
    QString selectedProductId = qvariant_cast<QString>(current.data(ListviewDelegate::ProductIdRole));
    if (m_eyetrackersController.isExist(selectedProductId)) {
        QString selectedModel = qvariant_cast<QString>(current.data(ListviewDelegate::ModelRole));
        QString selectedStatus = qvariant_cast<QString>(current.data(ListviewDelegate::StatusRole));
        QString selectedGeneration = qvariant_cast<QString>(current.data(ListviewDelegate::GenerationRole));
        QString selectedGivenName = qvariant_cast<QString>(current.data(ListviewDelegate::GivenNameRole));
        QString selectedFirmwareVersion = qvariant_cast<QString>(current.data(ListviewDelegate::FirmwareVersionRole));

        m_ui->labelModelValue->setText(selectedModel);
        m_ui->labelStatusValue->setText(selectedStatus);
        m_ui->labelGenerationValue->setText(selectedGeneration);
        m_ui->labelProductIdValue->setText(selectedProductId);
        m_ui->labelGivenNameValue->setText(selectedGivenName);
        m_ui->labelFirmwareVersionValue->setText(selectedFirmwareVersion);
        m_ui->connectButton->setEnabled(true);
    }
    else {
        m_ui->labelModelValue->setText("");
        m_ui->labelStatusValue->setText("");
        m_ui->labelGenerationValue->setText("");
        m_ui->labelProductIdValue->setText("");
        m_ui->labelGivenNameValue->setText("");
        m_ui->labelFirmwareVersionValue->setText("");
        m_ui->connectButton->setEnabled(false);
    }
}

void MainWindow::connectSelectedEyeTracker()
{
    QString selProductId = selectedProductId();
    if (!selProductId.isEmpty()) {
        disconnectEyeTracker();
        m_eyetracker = m_eyetrackersController.connectTo(selProductId);
        if (m_eyetracker) {
            connect(m_eyetracker, SIGNAL(connectionError(uint32_t)),
                this, SLOT(eyetrackerConnectionError(uint32_t)), Qt::QueuedConnection);
            connect(m_eyetracker, SIGNAL(framerateChanged(float)),
                this, SLOT(framerateChanged(float)), Qt::QueuedConnection);
            m_connectionStatusLabel->setText(QString("Connected to %1").arg(selProductId));
            m_ui->startTrackingButton->setEnabled(true);
            m_ui->labelFrameRateValue->setText(QString::number(m_eyetracker->getFrameRate()));
            m_ui->changeFrameRateButton->setEnabled(true);
            m_ui->runCalibrationButton->setEnabled(true);
        }
    }
}

QString MainWindow::selectedProductId()
{
    QModelIndexList selectionList = m_ui->listView->selectionModel()->selectedRows();
    if(selectionList.size() > 0) {
        const QModelIndex &selectedIndex = selectionList[0];
        QString productId = qvariant_cast<QString>(selectedIndex.data(ListviewDelegate::ProductIdRole));
        return productId;
    }
    return QString("");
}

void MainWindow::disconnectEyeTracker()
{
    if (m_eyetracker) {
        delete m_eyetracker;
        m_eyetracker = NULL;
    }
    m_connectionStatusLabel->setText("Disconnected");
    m_ui->startTrackingButton->setEnabled(false);
    m_ui->runCalibrationButton->setEnabled(false);
    m_ui->changeFrameRateButton->setEnabled(false);
    m_ui->labelFrameRateValue->setText("");
    m_isTracking = false;
    updateTrackingUI(false);
    m_gazeDataSerializer.clear();
}

void MainWindow::eyetrackerConnectionError(uint32_t errorCode)
{
    disconnectEyeTracker();
    showError(QString("EyeTracker connection error 0x%1").arg(QString::number(errorCode, 16)));
}

void MainWindow::framerateChanged(float framerate)
{
    if (m_eyetracker)
        m_ui->labelFrameRateValue->setText(QString::number(framerate));
}

void MainWindow::changeFrameRate()
{
    if (m_eyetracker) {
        FrameRateDialog frameratedialog;
        QVector<float> availableFrameRates = m_eyetracker->enumerateFrameRates();
        float framerate = m_eyetracker->getFrameRate();
        if (frameratedialog.execute(this, availableFrameRates, framerate))
            m_eyetracker->setFrameRate(frameratedialog.getSelectedFrameRate());
    }
}

void MainWindow::startTracking()
{
    if (m_eyetracker) {
        if (m_isTracking) {
            m_eyetracker->stopTracking();
            m_isTracking = false;
            updateTrackingUI(false);
            disconnect(m_eyetracker, SIGNAL(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                       m_trackStatusWidget, SLOT(gazeDataReceived(tetio::GazeDataItem::pointer_t)));
            disconnect(m_eyetracker, SIGNAL(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                       &m_gazeDataSerializer, SLOT(gazeDataReceived(tetio::GazeDataItem::pointer_t)));
            saveGazeDataToFile();
            m_gazeDataSerializer.clear();
        }
        else {
            m_eyetracker->startTracking();
            m_isTracking = true;
            updateTrackingUI(true);
            m_gazeDataSerializer.clear();
            connect(m_eyetracker, SIGNAL(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                    m_trackStatusWidget, SLOT(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                    Qt::QueuedConnection);
            connect(m_eyetracker, SIGNAL(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                    &m_gazeDataSerializer, SLOT(gazeDataReceived(tetio::GazeDataItem::pointer_t)),
                    Qt::QueuedConnection);
        }
    }
}

void MainWindow::runCalibration()
{
    if (m_eyetracker) {
        CalibrationRunner runner(m_eyetracker, this);
		Calibration::pointer_t result = runner.runCalibration();
        if (result) {
            CalibrationResults resultForm(0);
            resultForm.setPlotData(result);
            resultForm.exec();
            result.reset();
        } else {
            showError(QString("Not enough data to create a calibration (or calibration aborted)."));
        }
    }
}

void MainWindow::updateTrackingUI(bool start)
{
    if (start) {
        m_ui->startTrackingButton->setText("Stop Tracking");
        m_trackStatusWidget->setEnabled(true);
    } else {
        m_ui->startTrackingButton->setText("Start Tracking");
        m_trackStatusWidget->setEnabled(false);
    }
}

void MainWindow::showError(const QString &text)
{
    QMessageBox msgBox;
    msgBox.setIcon(QMessageBox::Critical);
    msgBox.setText(text);
    msgBox.exec();
}

void MainWindow::saveGazeDataToFile()
{
    QString filename =
            QFileDialog::getSaveFileName(this, "Save Gaze Data", QDir::currentPath(), "*.tsv");
    if (!filename.isNull()) {
        if (QFile::exists(filename))
            if (!QFile::remove(filename)) {
                showError(QString("Can not remove file"));
                return;
            }
        QFile file(filename);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            showError(QString("Can not open file"));
            return;
        }
        QTextStream stream(&file);
        m_gazeDataSerializer.save(&stream);
    }
}
