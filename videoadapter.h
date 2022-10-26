#include <QObject>
#include <QAbstractVideoSurface>
#include <QVideoSurfaceFormat>
#include <QTimer>

#include "center.h"

class VideoAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractVideoSurface *videoSurface READ getVideoSurface WRITE setVideoSurface NOTIFY videoSurfaceChanged)
public:
    explicit VideoAdapter(QObject *parent = nullptr);

    QAbstractVideoSurface *getVideoSurface();
    void setVideoSurface(QAbstractVideoSurface *videoSurface);

    void setVideoSurfaceFormat(int &nWidth, int &nHeight, QVideoFrame::PixelFormat &frameFormat);

    Q_INVOKABLE void startPlay();

signals:
    void videoSurfaceChanged();

public:
    void updateVideoData(uchar * oneFrameData);

private:
    QAbstractVideoSurface *pVideoSurface;
    QVideoSurfaceFormat mSurfaceFormat;
    int m_width;
    int m_height;
    int m_PackageSize;
    QVideoFrame::PixelFormat pixFormat;

    Center *pCenter;
};
