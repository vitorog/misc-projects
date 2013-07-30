#ifndef FILTER_H
#define FILTER_H

#include "image.h"
#include "hypergraph.h"

#include <iostream>

class Filter
{
public:
    Filter();
    ~Filter();
    virtual Image* Apply(Hypergraph*, Image*) = 0;
    void PrintProgress(int current, int total);
protected:
    Hypergraph *graph_;
    Image* input_image_;
    Image* noise_image_;
    Image* filtered_image_;
    int current_progress_;
};

#endif // FILTER_H


//void UniteStars();
//Image* StarFilter();
//void FindNoisyEdgesStarFilter();

//Image* NormalFilter();
//Image* ModifiedFilter();
//void FindIsolatedEdgesModified();
//void FindNoisyEdgesModified();

//void Build(Image&);
//void Rebuild(Image&, Image&, int alfa, int beta,int start_x = 0,int start_y = 0,int width = 0,int height = 0);
//void FindNoisyEdges();

//Image* ImpulsiveFilter();
//void FindIsolatedEdgesImpulsiveFilter();
//void FindNoisyEdgesImpulsiveFilter();
//Image* RemoveNoiseImpulsiveFilter();

//void SaveIsolatedPixelsImage();

//void CalculatePSNR();

//Image* RemoveNoise();
//Image* RemoveNoiseLinearFilter();

//QList<Edge*> isolated_edges_;
//QList<Edge*> unitary_isolated_edges_;
//QList<Edge*> noisy_edges_;
//QList<Edge*> new_edges_;
//QList<QSet<Edge*>* > stars_;
