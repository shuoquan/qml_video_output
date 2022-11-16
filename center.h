#include <QObject>
#include <QTime>
#include <QTimer>
#include <QDebug>
#include <qtcpserver.h>
#include <qtcpsocket.h>
#include "global.h"

//#ifdef __cplusplus
//extern "C"
//{
//#endif
//#include <libavformat/avformat.h>
//#include <libavutil/frame.h>
//#include <libavutil/mem.h>
//#include <libswscale/swscale.h>
//#include <libavcodec/avcodec.h>
//#include <libavutil/dict.h>

//#ifdef __cplusplus
//}
//#endif
#pragma execution_character_set("utf-8")

class Center : public QObject
{
    Q_OBJECT
public:
    QString ip;
    int port;
    bool connected;
    QTcpServer* server; // 服务器对象
    QTcpSocket* socket;//与客户端进行发送接受信息对象
//    AVFormatContext* format_context;
//    AVFormatContext* out_format_context;
    unsigned char *yuv420p_data;
//    AVPacket* packet;
//    AVFrame* videoFrame;
    int video_frame_size;
    int audio_frame_size;
    int video_frame_count;
    int audio_frame_count;
    explicit Center(QObject *parent = nullptr);
    ~Center();
    bool Decode(const char* rtmpUrl);
    static int custom_interrupt_callback(void*) {
//        qDebug() << "chaoshi";
        return 0;
    }

signals:
    void updateImgSig(uchar * yuvData);

public slots:
    void OpenYuv();
    void TimeOutSlot();

private:
    FILE* m_pYuvFile;
    unsigned char* m_pBufYuv420p = nullptr;
    int nLen;
    int m_nVideoW;
    int m_nVideoH;
    QTimer *timer;
};
