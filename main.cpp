#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "videoadapter.h"
#include "home.h"
#include <QtQml>
#include "logHandler.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
//    qDebug() << QDate::currentDate() << "时间";
    // 安装消息处理函数
    LogHandler::Get().installMessageHandler();

    QQmlApplicationEngine engine;

    Home home;
    VideoAdapter videoAdapter;
    engine.rootContext()->setContextProperty("videoSrc", &videoAdapter);
    engine.rootContext()->setContextProperty("homeSrc", &home);
//    qmlRegisterType<VideoAdapter>("VideoAdapter", 1, 0, "VideoAdapter");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
//    engine.

    if (engine.rootObjects().isEmpty())
        return -1;

    // 取消安装自定义消息处理，然后启用
    LogHandler::Get().uninstallMessageHandler();
    return app.exec();
}
