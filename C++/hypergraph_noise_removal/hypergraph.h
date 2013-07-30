#ifndef HYPERGRAPH_H
#define HYPERGRAPH_H

#include <QMap>

#include "image.h"
#include "vertex.h"

class Hypergraph
{
public:
    Hypergraph();
    ~Hypergraph();
    Hypergraph(Image*, int alfa, int beta,int starting_x = 0,int starting_y = 0,int window_width = 0,int window_height = 0);

    void Build(Image*, int alfa, int beta);
    void Build(Image* img, int alfa, int beta,int starting_x,int starting_y,int window_width,int window_height);


    void PrintGraph();
    void PrintSpernerGraph();
    void PrintStars();
    void PrintStarsVerts();
    void PrintProgress(int current, int total);

    QList<Vertex*> nodes_;
    QMap<int, Vertex*> nodes_map_;
    QList<Edge*> edges_;
    QList<QSet<Edge*>* > stars_;

    int alfa_;
    int beta_;
    int window_width_;
    int window_height_;
    int image_width_;
    int image_height_;
    int starting_x_;
    int starting_y_;
    int ending_x_;
    int ending_y_;
    int current_progress_;
    Image* image_;
};

#endif // HYPERGRAPH_H
