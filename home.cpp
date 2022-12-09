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

void Home::fetchBag(int bagId, int type, int ps, int pageState) {
    qDebug() << "获取包id:" << bagId;
//    QString url = "http://localhost:3000/bag";
//    QString url = "http://192.168.8.177:3000/bag";
//    ps = 2;
//    qDebug() << url;
    QString url = urlPrefix + "/bag?ps=" + QString::number(ps);
    QDateTime timeDate = QDateTime::currentDateTime();  // 获取当前时间
    QString today = timeDate.toString("yyyy-MM-dd");
    int todayTimeStamp = QDateTime::fromString(today + " 00:00:00", "yyyy-MM-dd hh:mm:ss").toTime_t();
    // 该接口查询当天包
    url += "&start=" + QString::number(todayTimeStamp) + "000";
    if (bagId == 0) {
        // 初始化时寻找前5分钟的前10个包
//        QDateTime timeDate = QDateTime::currentDateTime();  // 获取当前时间
//        int endTime = timeDate.toTime_t();
//        int startTime = endTime - 300;
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
    if (pageState == 2) {
        url += "&status=0";
    }
    qDebug() << "请求url:" << url;
    QNetworkRequest request;
    QNetworkAccessManager manager;
    if (pageState == 1) {
        connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveBagListReply);
    } else {
        connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveSingleBagReply);
    }

    //get与post的请求方式有所不同，get是在接口名后添加 ? 和传输的数据(type)
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json;charset=utf-8"));
    QNetworkReply *reply = manager.get(request);    //get请求头

    //开启事件循环，直到请求完成
    QEventLoop loop;
    connect(reply,&QNetworkReply::finished,&loop,&QEventLoop::quit);
    loop.exec();
}

void Home::getBagList(int startTime, int endTime, QString cat, QString user, QString auditor) {
     QString url = urlPrefix + "/bag?start=" + QString::number(startTime) + "000" + "&end=" + QString::number(endTime) + "000";
    if (cat != "") {
         url += "&cat=" + cat;
     }
    if (user != "") {
        url += "&user=" + user;
    }
    if (auditor != "") {
        url += "&auditor=" + auditor;
    }
    url += "&order=-1";
    url += "&ps=100";
    qDebug() << "请求getBagList-url:" << url;
    QNetworkRequest request;
    QNetworkAccessManager manager;
    connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveBagStatisticReply);

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
    emit sendBagInfo(res, 1);
}

void Home::receiveSingleBagReply(QNetworkReply *reply) {
    QString res = reply->readAll();
    qDebug() << "receiveSingleBagReply" << res;
    emit sendBagInfo(res, 2);
}

void Home::receiveBagStatisticReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
    qDebug() << "receiveBagStatistic" << res;
    emit sendBagInfo(res, 3);
}

void Home::receiveLoginReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
//    qDebug() << "loginReply" << res;
    emit sendLoginRes(res);
}

void Home::receiveSubmitBagRegisterReply(QNetworkReply *reply)
{
    QString res = reply->readAll();
    qDebug() << "receiveSubmitBagRegisterReply" << res;
//    emit sendLoginRes(res);
}

void Home::changeBagStatus(int bagId, int status) {
    emit modifyBagStatus(bagId, status);
}

void Home::deleteHistoryPic() {
    qDebug() << "delete file";
    QDir dir("F:/pic");
    if(!dir.exists())
    {
        return;
    }
    dir.setFilter(QDir::Files | QDir::NoSymLinks);
    QFileInfoList fileList = dir.entryInfoList();
    for(int i=0; i< fileList.count(); i++) {
        QFileInfo fileInfo = fileList.at(i);
        if ((fileInfo.birthTime() < QDateTime::currentDateTime()) && fileInfo.absoluteFilePath().contains("cat")) {
            QFile::remove(fileInfo.absoluteFilePath());
        }
//        qDebug() << fileInfo.absoluteFilePath();
//        qDebug() << fileInfo.birthTime();
//        qDebug() << (fileInfo.birthTime() < QDateTime::currentDateTime());
//        qDebug() << fileInfo.absoluteFilePath().contains("cat");
    }
}

