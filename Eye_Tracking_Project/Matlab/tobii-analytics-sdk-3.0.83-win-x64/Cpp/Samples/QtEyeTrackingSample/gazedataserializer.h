#ifndef GAZEDATASERIALIZER_H
#define GAZEDATASERIALIZER_H

#include <QObject>
#include <QTextStream>
#include <QList>

#include <tobii/sdk/cpp/GazeDataItem.hpp>
#include <tobii/sdk/cpp/Types.hpp>

namespace tetio = tobii::sdk::cpp;

//Class for save to stream received Gaze Data
class GazeDataSerializer : public QObject
{
    Q_OBJECT

public:
    explicit GazeDataSerializer();
    void clear();
    void save(QTextStream *stream);

public slots:
	void gazeDataReceived(tetio::GazeDataItem::pointer_t gazeDataItem);

private:
    typedef QList<tetio::GazeDataItem::pointer_t> DataList;

    void writeHeader(QTextStream *stream);
    void writeGazeDataItem(QTextStream *stream, tetio::GazeDataItem::pointer_t gazeDataItem);
    void writePoint3d(QTextStream *stream, const tetio::Point3d &point);
    void writePoint2d(QTextStream *stream, const tetio::Point2d &point);

    DataList m_dataList;
    static char const FieldSeparator = '\t';
    static char const MaxSaveItemCount = 20;
};

#endif // GAZEDATASERIALIZER_H
