#include <tobii/sdk/cpp/Types.hpp>

#include "gazedataserializer.h"

using namespace tetio;

GazeDataSerializer::GazeDataSerializer() :
    QObject()
{
}

void GazeDataSerializer::clear()
{
    m_dataList.clear();
}

void GazeDataSerializer::save(QTextStream *stream)
{
    writeHeader(stream);
    int count = 0;
    for (DataList::const_iterator it = m_dataList.constBegin(); it != m_dataList.constEnd(); ++it) {
        writeGazeDataItem(stream, *it);
        *stream << '\n';
        count++;
        if (count >= MaxSaveItemCount)
            break;
    }
}

void GazeDataSerializer::gazeDataReceived(GazeDataItem::pointer_t gazeDataItem)
{
    m_dataList.append(gazeDataItem);
}

void GazeDataSerializer::writeHeader(QTextStream *stream)
{
    *stream << "time_stamp" << GazeDataSerializer::FieldSeparator;
    *stream << "left_eye_position_3d (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "right_eye_position_3d (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "left_validity" << GazeDataSerializer::FieldSeparator;
    *stream << "right_validity" << GazeDataSerializer::FieldSeparator;
    *stream << "left_eye_position_3d_relative (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "right_eye_position_3d_relative (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "left_gaze_point_3d (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "right_gaze_point_3d (x,y,z)" << GazeDataSerializer::FieldSeparator;
    *stream << "left_gaze_point_2d (x,y)" << GazeDataSerializer::FieldSeparator;
    *stream << "right_gaze_point_2d (x,y)" << GazeDataSerializer::FieldSeparator;
    *stream << "left_pupil_diameter" << GazeDataSerializer::FieldSeparator;
    *stream << "right_pupil_diameter" << '\n';
}

void GazeDataSerializer::writePoint3d(QTextStream *stream, const Point3d &point)
{
    *stream << '(' << point.x << ',' << point.y << ',' << point.z << ')';
}

void GazeDataSerializer::writePoint2d(QTextStream *stream, const Point2d &point)
{
    *stream << '(' << point.x << ',' << point.y << ')';
}

void GazeDataSerializer::writeGazeDataItem(QTextStream *stream, GazeDataItem::pointer_t gazeDataItem)
{
    *stream << gazeDataItem->timestamp << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->leftEyePosition3d);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->rightEyePosition3d);
    *stream << GazeDataSerializer::FieldSeparator;
    *stream << gazeDataItem->leftValidity << GazeDataSerializer::FieldSeparator;
    *stream << gazeDataItem->rightValidity << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->leftEyePosition3dRelative);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->rightEyePosition3dRelative);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->leftGazePoint3d);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint3d(stream, gazeDataItem->rightGazePoint3d);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint2d(stream, gazeDataItem->leftGazePoint2d);
    *stream << GazeDataSerializer::FieldSeparator;
    writePoint2d(stream, gazeDataItem->rightGazePoint2d);
    *stream << GazeDataSerializer::FieldSeparator;
    *stream << gazeDataItem->leftPupilDiameter << GazeDataSerializer::FieldSeparator;
    *stream << gazeDataItem->rightPupilDiameter;
}
