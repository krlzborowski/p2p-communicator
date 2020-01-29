//
// Created by wojtek on 26.01.2020.
//

#ifndef OOP_2019_KOMUNIKATOR_P2P_CONTROLLER_HPP
#define OOP_2019_KOMUNIKATOR_P2P_CONTROLLER_HPP

#include "include/Server.hpp"
#include "include/Conversation.hpp"
#include "include/Database.hpp"

#include <QObject>
#include <memory>

class Controller : public QObject {
Q_OBJECT
    Q_PROPERTY(QString message
                       WRITE
                       sendMessage
                       READ
                       getMessage)
public:
    Controller();

    void sendMessage(const QString &str);
    Q_INVOKABLE void createNewConnection(QString name, const QString& ip, qint16 port);
    Q_INVOKABLE void acceptConnection(qint8 idx);
    const QString &getMessage();

private:
    std::unique_ptr<Server> server;
    std::unique_ptr<Database> database;
    std::shared_ptr<Conversation> currentConversation;
    QList<std::shared_ptr<Conversation>> conversations;
    QString lastMessage;



signals:

    void newMessage();
    void newConnection(QString ipAdress, QString port, QString name);
    void newPendingConnection(QString ipAdress, QString port, QString name);

public slots:

    void onNewMessage(const QString &);
    void onNewConnection(QTcpSocket *socket);

};


#endif //OOP_2019_KOMUNIKATOR_P2P_CONTROLLER_HPP
