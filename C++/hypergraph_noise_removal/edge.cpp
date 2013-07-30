#include "edge.h"


#include <iostream>
#include "vertex.h"

Edge::Edge()
{
    isolated_ = false;
    noisy_ = false;
    min_l_ = 256;
    max_l_ = -1;
}

Edge::~Edge()
{
    v_set_.clear();
    v_list_.clear();
}

void Edge::AddVertex(Vertex *v)
{
    if(!v_set_.contains(v)){
        v_list_.push_back(v);
        v_set_.insert(v);
        if(v->luminance_ >= max_l_){
            max_l_ = v->luminance_;
        }
        if(v->luminance_ <= min_l_){
            min_l_ = v->luminance_;
        }
    }    
}

void Edge::Print()
{
    for(int i = 0; i < v_list_.size(); i++){
        std::cout << v_list_.at(i)->id_ << " ";
    }
    std::cout << std::endl;
}

bool Edge::Contains(Edge *e)
{
    return v_set_.contains(e->v_set_);
}

bool Edge::Intersects(Edge *e2)
{
    Edge* e1 = this;
    if(e1->v_list_.size() >= e2->v_list_.size()){
        QSet<Vertex*> e2_set = e2->v_set_;
        e2_set.intersect(e1->v_set_);
        if(e2_set.empty()){
            return false;
        }else{
            return true;
        }
    }else{
        QSet<Vertex*> e1_set = e1->v_set_;
        e1_set.intersect(e2->v_set_);
        if(e1_set.empty()){
            return false;
        }else{
            return true;
        }
    }
}

void Edge::Unite(Edge *e)
{
    this->v_set_.unite(e->v_set_);
    this->v_list_ = this->v_set_.toList();
    if(e->max_l_ >= max_l_){
        max_l_ = e->max_l_;
    }
    if(e->min_l_ <= min_l_){
        min_l_ = e->min_l_;
    }
}
