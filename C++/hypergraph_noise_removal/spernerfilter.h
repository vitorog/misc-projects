#ifndef SPERNERFILTER_H
#define SPERNERFILTER_H

#include "filter.h"
#include "edge.h"

class SpernerFilter : public Filter
{
public:
    SpernerFilter();
    virtual ~SpernerFilter();
    Image* Apply(Hypergraph*,Image*);
    Image* PostProcess(Hypergraph*, Image*);
private:
    void BuildSpernerGraph();
    void FindNoisyEdges();
    Image* RemoveNoise();
    QList<Edge*> noisy_edges_;
    QList<Edge*> test_edges_;
};

#endif // SPERNERFILTER_H
