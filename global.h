#ifndef GLOBAL_H
#define GLOBAL_H
#include <QObject>
struct Config {
    QString videoIp;
    int videoPort;
    QString unpackBackendIp;
    int unpackBackendPort;
    QString unpackBackendUrl;
    QString imagePrefix;
    QString token;
    int pageState;
};
extern Config config;
#endif // GLOBAL_H
