#-------------------------------------------------
#
# Project created by QtCreator 2013-05-15T16:30:54
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = hypergraph_noise_removal
TEMPLATE = app

CONFIG += console


SOURCES += main.cpp\
    image.cpp \
    vertex.cpp \
    edge.cpp \
    hypergraph.cpp \  
    filter.cpp \   
    spernerfilter.cpp

HEADERS  += \
    image.h \
    vertex.h \
    edge.h \
    hypergraph.h \    
    filter.h \    
    spernerfilter.h

FORMS    +=

INCLUDEPATH += /media/vitor/Libraries/Programs/Linux/MATLAB/R2013a/extern/include
