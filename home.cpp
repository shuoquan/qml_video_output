#include "home.h"
#include <QDebug>

Home::Home(QObject *parent) : QObject(parent)
{
    ip = "localhost";
    port = 9528;
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Home::TimeOutSlot);
    socket = new QTcpSocket(this);
    connected = false;
    socket->connectToHost(ip, port);
    connect(socket, &QTcpSocket::connected, this, [=]() mutable {
        qDebug() << "连接成功Home";
        connected = true;
    });
    connect(socket, &QTcpSocket::readyRead, this, [=]() mutable {
        QByteArray msg = socket->readAll();
        QString bagId = msg.data();
        qDebug() << "bagId" << bagId;
        fetchBag(bagId.toInt(), 0, 1);
    });
    connect(socket, &QTcpSocket::disconnected, this, [=]() {
        qDebug() << "断开连接Home";
        connected = false;
    });
    timer->start(5000);
}


Home::~Home()
{
    delete socket;
    socket = NULL;
    delete timer;
    timer = NULL;
}

void Home::fetchBag(int bagId, int type, int ps) {
    qDebug() << "fetchBag";
    qDebug() << bagId;
    QString url = "http://192.168.8.117:3000/bag";
    url += "?ps=" + QString::number(ps);
    if (bagId == 0) {
        // 初始化时寻找前5分钟的前2个包
        QDateTime timeDate = QDateTime::currentDateTime();  // 获取当前时间
        int endTime = timeDate.toTime_t();
        int startTime = endTime - 300;
//        url += "&start=" + QString::number(startTime) + "000";
//        url += "&end=" + QString::number(endTime) + "000";
        url += "&order=-1";
        url += "&type=-1";
    } else {
        url += "&id=" + QString::number(bagId);
        url += "&type=" + QString::number(type);
        if (type==-1) {
            url += "&order=-1";
        } else {
            url += "&order=1";
        }
    }
    qDebug() << url;
    QNetworkRequest request;
    QNetworkAccessManager manager;
    connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveReply);

    //get与post的请求方式有所不同，get是在接口名后添加 ? 和传输的数据(type)
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json;charset=utf-8"));
    QNetworkReply *reply = manager.get(request);    //get请求头

    //开启事件循环，直到请求完成
    QEventLoop loop;
    connect(reply,&QNetworkReply::finished,&loop,&QEventLoop::quit);
    loop.exec();
}


void Home::receiveReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
//    qDebug() << "receiveRes" << res;
    emit sendBagInfo(res);
}


void Home::TimeOutSlot()
{
    if (!connected) {
        socket->abort();
        socket->connectToHost(ip, port);
    }
}


int Home::test(int id)
{
    qDebug() << "test" << id;
    return 234;
}
