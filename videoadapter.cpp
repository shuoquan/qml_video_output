#include "videoadapter.h"
#include <QDebug>

#define DEFAULT_PIX_WIDTH   640
#define DEFAULT_PIX_HEIGHT  360

VideoAdapter::VideoAdapter(QObject *parent) :
    QObject(parent),
    m_width(DEFAULT_PIX_WIDTH),
    m_height(DEFAULT_PIX_HEIGHT),
    m_PackageSize(m_width*m_height*3/2),
    pixFormat(QVideoFrame::PixelFormat::Format_YUV420P)
{
    pVideoSurface = nullptr;

    pCenter = new Center;
    connect(pCenter, &Center::updateImgSig, this, &VideoAdapter::updateVideoData);
}

QAbstractVideoSurface * VideoAdapter::getVideoSurface()
{
    return pVideoSurface;
}

void VideoAdapter::setVideoSurface(QAbstractVideoSurface *videoSurface)
{
    if (videoSurface == pVideoSurface)
        return;

    if (pVideoSurface != nullptr && pVideoSurface->isActive())
        pVideoSurface->stop();

    pVideoSurface = videoSurface;
    setVideoSurfaceFormat(m_width, m_height, pixFormat);

    emit videoSurfaceChanged();
}

void VideoAdapter::setVideoSurfaceFormat(int &nWidth, int &nHeight, QVideoFrame::PixelFormat &frameFormat)
{
    if (pVideoSurface != nullptr) {
        if (pVideoSurface->isActive())
            pVideoSurface->stop();

        mSurfaceFormat = pVideoSurface->nearestFormat(QVideoSurfaceFormat(QSize(nWidth, nHeight), frameFormat));
        pVideoSurface->start(mSurfaceFormat);
    }
}

void VideoAdapter::startPlay()
{
    pCenter->OpenYuv();
//    pCenter->Decode("rtmp://192.168.40.128:1935/live/test");
}

void VideoAdapter::updateVideoData(uchar *oneFrameData)
{
//    qDebug() << "frame" << oneFrameData << sizeof(*oneFrameData);
    QVideoFrame mVideoFrame(m_PackageSize, QSize(m_width, m_height), m_width, pixFormat);
//    qDebug() << mVideoFrame << "videoframe";
    if (mVideoFrame.map(QAbstractVideoBuffer::WriteOnly)) {
        uchar * fdata = mVideoFrame.bits();
        memcpy(fdata, oneFrameData, m_PackageSize);
        mVideoFrame.unmap();
        mVideoFrame.setStartTime(0);

        pVideoSurface->present(mVideoFrame);
    }
}
