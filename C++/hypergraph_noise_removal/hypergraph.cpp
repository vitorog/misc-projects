#include "hypergraph.h"
#include <iostream>
#include "edge.h"
#include <cmath>

#include <QDebug>

Hypergraph::Hypergraph()
{
    current_progress_ = 0;
}

Hypergraph::~Hypergraph()
{
    while(!nodes_.empty()){
        Vertex* v = nodes_.at(0);
        nodes_.removeOne(v);
        delete v;
    }
    stars_.clear();
    nodes_map_.clear();
    edges_.clear();
}

Hypergraph::Hypergraph(Image* img, int alfa, int beta,
                       int starting_x,int starting_y,int window_width,int window_height)
{ 
    image_ = img;
    Build(img,alfa,beta,starting_x,starting_y,window_width,window_height);
}

void Hypergraph::Build(Image * img, int alfa, int beta)
{
    image_ = img;
    Build(img,alfa,beta,0,0,img->Width(),img->Height());
}

void Hypergraph::Build(Image* img, int alfa, int beta,
                       int starting_x,int starting_y,int window_width,int window_height)
{
    std::cout << "Starting Graph Build" << std::endl;
    alfa_ = alfa;
    beta_ = beta;
    image_ = img;
    image_width_ = img->Width();
    image_height_ = img->Height();
    starting_x_ = starting_x;
    starting_y_ = starting_y;
    window_width_ = window_width;
    window_height_ = window_height;

    ending_x_ = starting_x_ + window_width_;
    ending_y_ = starting_y_ + window_height_;
    if(ending_x_ > image_width_){
        ending_x_ = image_width_;
    }
    if(ending_y_ > image_height_){
        ending_y_ = image_height_;
    }

    for(int y=starting_y_; y < ending_y_; y++){
        PrintProgress(y, ending_y_);
        for(int x=starting_x_; x < ending_x_; x++){
            int min_x = x-beta_ >= starting_x_ ? x-beta_ : starting_x_;
            int max_x = x+beta_ < ending_x_ ? x+beta_ : ending_x_-1;
            int min_y = y-beta_ >= starting_y_ ? y-beta_ : starting_y_;
            int max_y = y+beta_ < ending_y_ ? y+beta_ : ending_y_-1;

            int v1_index = y*window_width_ + x + 1;
            Vertex* v1;
            if(this->nodes_map_.find(v1_index) == this->nodes_map_.end()){
                v1 = new Vertex();
                v1->id_ = v1_index;
                v1->x_ = x;
                v1->y_ = y;                
                v1->luminance_ = image_->Color(x,y);
                v1->edge_ = new Edge();
                v1->edge_->AddVertex(v1);
                v1->edge_->id_ = v1->id_;
                v1->star_.insert(v1->edge_);
                this->nodes_map_.insert(v1_index,v1);
                this->nodes_.push_back(v1);
            }else{
                v1 = (*this->nodes_map_.find(v1_index));
            }
            edges_.push_back(v1->edge_);            
            stars_.push_back(&v1->star_);
            for(int j = min_y; j <= max_y; j++){
                for(int i = min_x; i <= max_x; i++){
                    int v2_index = j*window_width_ + i + 1;
                    if(v1_index == v2_index){
                        continue;
                    }

                    Vertex* v2;
                    if(this->nodes_map_.find(v2_index) == this->nodes_map_.end()){
                        v2 = new Vertex();
                        v2->id_ = v2_index;
                        v2->x_ = i;
                        v2->y_ = j;
                        v2->luminance_ = image_->Color(i,j);
                        v2->star_.insert(v2->edge_);
                        v2->edge_ = new Edge();
                        v2->edge_->AddVertex(v2);
                        v2->edge_->id_ = v2->id_;
                        this->nodes_map_.insert(v2_index,v2);
                        this->nodes_.push_back(v2);
                    }else{
                        v2 = (*this->nodes_map_.find(v2_index));
                    }
                    v1->neighbours_.push_back(v2);
                    int l1 = v1->luminance_;
                    int l2 = v2->luminance_;
                    double euclidean_distance = sqrt((l1-l2)*(l1-l2));
                    if(euclidean_distance <= alfa){
                        v1->edge_->AddVertex(v2);                       
                        v2->star_.insert(v1->edge_);
                    }
                }
            }
        }
    }
    std::cout << std::endl;
    std::cout << "100%\nDone." << std::endl;
}

void Hypergraph::PrintGraph()
{
    for(int i = 0; i < edges_.size(); i++){
        std::cout << "E" << edges_.at(i)->id_ << " ";
        edges_.at(i)->Print();
    }
}

void Hypergraph::PrintSpernerGraph()
{
    for(int i = 0; i < edges_.size(); i++){
        std::cout << "E" << i+1 << " ";
        edges_.at(i)->Print();
    }
}

void Hypergraph::PrintStars()
{   
    //    for(int i = 0; i < stars_.size(); i++){
    //        std::cout << "S" << i+1 << " ";
    //        QSet<Edge*> *s1 = stars_.at(i);
    //        for(int j = 0; j < s1->size(); j++){
    //            std::cout << "E" << s1->toList().at(j)->id_ << " ";
    //        }
    //        std::cout << std::endl;
    //    }
}

void Hypergraph::PrintStarsVerts()
{
    //    for(int i = 0; i < stars_.size(); i++){
    //        std::cout << "S" << i+1 << " ";
    //        QSet<Edge*> *s1 = stars_.at(i);
    //        QSet<Vertex*> vertex;
    //        for(int j = 0; j < s1->size(); j++){
    //            vertex.unite(s1->toList().at(j)->v_set_);
    //        }
    //        for(int j = 0; j < vertex.size(); j++){
    //            std::cout << vertex.toList().at(j)->id_ << " ";
    //        }
    //        std::cout << std::endl;
    //    }
}

void Hypergraph::PrintProgress(int current, int total)
{
    double progress = (current * 100/ total);
    if(progress != current_progress_){
        std::cout << progress << "% " << current << "\r" << std::flush;
    }
    current_progress_ = progress;
}
