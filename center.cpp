#include "center.h"
#include <QDebug>

#define DEFAULT_PIX_WIDTH   1280
#define DEFAULT_PIX_HEIGHT  720

Center::Center(QObject *parent) : QObject(parent)
{
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Center::TimeOutSlot);
}

Center::~Center()
{
}

void Center::OpenYuv()
{
    m_pYuvFile = fopen("F:/bee.yuv", "rb");
//    m_pYuvFile = fopen("H:/frame/0.yuv", "rb");
//    m_pYuvFile = fopen("H:/frame/0.jpg", "rb");
    m_nVideoW = DEFAULT_PIX_WIDTH;
    m_nVideoH = DEFAULT_PIX_HEIGHT;

    nLen = m_nVideoW*m_nVideoH*3/2;
//    nLen = m_nVideoW*m_nVideoH;
    if(nullptr == m_pBufYuv420p) {
        m_pBufYuv420p = new unsigned char[nLen];
        qDebug("CPlayWidget::PlayOneFrame new data memory. Len=%d width=%d height=%d\n",
               nLen, m_nVideoW, m_nVideoH);
    }
    //将一帧yuv图像读到内存中
    if(nullptr == m_pYuvFile) {
        qFatal("read yuv file err.may be path is wrong!\n");
        return;
    }

    timer->start(33);
}

void Center::TimeOutSlot()
{
    int nSize = fread(m_pBufYuv420p, 1, nLen, m_pYuvFile);
    if (nSize == 0) {
//        qDebug() << "end!!!";
//        timer->stop();
//        OpenYuv();
    } else {
        emit updateImgSig(m_pBufYuv420p);
    }
}
