#ifndef HOME_H
#define HOME_H

#include <QObject>
#include <QTime>
#include <QTimer>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QDateTime>
#include <QHttpMultiPart>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QMetaObject>
#include <QEventLoop>
#include <qtcpsocket.h>
#include <QCryptographicHash>
#include <QJsonDocument>
#include "global.h"
#include <QQuickImageProvider>

#pragma execution_character_set("utf-8")

class Home : public QObject
{
    Q_OBJECT
public:
    QString ip;
    int port;
    QString urlPrefix;
    bool connected;
    QTcpSocket* socket;
    QTimer *timer;
    explicit Home(QObject *parent = nullptr);
    ~Home();
    Q_INVOKABLE void fetchBag(int bagId = 0, int type = 0, int ps = 1);
    Q_INVOKABLE int test(int id);
    void receiveBagListReply(QNetworkReply *reply);
    void receiveLoginReply(QNetworkReply *reply);
    Q_INVOKABLE void printLog(QString msg);
    Q_INVOKABLE void login(QString username, QString password);
    Q_INVOKABLE void saveToken(QString token);
    Q_INVOKABLE void registerBag(int bagId, QString bagInfo);
    Q_INVOKABLE void loadImage(QString imagePath);

signals:
    void sendBagInfo(QString bagInfo);
    void sendLoginRes(QString loginRes);
    void navigatePage(int pageState, QString params);
public slots:
    void TimeOutSlot();

};

#endif // HOME_H
