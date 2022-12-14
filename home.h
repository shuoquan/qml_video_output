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
#include <QFile>
#include <QDir>
#include <QQuickWindow>

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
    Q_INVOKABLE void fetchBag(int bagId = 0, int type = 0, int ps = 1, int pageState = 1);
    Q_INVOKABLE int test(int id);
    void receiveBagListReply(QNetworkReply *reply);
    void receiveSingleBagReply(QNetworkReply *reply);
    void receiveBagStatisticReply(QNetworkReply *reply);
    void receiveLoginReply(QNetworkReply *reply);
    void receiveSubmitBagRegisterReply(QNetworkReply *reply);
    Q_INVOKABLE void printLog(QString msg);
    Q_INVOKABLE void login(QString username, QString password);
    Q_INVOKABLE void saveToken(QString token);
    Q_INVOKABLE void registerBag(int bagId, QString bagInfo);
    Q_INVOKABLE void loadImage(QString imagePath);
    Q_INVOKABLE void loginSuccess();
    Q_INVOKABLE void popup(double opacity);
    Q_INVOKABLE void goToPage(int pageState, QString params = "{}");
    Q_INVOKABLE void getBagList(int startTime, int endTime, QString cat = "", QString user = "", QString auditor = "");
    Q_INVOKABLE void submitBagRegisterInfo(QString userInfo, QString categoryInfo, int bagStatus);
    Q_INVOKABLE void changeBagStatus(int bagId, int status);
    Q_INVOKABLE void deleteHistoryPic();
    Q_INVOKABLE void changeNextStatus(bool flag);
    Q_INVOKABLE void modifyPageState(int pageState);
//    Q_INVOKABLE void getNext();

signals:
    void sendBagInfo(QString bagInfo, int pageType);
    void sendLoginRes(QString loginRes);
    void navigatePage(int pageState, QString params);
    void modifyOpacity(double opacity);
    void modifyBagStatus(int bagId, int status);
    void modifyNextStatus(bool flag);
//    void bagRegisterSuccess();
public slots:
    void TimeOutSlot();

};

#endif // HOME_H
