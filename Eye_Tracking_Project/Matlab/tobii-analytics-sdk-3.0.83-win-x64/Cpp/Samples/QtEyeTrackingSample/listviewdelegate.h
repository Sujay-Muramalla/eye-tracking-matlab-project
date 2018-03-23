#ifndef LISTVIEWDELEGATE_H
#define LISTVIEWDELEGATE_H

#include <QtGui>

//Class for custom drawing QListView::Items
class ListviewDelegate : public QStyledItemDelegate 
{
public:
    ListviewDelegate();
    virtual ~ListviewDelegate();

    enum {
        HeaderTextRole = Qt::UserRole + 100,
        SubHeaderTextRole = Qt::UserRole + 101,
        IconRole = Qt::UserRole + 102,
        ProductIdRole = Qt::UserRole + 103,
        ModelRole = Qt::UserRole + 104,
        StatusRole = Qt::UserRole + 105,
        GenerationRole = Qt::UserRole + 106,
        GivenNameRole = Qt::UserRole + 107,
        FirmwareVersionRole = Qt::UserRole + 108
    };

    void paint(QPainter *painter, const QStyleOptionViewItem &option,
               const QModelIndex &index) const;

    QSize sizeHint(const QStyleOptionViewItem &option,
                   const QModelIndex &index ) const;

};

#endif // LISTVIEWDELEGATE_H

