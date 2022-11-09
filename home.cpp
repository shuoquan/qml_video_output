#include "home.h"
#include <QDebug>

Home::Home(QObject *parent) : QObject(parent)
{
//    qDebug() << "home";
}


Home::~Home()
{
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
        url += "&start=" + QString::number(startTime) + "000";
        url += "&end=" + QString::number(endTime) + "000";
    } else {
        url += "&id=" + QString::number(bagId);
        url += "&type=" + QString::number(type);
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



int Home::test(int id)
{
    qDebug() << "test" << id;
    return 234;
}