void Home::changeNextStatus(bool flag) {
    emit modifyNextStatus(flag);
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

void Home::submitBagRegisterInfo(QString userInfo, QString categoryInfo, int bagStatus) {
    qDebug() << "d";
    qDebug() << userInfo << categoryInfo;
    QJsonDocument userDoc = QJsonDocument::fromJson(userInfo.toUtf8());
    QJsonObject userObj = userDoc.object();
    QString userPic = userObj["userPic"].toString();
//    userPic = "F:/pic/knife_and_jab.txt";
    userPic = "F:/pic/user_1.jpg";
    qDebug() << userPic;
    QFile file(userPic);
    QByteArray bagUserPic;
    if (file.exists()) {
        if(file.open(QFile::ReadOnly)) {
//            file.re
            bagUserPic = file.readAll();
            qDebug() << bagUserPic.size();
//            qDebug() << bagUserPic;
//            qDebug() << file.readAll();
        }
    }
//    qDebug() << bagUserPic.size() << "dd";
    QJsonDocument categoryDoc = QJsonDocument::fromJson(categoryInfo.toUtf8());
    QJsonArray categoryList = categoryDoc.array();
    qDebug() << categoryList << categoryList.size();
    QJsonArray unpackCategoryList;
//    qDebug() << unpackCategoryList.size();
    for(unsigned i=0; i<categoryList.size(); i++) {
//        QJsonDocument eachCategory = QJsonDocument::fromJson(categoryList[i].toString().toUtf8());
//        QJsonObject eachCategoryObj = eachCategory.object();
//        qDebug() << eachCategory << "dd";
//        qDebug() << categoryList[i].toObject()["path"] << "ee";
        QString path = categoryList[i].toObject()["path"].toString();
        qDebug() << "path" << path;
        QFile file(path);
        if (file.exists()) {
            if(file.open(QFile::ReadOnly)) {
                QByteArray data = file.readAll();
                QJsonObject cateObj;
                cateObj.insert("categoryName", categoryList[i].toObject()["categoryName"].toString());
                cateObj.insert("categoryId", categoryList[i].toObject()["categoryId"]);
                cateObj.insert("contrabandPic", QString(data.toBase64()));
                unpackCategoryList.append(cateObj);
            }
        }
    }
    QJsonObject object;
    object.insert("bagId", userObj["bagId"]);
    object.insert("status", bagStatus);
    object.insert("bagUserName", userObj["bagUserName"].toString());
    object.insert("bagUserPhone", userObj["bagUserPhone"].toString());
    object.insert("bagUserPic", QString(bagUserPic.toBase64()));
//    qDebug() << unpackCategoryList.size() << "ddddddddddddd";
//    qDebug() << unpackCategoryList;
    if (unpackCategoryList.size() > 0) {
//        qDebug() << "123";
        QJsonDocument doc;
        doc.setArray(unpackCategoryList);
//        qDebug() << "234";
//        qDebug() << QString::fromUtf8(doc.toJson(QJsonDocument::Compact).constData());
        object.insert("unpackCategoryListInfo", QString::fromUtf8(doc.toJson(QJsonDocument::Compact).constData()));
    } else {
        object.insert("unpackCategoryListInfo", "[]");
    }
//   / qDebug() << "1111" << object["unpackCategoryList"];
//    qDebug() << QJsonDocument::fromJson(bagUserPic).object() << "sss";
//    qDebug() << bagUserPic.toBase64() << "sss";
   // object.insert("bagUserPic", "123");
    QJsonDocument document = QJsonDocument(object);

    // 发起请求
    QString url = urlPrefix + "/bag/register";
    QNetworkRequest request;
    QNetworkAccessManager manager;
    connect(&manager, &QNetworkAccessManager::finished, this, &Home::receiveSubmitBagRegisterReply);

    //get与post的请求方式有所不同，get是在接口名后添加 ? 和传输的数据(type)
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json;charset=utf-8"));
//    qDebug() << "token" << "Bear " + config.token;
    request.setRawHeader(QByteArray("Authorization"), ("Bearer " + config.token).toUtf8());
    QByteArray byteArr = document.toJson(QJsonDocument::Compact);
    QNetworkReply *reply = manager.post(request, byteArr);    //post请求头

    //开启事件循环，直到请求完成
    QEventLoop loop;
    connect(reply,&QNetworkReply::finished,&loop,&QEventLoop::quit);
    loop.exec();
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

void Home::loginSuccess() {
    emit navigatePage(1, "{}");
}

void Home::popup(double opacity) {
    emit modifyOpacity(opacity);
}

void Home::goToPage(int pageState, QString params) {
    emit navigatePage(pageState, params);
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
