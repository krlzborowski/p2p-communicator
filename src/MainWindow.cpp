//
// Created by wojtek on 26.01.2020.
//


#include "include/MainWindow.hpp"

MainWindow::MainWindow(int argc, char **argv) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    app = std::make_unique<QGuiApplication>(argc, argv);
    engine = std::make_unique<QQmlApplicationEngine>();

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(engine.get(), &QQmlApplicationEngine::objectCreated,
                     app.get(), [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);
    engine->load(url);

    //server = std::make_shared<Server>(); //error
    server = new Server();
    //connect(server,SIGNAL(newConnection(QTcpSocket*)),this,SLOT(onNewConnection(QTcpSocket*)));//error
}

int MainWindow::run() {
    return app->exec();
}

bool MainWindow::acceptConnection() {
    //TODO
    return true;
}

void MainWindow::onNewConnection(QTcpSocket *socket) {
    if (acceptConnection()) {
        //TODO
    }
}
