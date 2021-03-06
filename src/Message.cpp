//
// Created by student on 27.01.2020.
//

#include "include/Message.hpp"

#include <utility>

QString Message::getText() const {
    return text;
}

void Message::setText(QString text) {
    this->text = std::move(text);
}

bool Message::isSender() const {
    return sender;
}

Message::Message(QString str, bool sent): text(std::move(str)), sender(sent) {

};