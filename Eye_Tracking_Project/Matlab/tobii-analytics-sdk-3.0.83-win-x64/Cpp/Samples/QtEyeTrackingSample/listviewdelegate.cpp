#include "listviewdelegate.h"

ListviewDelegate::ListviewDelegate()
{
}

ListviewDelegate::~ListviewDelegate()
{
}

//alocate each item size in listview.
QSize ListviewDelegate::sizeHint(const QStyleOptionViewItem &,
                              const QModelIndex &index) const
{
    QPixmap icon = qvariant_cast<QPixmap>(index.data(IconRole));
    QSize iconsize = icon.size();
    return(QSize(iconsize.width(),iconsize.height()));
}

void ListviewDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option,
                           const QModelIndex &index) const
 {
    // This code handles the custom drawing of listview items

    QStyledItemDelegate::paint(painter,option,index);

    painter->save();

    // Get fonts
    QFont font = QApplication::font();
    font.setBold(true);
    font.setPointSizeF(10);

    QFont subFont = QApplication::font();
    subFont.setWeight(subFont.weight()-2);


    // Get icon and texts
    QPixmap icon = qvariant_cast<QPixmap>(index.data(IconRole));
    QString headerText = qvariant_cast<QString>(index.data(HeaderTextRole));
    QString subText = qvariant_cast<QString>(index.data(SubHeaderTextRole));

    // Draw icon
    QSize iconSize = icon.size();
    QPoint iconPosition= option.rect.topLeft();
    painter->drawPixmap(iconPosition, icon);

    // Compute text rectangles
    QRect headerRect = option.rect;
    QFontMetrics fm(font);
    headerRect.setLeft(iconPosition.x() + iconSize.width() + 6);
    headerRect.setTop(iconPosition.y() + 5);
    headerRect.setBottom(headerRect.top() + fm.height());

    QRect subheaderRect = option.rect;
    subheaderRect.setLeft(headerRect.left());
    subheaderRect.setTop(headerRect.bottom());

    // Draw text
    painter->setFont(font);
    painter->drawText(headerRect,headerText);

    painter->setFont(subFont);
    painter->drawText(subheaderRect.left(),subheaderRect.top()+17,subText);

    painter->restore();

 }
