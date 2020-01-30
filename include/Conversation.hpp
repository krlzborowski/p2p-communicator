//
// Created by wojtek on 26.01.2020.
//

#ifndef OOP_2019_KOMUNIKATOR_P2P_CONVERSATION_HPP
#define OOP_2019_KOMUNIKATOR_P2P_CONVERSATION_HPP

#include "include/Connection.hpp"
#include "include/Message.hpp"
#include "include/File.hpp"

#include <QObject>
#include <QTcpSocket>
#include <memory>

class Conversation : public QObject {
Q_OBJECT
public:

    explicit Conversation(QString name, QTcpSocket *);

    explicit Conversation(QString name, const QString& ip, qint16 port);

    void sendMessage(const QString &str);
    void sendFile(const QString &str);

    const QVector<std::shared_ptr<Message>> &getMessages();

    QString getName();

    const std::unique_ptr<Connection> &getConnection();

private:
    QVector<std::shared_ptr<Message>> messages;
    QVector<std::shared_ptr<File>> files;
    std::unique_ptr<Connection> connection;
    QString name;

    void connectSlots();

signals:

    void newMessage(const QString &str);
    void status(Message::Status);

public slots:

    void onReceivedMessage(const std::shared_ptr<Message> &);
    void onReceivedStatus(QChar c);
    void onReceivedFile(const std::shared_ptr<File> &file);
};


#endif //OOP_2019_KOMUNIKATOR_P2P_CONVERSATION_HPP
