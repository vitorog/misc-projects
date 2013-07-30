#ifndef VERTEX_H
#define VERTEX_H

#include <QList>
#include <QSet>

class Edge;

class Vertex
{
public:
    Vertex();
    ~Vertex();
    int luminance_;
    int x_;
    int y_;
    long int id_;
    Edge* edge_;
    QList<Vertex*> neighbours_;
    QSet<Edge*> star_;
    Edge* star_edge_;
};

#endif // VERTEX_H
