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


#pragma execution_character_set("utf-8")

class Home : public QObject
{
    Q_OBJECT
public:
    explicit Home(QObject *parent = nullptr);
    ~Home();
    Q_INVOKABLE void fetchBag(int bagId = 0, int type = 0, int ps = 1);
    Q_INVOKABLE int test(int id);
    void receiveReply(QNetworkReply *reply);

signals:
    void sendBagInfo(QString bagInfo);

};

#endif // HOME_H
