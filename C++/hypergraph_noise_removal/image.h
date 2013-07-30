#ifndef IMAGE_H
#define IMAGE_H

#include <QWidget>
#include <QImage>
#include <QPixmap>
#include <QString>

typedef QVector<QVector<int> > matrix;

enum ColorChannel { kLuminance = 0, kRed, kGreen, kBlue };

class Image
{
public:
    Image(QString path, int color_channel = 0);
    Image(QImage*, int color_channel = 0);
    int Color(int x, int y);
    int Width();
    int Height();
    void Save(QString path);
    void Display(QString header);
    void Close();
    void SetPixel(int x, int y, int color);
    void SetPixelColor(int x, int y, int red,int green, int blue);
    QImage* GetQImage();
    bool Loaded();
    void SetColorChannel(int color_channel);
    int ColorChannel();
private:
    int width_;
    int height_;
    int color_channel_;
    QWidget *display_widget_;
    QImage *image_;
    bool loaded_;
};

#endif // IMAGE_H
