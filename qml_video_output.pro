QT += quick
QT += multimedia
QT += network

RC_ICONS = logo4.ico

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        center.cpp \
        home.cpp \
        logHandler.cpp \
        main.cpp \
        videoadapter.cpp \
        global.cpp

RESOURCES += qml.qrc \
    static.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    center.h \
    home.h \
    logHandler.h \
    videoadapter.h \
    global.h

INCLUDEPATH += E:/opencv/opencv/build/include
INCLUDEPATH += E:/opencv/opencv/build/include/opencv2

#INCLUDEPATH += E:/opencv/OpenCV-MinGW-Build-OpenCV-4.5.5-x64/include
#INCLUDEPATH += E:/opencv/OpenCV-MinGW-Build-OpenCV-4.5.5-x64/include/opencv2

INCLUDEPATH += E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/include

LIBS += E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/avdevice.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/avfilter.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/avformat.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/avutil.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/avcodec.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/postproc.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/swresample.lib \
        E:/ffmpeg/ffmpeg-5.0.1-full_build-shared/lib/swscale.lib \
        E:/opencv/opencv/build/x64/vc14/lib/opencv_*.lib \

#E:/opencv/OpenCV-MinGW-Build-OpenCV-4.5.5-x64/x64/mingw/lib/libopencv_* \

#E:/opencv/opencv/build/x64/vc14/lib/opencv_*.lib \
#QMAKE_LFLAGS = "-lavformat"
msvc {
    QMAKE_CFLAGS += /utf-8
    QMAKE_CXXFLAGS += /utf-8
    QMAKE_CXXFLAGS += /MP
}

# Use Precompiled headers (PCH)
CONFIG += precompile_header
#PRECOMPILED_HEADER = stable.h
# HEADERS += stable.h #这句话是可有可无的，建议加上
