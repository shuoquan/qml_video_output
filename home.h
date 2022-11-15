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


#pragma execution_character_set("utf-8")

class Home : public QObject
{
    Q_OBJECT
public:
    QString ip;
    int port;
    bool connected;
    QTcpSocket* socket;
    QTimer *timer;
    explicit Home(QObject *parent = nullptr);
    ~Home();
    Q_INVOKABLE void fetchBag(int bagId = 0, int type = 0, int ps = 1);
    Q_INVOKABLE int test(int id);
    void receiveReply(QNetworkReply *reply);
    Q_INVOKABLE void printLog(QString msg);

signals:
    void sendBagInfo(QString bagInfo);

public slots:
    void TimeOutSlot();

};

#endif // HOME_H
