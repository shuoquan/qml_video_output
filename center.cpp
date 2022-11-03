#include "center.h"
#include <QDebug>
#include <exception>

#ifdef __cplusplus
extern "C"
{
#endif
#include <libavformat/avformat.h>
#include <libavutil/frame.h>
#include <libavutil/mem.h>
#include <libswscale/swscale.h>
#include <libavcodec/avcodec.h>
#include <libavutil/dict.h>

#ifdef __cplusplus
}
#endif

#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>

#define DEFAULT_PIX_WIDTH   1280
#define DEFAULT_PIX_HEIGHT  720

Center::Center(QObject *parent) : QObject(parent)
{
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Center::TimeOutSlot);
    //    this->format_context = avformat_alloc_context();
    //    this->format_context->interrupt_callback.callback = custom_interrupt_callback;
    //    this->format_context->interrupt_callback.opaque = this;
    //    packet = av_packet_alloc();
    //    videoFrame = av_frame_alloc();
    //    video_frame_size = 0;
    //    audio_frame_size = 0;
    //    video_frame_count = 0;
    //    audio_frame_count = 0;


    server = new QTcpServer(this);//创建一个服务器对象
    server->listen(QHostAddress::Any, 1234); //开始监听网络地址以及端口号
    int size = 0;
    QByteArray byteArr;
    //当server检测到有socket申请连接并且连接成功的时候，会发出newConnection信号并且执行下面的逻辑
    connect(server, &QTcpServer::newConnection, this, [=]() mutable {
        socket = server->nextPendingConnection(); //得到一个用于通信的套接字对象
        qDebug() << "新连接";
        byteArr.resize(0);
        //往客户段中发送信息
        //        socket->write("server");//socket的write方法其实是有几个重载方法的，如果为了方便，可以直接用QString类型的变量作为参数。
        //当有数据可以接受，socket对象发出信号readyRead
        connect(socket, &QTcpSocket::readyRead, this, [=]() mutable
                {
                    //                    socket->readBufferSize()
                    QByteArray msg = socket->readAll();
                    byteArr.append(msg);
//                    QString data = msg.data();//读取客户端传来的数据
//                    socket->read()
                    //                    qDebug() << "客户端传来的数据" << data;
//                    qDebug() << "长度" << data.size() << msg.size();
//                    qDebug() << "长度" << msg.size();
//                    qDebug() << data;
                    size += msg.size();
//                    totalData += data;
                    if (size >= 1382400) {
                        qDebug() << "真实长度" << size;
//                        totalData.resize(1382400);

//                        QByteArray arr = totalData.toLatin1();
//                        qDebug() << arr.size();
                        unsigned char *str = (unsigned char*)byteArr.data();
                        byteArr.resize(0);
                        emit updateImgSig(str);
                        size = 0;
//                        totalData = "";
                    }
                    qDebug() << "长度--" << size;

                });

        //断开连接
        connect(socket, &QTcpSocket::disconnected, this, [=]()
                {
                    socket->close();
                    socket->deleteLater();//释放指向的内存
                    qDebug() << "结束服务器";
                });
    });//server对象检测到有socket对象申请连接的时候，会调用listenNews方法
}

Center::~Center()
{
}

