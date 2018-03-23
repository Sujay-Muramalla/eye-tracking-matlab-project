#include "frameratedialog.h"
#include "ui_frameratedialog.h"

FrameRateDialog::FrameRateDialog(QWidget *parent) :
    QDialog(parent),
    m_ui(new Ui::FrameRateDialog)
{
    m_ui->setupUi(this);
}

FrameRateDialog::~FrameRateDialog()
{
    delete m_ui;
}

bool FrameRateDialog::execute(QWidget *parent, const QVector<float> &availableframerates, float framerate)
{
    setParent(parent, Qt::Dialog);
    initFrameRatesComboBox(availableframerates, framerate);
    return QDialog::Accepted == exec();
}

float FrameRateDialog::getSelectedFrameRate()
{
    float framerate = m_ui->framerateComboBox->itemData(m_ui->framerateComboBox->currentIndex()).toFloat();
    return framerate;
}

void FrameRateDialog::initFrameRatesComboBox(const QVector<float> &availableframerates, float framerate)
{
    m_ui->framerateComboBox->blockSignals(true);
    m_ui->framerateComboBox->clear();
    for(QVector<float>::const_iterator it = availableframerates.constBegin(); it != availableframerates.constEnd(); ++it) {
        float f = *it;
        m_ui->framerateComboBox->addItem(QString::number(f),f);
    }
    int selectedIndex = availableframerates.indexOf(framerate);
    if(selectedIndex >= 0)
        m_ui->framerateComboBox->setCurrentIndex(selectedIndex);
    m_ui->framerateComboBox->blockSignals(false);
}

