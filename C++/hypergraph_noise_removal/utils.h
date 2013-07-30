#ifndef UTILS_H
#define UTILS_H

#include <iostream>

#include "image.h"


double CalculatePSNR(Image* image_1, Image* image_2, int color_channel = 0)
{
    int width = image_1->Width();
    int height = image_1->Height();
    if(width != image_2->Width() || height != image_2->Height()){
        std::cout << "Unable to calculate PSNR. Images are of different size." << std::endl;
        return -1;
    }
    //Corrupted image
    double mse = 0;
    image_1->SetColorChannel(color_channel);
    image_2->SetColorChannel(color_channel);
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            double diff = image_2->Color(x,y) - image_1->Color(x,y);
            mse += diff*diff;

        }
    }
    mse = mse / (width*height);
    double psnr = 10*log10((255*255)/mse);
    return psnr;
}

double CalculateMAE(Image* image_1, Image* image_2, int color_channel = 0)
{
    int width = image_1->Width();
    int height = image_1->Height();
    if(width != image_2->Width() || height != image_2->Height()){
        std::cout << "Unable to calculate MAE. Images are of different size." << std::endl;
        return -1;
    }
    //Corrupted image
    double mae = 0;
    image_1->SetColorChannel(color_channel);
    image_2->SetColorChannel(color_channel);
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            double diff = image_2->Color(x,y) - image_1->Color(x,y);
            mae += abs(diff);

        }
    }
    mae = mae / (width*height);
    return mae;
}

#endif // UTILS_H
