#ifndef EDGE_H
#define EDGE_H

#include <QList>
#include <QSet>

class Vertex;

class Edge
{
public:
    Edge();
    ~Edge();
    long int id_;
    void AddVertex(Vertex*);
    void Print();
    bool Contains(Edge* e);
    bool Intersects(Edge* e);
    void Unite(Edge *e);
    QSet<Vertex*> v_set_;
    QList<Vertex*> v_list_; //To avoid conversion
    bool isolated_;
    bool noisy_;
    int max_l_;
    int min_l_;
};

#endif // EDGE_H
