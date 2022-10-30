#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "videoadapter.h"
#include <QtQml>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("videoSrc", new VideoAdapter);
    qmlRegisterType<VideoAdapter>("VideoAdapter", 1, 0, "VideoAdapter");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
