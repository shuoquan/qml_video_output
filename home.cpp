#include "home.h"
#include <QDebug>

Home::Home(QObject *parent) : QObject(parent)
{
//    ip = "localhost";
//    int value;
//    qDebug() << "value" << value;
    ip = config.unpackBackendIp;
    port = config.unpackBackendPort;
    urlPrefix = config.unpackBackendUrl;
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Home::TimeOutSlot);
    socket = new QTcpSocket(this);
    connected = false;
    socket->connectToHost(ip, port);
    connect(socket, &QTcpSocket::connected, this, [=]() mutable {
        qDebug() << "推送包图关联后台连接成功";
        connected = true;
    });
    connect(socket, &QTcpSocket::readyRead, this, [=]() mutable {
        QByteArray msg = socket->readAll();
        QString bagId = msg.data();
        qDebug() << "bagId" << bagId;
        fetchBag(bagId.toInt(), 0, 1);
    });
    connect(socket, &QTcpSocket::disconnected, this, [=]() {
        qDebug() << "推送包图关联后台断开连接";
        connected = false;
    });
    timer->start(5000);
}


Home::~Home()
{
    qDebug() << "home destructor";
    delete socket;
    socket = NULL;
    delete timer;
    timer = NULL;
}

void Home::printLog(QString msg) {
    qDebug() << "前端debug信息:" << msg;
}

void Home::fetchBag(int bagId, int type, int ps) {
    qDebug() << "获取包id:" << bagId;
//    QString url = "http://localhost:3000/bag";
//    QString url = "http://192.168.8.177:3000/bag";
//    ps = 2;
//    qDebug() << url;
    QString url = urlPrefix + "/bag?ps=" + QString::number(ps);
    if (bagId == 0) {
        // 初始化时寻找前5分钟的前10个包
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
    qDebug() << "请求url:" << url;
    QNetworkRequest request;
    QNetworkAccessManager manager;
    connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveBagListReply);

    //get与post的请求方式有所不同，get是在接口名后添加 ? 和传输的数据(type)
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json;charset=utf-8"));
    QNetworkReply *reply = manager.get(request);    //get请求头

    //开启事件循环，直到请求完成
    QEventLoop loop;
    connect(reply,&QNetworkReply::finished,&loop,&QEventLoop::quit);
    loop.exec();
}


void Home::receiveBagListReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
    qDebug() << "receiveBagInfo" << res;
    emit sendBagInfo(res);
}

void Home::receiveLoginReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
    qDebug() << "loginReply" << res;
    emit sendLoginRes(res);
}


void Home::login(QString username, QString password) {
//    qDebug() << "login" << username << password;
    QString md5Password = QCryptographicHash::hash(password.toLatin1(), QCryptographicHash::Md5).toHex();
//    qDebug() << md5Password;
    QString url = urlPrefix + "/user/login";
    QNetworkRequest request;
    QNetworkAccessManager manager;
    connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveLoginReply);

    //get与post的请求方式有所不同，get是在接口名后添加 ? 和传输的数据(type)
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json;charset=utf-8"));
    QJsonObject object;
    object.insert("username", username);
    object.insert("password", md5Password);
    QJsonDocument document = QJsonDocument(object);
    QByteArray byteArr = document.toJson(QJsonDocument::Compact);
    QNetworkReply *reply = manager.post(request, byteArr);    //post请求头

    //开启事件循环，直到请求完成
    QEventLoop loop;
    connect(reply,&QNetworkReply::finished,&loop,&QEventLoop::quit);
    loop.exec();
}

void Home::saveToken(QString token) {
    config.token = token;
//    qDebug() << config.token << "1";
}

void Home::loadImage(QString imagePath) {
    qDebug() << "image" << imagePath;
//    auto myQmlEngine = qmlEngine(this);
//    qDebug() << "111";
//    QUrl imageUrl(imagePath);
//    qDebug() << "222" << imageUrl;
//    QImage img = provider->requestImage(imageUrl.path().remove(0,1),nullptr,QSize());
    //        qDebug() << "D";
    //        qDebug() << img;
////    auto provider = reinterpret_cast<QQuickImageProvider*>( myQmlEngine->imageProvider(imageUrl.host()));
//     auto provider = static_cast<QQuickImageProvider*>( myQmlEngine->imageProvider(imageUrl.host()));
//    qDebug() << "333";
//    QQmlEngine *engine = QQmlEngine::contextForObject(this)->engine();

//    if (provider->imageType()==QQuickImageProvider::Image){
//        QImage img = provider->requestImage(imageUrl.path().remove(0,1),nullptr,QSize());
//        qDebug() << "D";
//        qDebug() << img;
//        // do whatever you want with the image
//    }
}

void Home::registerBag(int bagId, QString bagInfo) {
//    qDebug() << "register" << bagId << bagInfo;
//    QJsonObject object;
//    object.insert("bagId", bagId);
//    QJsonDocument document = QJsonDocument(object);
//    emit navigatePage(2, document.toJson(QJsonDocument::Indented));
    emit navigatePage(2, bagInfo);
}

void Home::TimeOutSlot()
{
//    qDebug() << "logtest";
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
