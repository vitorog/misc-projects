TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.cpp


unix:!macx: LIBS += -L$$PWD/../../../../../../../../usr/local/lib/ -lopencv_core

INCLUDEPATH += $$PWD/../../../../../../../../usr/local/include
DEPENDPATH += $$PWD/../../../../../../../../usr/local/include

unix:!macx: LIBS += -L$$PWD/../../../../../../../../usr/local/lib/ -lopencv_highgui

INCLUDEPATH += $$PWD/../../../../../../../../usr/local/include
DEPENDPATH += $$PWD/../../../../../../../../usr/local/include
