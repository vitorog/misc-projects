#include "image.h"

#include <QColor>
#include <QLabel>
#include <QDebug>
#include <QHBoxLayout>

Image::Image(QString path, int color_channel)
{    
    image_ = new QImage();
    loaded_ = image_->load(path);
    color_channel_ = color_channel;
    if(loaded_){
        width_ = image_->width();
        height_ = image_->height();
        display_widget_ = NULL;
    }
}

Image::Image(QImage *image, int color_channel)
{
    if(image != NULL){
        image_ = new QImage(*image);
        loaded_ = true;
        width_ = image_->width();
        height_ = image_->height();
    }else{
        loaded_ = false;
    }
    display_widget_ = NULL;
    color_channel_ = color_channel;
}

int Image::Color(int x, int y)
{
    switch(color_channel_){
    case kRed:
    case kLuminance:
        return QColor(image_->pixel(x,y)).red();
    case kGreen:
        return QColor(image_->pixel(x,y)).green();
    case kBlue:
        return QColor(image_->pixel(x,y)).blue();
    default:
        return QColor(image_->pixel(x,y)).red();
    }
}

int Image::Width()
{
    return width_;
}

int Image::Height()
{
    return height_;
}

void Image::Save(QString path)
{
    image_->save(path);
}

void Image::Display(QString header)
{
    if(display_widget_ == NULL){
        display_widget_ = new QWidget();
        display_widget_->setLayout(new QHBoxLayout());
        display_widget_->setMaximumWidth(width_);
        display_widget_->setMaximumHeight(height_);
        display_widget_->setMinimumHeight(height_);
        display_widget_->setMinimumWidth(width_);
        display_widget_->layout()->setContentsMargins(0,0,0,0);
        QLabel *image_label = new QLabel();
        image_label->setPixmap(QPixmap::fromImage(*image_));
        display_widget_->layout()->addWidget(image_label);
        display_widget_->show();
    }else{
        display_widget_->show();
    }
    display_widget_->setWindowTitle(header);
}

void Image::Close()
{
    if(display_widget_ != NULL){
        display_widget_->close();
        delete display_widget_;
        display_widget_ = NULL;
    }
}

void Image::SetPixel(int x, int y, int color)
{
    QColor current_color = QColor(image_->pixel(x,y));
    switch(color_channel_){
    case kRed:
        current_color.setRed(color);
        break;
    case kGreen:
        current_color.setGreen(color);
        break;
    case kBlue:
        current_color.setBlue(color);
        break;
    case kLuminance:
        current_color.setRed(color);
        current_color.setGreen(color);
        current_color.setBlue(color);
        break;
    }
    image_->setPixel(x,y,current_color.rgb());
}

void Image::SetPixelColor(int x, int y, int red, int green, int blue)
{
    image_->setPixel(x,y,QColor(red,green,blue).rgb());
}

QImage *Image::GetQImage()
{
    return image_;
}

bool Image::Loaded()
{
    return loaded_;
}

void Image::SetColorChannel(int color_channel)
{
    color_channel_ = color_channel;
}

int Image::ColorChannel()
{
    return color_channel_;
}
