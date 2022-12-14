#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "videoadapter.h"
#include "home.h"
#include <QtQml>
#include "logHandler.h"
#include "global.cpp"
#include <QFile>
#include <QQuickWindow>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::VulkanRhi);
//    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Unknown);
//    qDebug() << QQuickWindow::sceneGraphBackend() << "--------";
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    QGuiApplication app(argc, argv);
//    qDebug() << QDate::currentDate() << "时间";
    // 安装消息处理函数
    LogHandler::Get().installMessageHandler();

    QQmlApplicationEngine engine;

    QString configPath =  QCoreApplication::applicationDirPath() + "/config.properties";
    QFile file(configPath);
    if (file.exists()) {
        if(file.open(QFile::ReadOnly)) {
             QString data = file.readAll();
             // 按照\n分割
             QStringList list = data.split("\n");
             for (int i = 0; i < list.size(); i++) {
                 QString line = list.at(i);
                 if (line.startsWith("videoIp")) {
                     config.videoIp = line.split("=").at(1);
                 } else if (line.startsWith("videoPort")) {
                     config.videoPort = line.split("=").at(1).toInt();
                 } else if (line.startsWith("unpackBackendIp")) {
                     config.unpackBackendIp = line.split("=").at(1);
                 } else if (line.startsWith("unpackBackendPort")) {
                     config.unpackBackendPort = line.split("=").at(1).toInt();
                 } else if (line.startsWith("unpackBackendUrl")) {
                     config.unpackBackendUrl = line.split("=").at(1);
                 } else if (line.startsWith("imagePrefix")) {
                     config.imagePrefix = line.split("=").at(1);
                 }
             }
             file.close();
        }
    }

    Home home;
    VideoAdapter videoAdapter;
    engine.rootContext()->setContextProperty("videoSrc", &videoAdapter);
    engine.rootContext()->setContextProperty("homeSrc", &home);
    engine.rootContext()->setContextProperty("imagePrefix", config.imagePrefix);
//    qmlRegisterType<VideoAdapter>("VideoAdapter", 1, 0, "VideoAdapter");

//    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/myKeyboard.qml")));
//    engine.

    if (engine.rootObjects().isEmpty())
        return -1;

    // 取消安装自定义消息处理，然后启用
//    LogHandler::Get().uninstallMessageHandler();
    return app.exec();
}
