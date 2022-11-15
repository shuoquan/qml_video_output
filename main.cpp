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

    // 安装消息处理函数
    LogHandler::Get().installMessageHandler();

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("videoSrc", new VideoAdapter);
    engine.rootContext()->setContextProperty("homeSrc", new Home);
//    qmlRegisterType<VideoAdapter>("VideoAdapter", 1, 0, "VideoAdapter");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // 取消安装自定义消息处理，然后启用
    LogHandler::Get().uninstallMessageHandler();
    return app.exec();
}
