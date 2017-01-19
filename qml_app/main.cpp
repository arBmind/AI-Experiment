#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSysInfo>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("cppHostName", QSysInfo::machineHostName());
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
