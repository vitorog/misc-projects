#include "vertex.h"

#include "edge.h"

Vertex::Vertex()
{
    edge_ = NULL;
    star_edge_ = NULL;
    luminance_ = -1;
}

Vertex::~Vertex()
{
    if(edge_ != NULL){
        delete edge_;
    }
    if(star_edge_ != NULL){
        delete star_edge_;
    }
    star_.clear();
    neighbours_.clear();
}