void Center::OpenYuv()
{
    //    m_pYuvFile = fopen("F:/bee.yuv", "rb");
    m_pYuvFile = fopen("H:/video-frame.yuv", "rb");
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

bool Center::Decode(const char* rtmpUrl) {
    qDebug() << "start";
    avformat_network_init();
    qDebug() << "1211111";
    std::string tempUrl = rtmpUrl;

    // 打开输入流
    if (avformat_open_input(&format_context, tempUrl.c_str(), NULL, NULL) < 0) {
        qDebug() << "打开流失败";
        return false;
    }
    qDebug() << "222";

    //从媒体文件中读包进而获取流消息
    if (avformat_find_stream_info(format_context, nullptr) < 0) return false;
    qDebug() << "11";
    qDebug() << format_context;
    //    int ret = avformat_alloc_output_context2(&out_format_context, NULL, NULL, "H:/tmp.flv");
    //    qDebug() << "3333" << ret;
    //    if (ret < 0) {
    //        qDebug() << "avformat_alloc_output_context failed" << ret;
    //        return false;
    //    }
    int video_stream_index = -1;
    int audio_stream_index = -1;
    int video_width = 0;
    int video_height = 0;
    int ret;
    qDebug() << "nb_stream" << format_context->nb_streams;
    for (int i = 0; i < format_context->nb_streams; i++) {
        AVStream *video_st = format_context->streams[i];
        //筛选视频流和音频流
        if (video_st->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            video_stream_index = i;
            video_width = video_st->codecpar->width;
            video_height = video_st->codecpar->height;
            // qDebug()  << "codetype" << video_st->codecpar->codec_id << AV_CODEC_ID_H264 << video_width << video_height;
            //找到对应的解码器
            const AVCodec *codec = avcodec_find_decoder(video_st->codecpar->codec_id);
            //        AVStream *out_stream = avformat_new_stream(out_format_context, codec);

            //创建解码器对应的结构体
            AVCodecContext* codec_ctx = avcodec_alloc_context3(codec);
            ret = avcodec_parameters_to_context(codec_ctx, video_st->codecpar);
            if (ret < 0) {
                qDebug() << "Failed to copy in_stream codecpar to codec context";
                return false;
            }
            int err = avcodec_open2(codec_ctx, codec, NULL);
            qDebug() << "err" << err;
            if (err != 0) {
                qDebug() << "打开解码器失败";
                return false;
            }
        }
        if (video_st->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            audio_stream_index = i;
        }


        //        codec_ctx->codec_tag = 0;
        //        if (out_format_context->oformat->flags & AVFMT_GLOBALHEADER)
        //            codec_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;

        //        ret = avcodec_parameters_from_context(out_stream->codecpar, codec_ctx);
        //        if (ret < 0) {
        //            qDebug() << "Failed to copy codec context to out_stream codecpar context";
        //            return false;
        //        }
    }
    qDebug() << video_stream_index << audio_stream_index << "index";
    if (video_stream_index == -1)
    {
        qDebug() << "没有检测到视频流";
        return false;
    }

    if (audio_stream_index == -1)
    {
        qDebug() << "没有检测到音频流";
    }

    AVFrame *yuv420p_pFrame = nullptr;
    AVFrame *PCM_pFrame = nullptr;
    yuv420p_pFrame = av_frame_alloc();// 存放解码后YUV数据的缓冲区
    yuv420p_data=new unsigned char[video_width*video_height*3/2];
    int y_size=video_width*video_height;

    int re;
    while (1) {
        //6.读取数据包
        ret = av_read_frame(format_context, packet);
        qDebug() << "rr" << ret << packet->stream_index;
        if (ret < 0) break;
        //        video_st = format_context->streams[packet->stream_index];
        //        qDebug() << "height" << video_st->codecpar->height;
        //        qDebug() << "buffer size" << sizeof(packet->buf->buffer);
        //            emit updateImgSig(packet->data);
        //            qDebug() << video_st->metadata;
        //            qDebug() << *(video_st->attached_pic.data);
        //            try {
        //                qDebug() << *video_st->side_data->data;
        //            } catch(_exception& e) {
        //                qDebug() << e.type;
        //            }
        //            emit updateImgSig(video_st->attached_pic.data);
        //            emit updateImgSig(video_st->side_data->data);
        //            out_stream = out_format_context->streams[packet->stream_index];

        //            av_packet_rescale_ts(packet, video_st->time_base, out_stream->time_base);

        if (packet->stream_index == video_stream_index) {
            video_frame_size += packet->size;
            //            printf("recv %5d video frame %5d-%5d\n", ++video_frame_count, packet->size, video_frame_size);
            qDebug() << "视频包大小" << packet->size;
                const AVCodec *codec = avcodec_find_decoder(format_context->streams[video_stream_index]->codecpar->codec_id);
            //        AVStream *out_stream = avformat_new_stream(out_format_context, codec);

            //创建解码器对应的结构体
            AVCodecContext* codec_ctx = avcodec_alloc_context3(codec);
            int err = avcodec_open2(codec_ctx, codec, NULL);
            qDebug() << "err2" << err;
            if (err != 0) {
                qDebug() << "打开解码器失败";
                return false;
            }
            re = avcodec_send_packet(codec_ctx, packet);
            qDebug() << "结果" << re;
                if (re != 0)
            {
                av_packet_unref(packet);//不成功就释放这个pkt
                continue;
            }
            re = avcodec_receive_frame(codec_ctx, yuv420p_pFrame);//接受后对视频帧进行解码
            qDebug() << "结果--" << re;
                if (re != 0)
            {
                av_packet_unref(packet);//不成功就释放这个pkt
                continue;
            }
            memcpy(yuv420p_data,(const void *)yuv420p_pFrame->data[0],y_size);
            memcpy(yuv420p_data+y_size,(const void *)yuv420p_pFrame->data[1],y_size/4);
            memcpy(yuv420p_data+y_size+y_size/4,(const void *)yuv420p_pFrame->data[2],y_size/4);
            qDebug() << "yuv420" << sizeof(yuv420p_data);
            emit updateImgSig(yuv420p_data);
        }

        if (packet->stream_index == audio_stream_index) {
            audio_frame_size += packet->size;
            printf("recv %5d audio frame %5d-%5d\n", ++audio_frame_count, packet->size, audio_frame_size);
        }

        //            ret = av_interleaved_write_frame(out_format_context, packet);
        //            if (ret < 0) {
        //                printf("av_interleaved_write_frame failed\n");
        //                break;
        //            }
        //        ret = avcodec_send_packet(codec_ctx, packet);
        //        qDebug() << "beforextendData-----" << ret;
        //        while (ret > 0) {
        //            ret = avcodec_receive_frame(codec_ctx, videoFrame);
        //            qDebug() << "extendData-----" << ret;
        //            if (ret < 0) break;
        //            qDebug() << "extendData" << **videoFrame->extended_data;
        //        }
        av_packet_unref(packet);
    }

    qDebug() << "final";
    qDebug() << format_context;
    qDebug() << "package size" << packet->size;

    //        av_write_trailer(out_format_context);
    if (packet) {
        av_packet_free(&packet);
    }

    if (format_context) {
        avformat_close_input(&format_context);
    }

    //        avio_close(pOutFmtContext->pb);
    //        avformat_free_context(out_format_context);

}
