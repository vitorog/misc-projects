#include "spernerfilter.h"

#include <cmath>

SpernerFilter::SpernerFilter()
{   
}

SpernerFilter::~SpernerFilter()
{
    noisy_edges_.clear();
    test_edges_.clear();
}

Image *SpernerFilter::Apply(Hypergraph *g , Image *img)
{
    graph_ = g;
    input_image_ = img;
    BuildSpernerGraph();
    FindNoisyEdges();
    return RemoveNoise();
}


void SpernerFilter::BuildSpernerGraph()
{
    std::cout << "Starting to build Sperner Graph" << std::endl;
    for(int i = 0; i < graph_->edges_.size(); i++){
        PrintProgress(i, graph_->edges_.size());
        Edge* e1 = graph_->edges_.at(i);
        Vertex* v1 = e1->v_list_.at(0);
        for(int j = 0; j < e1->v_list_.size(); j++){
            Edge* e2 = e1->v_list_.at(j)->edge_;
            if(e1 == e2 || e2 == NULL) continue;
            Vertex* v2 = e2->v_list_.at(0);
            if(e1->Contains(e2)){
                e1->Unite(e2);
                graph_->edges_.removeOne(e2);
                v2->edge_ = NULL;
            }else if(e2->Contains(e1)){
                e2->Unite(e1);
                graph_->edges_.removeOne(e1);
                v1->edge_ = NULL;
                i = i - 2;
                if(i < -1){
                    i = -1;
                }
                break;
            }
        }
    }
    std::cout << std::endl;
    std::cout << "100%\nDone." << std::endl;
    std::cout << "Total edges: " << graph_->edges_.size() << std::endl;
}

void SpernerFilter::FindNoisyEdges()
{
    std::cout << "Searching for noisy edges" << std::endl;
    for(int i = 0; i < graph_->edges_.size(); i++){
        PrintProgress(i, graph_->edges_.size());
        Edge* e1 = graph_->edges_.at(i);
        if(e1->noisy_) continue;
        bool noisy = true;
        if(e1->v_list_.size() > 1){
            for(int j = 0; j < e1->v_list_.size(); j++){
                Vertex* v = e1->v_list_.at(j);
                Edge* e2 = v->edge_;
                if(e1==e2 || e2==NULL) continue;
                if(e1->Intersects(e2)){
                    if(!e2->noisy_){
                        //The following code handles the case
                        //in which an edge intersects with another noisy one
                        //but the other is not marked as noisy yet
                        int luminance = e2->v_list_.at(0)->luminance_;
                        noisy = true;
                        for(int i = 1; i < e2->v_list_.size(); i++){
                            if(e2->v_list_.at(i)->luminance_ != luminance){
                                noisy = false;
                                break;
                            }
                        }
                        if(noisy){
                            noisy_edges_.push_back(e2);
                            e2->noisy_ = true;
                        }
                        //                        noisy = true;
                        //                        if(e2->max_l_ == e2->min_l_){
                        //                            noisy_edges_.push_back(e2);
                        //                            e2->noisy_ = true;
                        //                        }else{
                        //                            noisy = false;
                        //                        }
                        break;
                    }else{
                        break;
                    }
                }
            }
        }
        if(noisy){
            noisy_edges_.push_back(e1);
            e1->noisy_ = true;
        }
    }
    std::cout << std::endl;
    std::cout << "100%\nDone." << std::endl;
    std::cout << "Total noisy edges: " << noisy_edges_.size() << std::endl;
}

Image* SpernerFilter::PostProcess(Hypergraph* g, Image *img)
{
    graph_ = g;
    input_image_ = img;
    noisy_edges_.clear();
    std::cout << "Starting post-processing." << std::endl;
    for(int i = 0; i < graph_->edges_.size(); i++){
        PrintProgress(i, graph_->edges_.size());
        Edge* e1 = graph_->edges_.at(i);
        if(e1->noisy_) continue;
        bool noisy = true;
        if(e1->v_list_.size() > 1){
            int luminance = e1->v_list_.at(0)->luminance_;
            noisy = true;
            for(int j = 1; j < e1->v_list_.size(); j++){
                if(e1->v_list_.at(j)->luminance_ != luminance){
                    noisy = false;
                    break;
                }
            }
        }
        if(noisy){
            noisy_edges_.push_back(e1);
            e1->noisy_ = true;
        }
    }
    std::cout << std::endl;
    std::cout << "100%\nDone." << std::endl;
    std::cout << "Total edges to be post-processed: " << noisy_edges_.size() << std::endl;
    return RemoveNoise();
}


Image* SpernerFilter::RemoveNoise()
{
    noise_image_ = new Image(input_image_->GetQImage(),input_image_->ColorChannel());
    filtered_image_ = new Image(input_image_->GetQImage(),input_image_->ColorChannel());
    std::cout << "Starting noise-removal." << std::endl;
    for(int i = 0; i < noisy_edges_.size(); i++){
        PrintProgress(i, noisy_edges_.size());
        Edge* e = noisy_edges_.at(i);
        for(int k=0; k  < e->v_list_.size(); k++){
            Vertex* v1 = e->v_list_.at(k);
            double sum = 0;
            QVector<int> median_vector;
            for(int j = 0; j < v1->neighbours_.size(); j++){
                Vertex* v2 = v1->neighbours_.at(j);
                sum = sum + (v2->luminance_*v2->luminance_);
                median_vector.push_back(v2->luminance_);
            }
            qSort(median_vector);
            int pos = floor(median_vector.size()/2);
            int luminance = median_vector.at(pos);
            sum = sum/v1->neighbours_.size();
            if(luminance == 255 || luminance == 0){
                luminance = (int)sqrt(sum);
            }
            //Alpha-Trimmed Median Filter
            //            QList<int> median_vector;
            //            for(int j = 0; j < v1->neighbours_.size(); j++){
            //                Vertex* v2 = v1->neighbours_.at(j);
            //                sum = sum + (v2->luminance_*v2->luminance_);
            //                if(v2->luminance_ != 0 || v2->luminance_ != 255){
            //                    median_vector.push_back(v2->luminance_);
            //                }
            //            }
            //            qSort(median_vector);
            //            int pos = floor(median_vector.size()/2);
            //            int luminance = median_vector.at(pos);
            //            sum = sum/v1->neighbours_.size();
            //            if(luminance == 255 || luminance == 0){
            //                luminance = (int)sqrt(sum);
            //            }
            v1->luminance_ = luminance;
            filtered_image_->SetPixel(v1->x_,v1->y_,luminance);
            noise_image_->SetPixelColor(v1->x_,v1->y_,255,0,0);
        }
    }
    noise_image_->Save("noise.png");
    filtered_image_->Save("filtered.png");
    std::cout << std::endl;
    std::cout << "100%\nDone." << std::endl;
    return filtered_image_;
}
