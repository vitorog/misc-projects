#include <QApplication>

#include <QTime>

#include <cmath>
#include <iostream>
//#include <termios.h>
#include <stdio.h>

#include "image.h"
#include "hypergraph.h"
#include "vertex.h"
#include "edge.h"
#include "spernerfilter.h"
#include "utils.h"

bool run_demo = false;

int main(int argc,char** argv)
{
    QApplication a(argc, argv);
    QStringList cmdline_args = QCoreApplication::arguments();
    if(cmdline_args.size() < 5 && !run_demo){
        std::cout << "Not enough arguments." << std::endl;
        std::cout << "Usage: ./hypergraph_filter -original_image -noisy_image -alfa -beta [-demo=yes|no] [-color_image=yes|no]" << std::endl;
        std::cout << "-demo is set to 'yes' by default." << std::endl;
#ifdef WIN32
        system("PAUSE");
#endif
    }else{
        QString original_image_path;
        QString noisy_image_path;
        int alfa = 20;
        int beta = 2;
        bool color_image = false;
        for(int i = 1; i < cmdline_args.size(); i++){
            switch(i){
            case 1:
                original_image_path = cmdline_args.at(i);
                break;
            case 2:
                noisy_image_path = cmdline_args.at(i);
                break;
            case 3:
                alfa = cmdline_args.at(i).toInt();
                break;
            case 4:
                beta = cmdline_args.at(i).toInt();
                break;
            case 5:
                run_demo = false;
                break;
            case 6:
                color_image = true;
                break;
            }
        }

        if(run_demo){
            original_image_path = "test_images/lena.tif";
            noisy_image_path = "test_images/lena_color_512_salt_20.png";
            alfa = 20;
            beta = 2;
            std::cout << "Running demo." << std::endl;
            std::cout << "Noisy image: " << noisy_image_path.toStdString() << std::endl;
            std::cout << "Alfa set to: " << alfa << std::endl;
            std::cout << "Beta set to: " << beta << std::endl;
        }

        QTime timer;
        timer.start();

        Image* original_image = new Image(original_image_path);
        if(!original_image->Loaded()){
            std::cout << "Failed to load image: " << original_image_path.toStdString() << std::endl;
            return -1;
        }

        Image* noisy_image = new Image(noisy_image_path);
        if(!original_image->Loaded()){
            std::cout << "Failed to load image: " << noisy_image_path.toStdString() << std::endl;
            return -1;
        }

        if(noisy_image->Width() != original_image->Width() || original_image->Height() != noisy_image->Height()){
            std::cout << "The images are of different size. Aborting." << std::endl;
            return -1;
        }
        original_image->Display("Original Image");
        noisy_image->Display("Noisy Image");
        if(!color_image){
            double noisy_psnr = CalculatePSNR(original_image,noisy_image);
            double noisy_mae = CalculateMAE(original_image, noisy_image);

            std::cout << "Noisy-Original PSNR: " << noisy_psnr << "%" << std::endl;
            std::cout << "Noisy-Original MAE: " << noisy_mae << "%" << std::endl;

            noisy_image->SetColorChannel(0);
            Hypergraph graph;
            graph.Build(noisy_image,alfa,beta);
            SpernerFilter sperner_filter;
            Image* filtered_image = sperner_filter.Apply(&graph,noisy_image);
            filtered_image->Display("Filtered Image");

            double filtered_psnr = CalculatePSNR(original_image,filtered_image);
            double filtered_mae = CalculateMAE(original_image, filtered_image);

            std::cout << "Filtered-Original PSNR: " << filtered_psnr << "%" << std::endl;
            std::cout << "Filtered-Original MAE: " << filtered_mae << "%" << std::endl;
        }else{
            double red_noisy_psnr = CalculatePSNR(original_image,noisy_image,1);
            double red_noisy_mae = CalculateMAE(original_image, noisy_image,1);

            std::cout << "Red Noisy-Original PSNR: " << red_noisy_psnr << "%" << std::endl;
            std::cout << "Red Noisy-Original MAE: " << red_noisy_mae << "%" << std::endl;

            double green_noisy_psnr = CalculatePSNR(original_image,noisy_image,2);
            double green_noisy_mae = CalculateMAE(original_image, noisy_image,2);

            std::cout << "Green Noisy-Original PSNR: " << green_noisy_psnr << "%" << std::endl;
            std::cout << "Green Noisy-Original MAE: " << green_noisy_mae << "%" << std::endl;

            double blue_noisy_psnr = CalculatePSNR(original_image,noisy_image,3);
            double blue_noisy_mae = CalculateMAE(original_image, noisy_image,3);

            std::cout << "Blue Noisy-Original PSNR: " << blue_noisy_psnr << "%" << std::endl;
            std::cout << "Blue Noisy-Original MAE: " << blue_noisy_mae << "%" << std::endl;

            Image* current_image = noisy_image;
            for(int i = 1; i < 4; i++){
                current_image->SetColorChannel(i);
                Hypergraph graph;
                graph.Build(current_image,alfa,beta);
                SpernerFilter sperner_filter;
                current_image = sperner_filter.Apply(&graph,current_image);
            }

            Image* filtered_image = current_image;
            filtered_image->Display("Filtered Image");

            double red_filtered_psnr = CalculatePSNR(original_image,filtered_image,1);
            double red_filtered_mae = CalculateMAE(original_image, filtered_image,1);
            std::cout << "Red Filtered-Original PSNR: " << red_filtered_psnr << "%" << std::endl;
            std::cout << "Red Filtered-Original MAE: " << red_filtered_mae << "%" << std::endl;

            double green_filtered_psnr = CalculatePSNR(original_image,filtered_image,2);
            double green_filtered_mae = CalculateMAE(original_image, filtered_image,2);
            std::cout << "Green Filtered-Original PSNR: " << green_filtered_psnr << "%" << std::endl;
            std::cout << "Green Filtered-Original MAE: " << green_filtered_mae << "%" << std::endl;

            double blue_filtered_psnr = CalculatePSNR(original_image,filtered_image,3);
            double blue_filtered_mae = CalculateMAE(original_image, filtered_image,3);
            std::cout << "Blue Filtered-Original PSNR: " << blue_filtered_psnr << "%" << std::endl;
            std::cout << "Blue Filtered-Original MAE: " << blue_filtered_mae << "%" << std::endl;


        }
        std::cout << "Finished executing in: " << timer.elapsed() << " ms" << std::endl;
        a.exec();
    }
    return 0;
}

