import QtQuick 2.9
import QtQuick.Window 2.2
import pl.p2p 1.0
import QtQuick.Controls 2.3

//---------MAIN WINDOW---------------

Window {
    id: window
    visible: true
    width: 640
    height: 480
    minimumHeight: 480
    minimumWidth: 640
    title: qsTr("p2p chat")

    Controller {
        id: controller
        onNewMessage:
        {
                if(controller.message.match(/file.*png/i) || controller.message.match(/file.*jpg/i))
                {
                    var source = controller.message.match(/file.*'\>/i)
                    source = source[0].toString().slice(0, -2)
                    console.log(source)
                    messagesModel.append({'msgType':'received', 'src':source, 'msg':''})
                }
                else
                    messagesModel.append({'msgType':'received', 'msg':controller.message, 'src':""})
        }
        onClearMessagesAndChangeCurrentConversation: {
            messagesModel.clear()
            connections.currentIndex = index
        }
        onLoadMessage:{
            var source
            if(!sender)
            {
                if(str.match(/file.*png/i) || str.match(/file.*jpg/i))
                {
                    source = str.match(/file.*'\>/i)
                    source = source[0].toString().slice(0, -2)
                    messagesModel.append({'msgType':'received', 'src':source, 'msg':''})
                }
                else
                    messagesModel.append({'msgType':'received', 'msg':qsTr(str), 'src':""})
            }
            else
            {
                if(str.match(/file.*png/i) || str.match(/file.*jpg/i))
                {
                    source = str.match(/file.*'\>/i)
                    source = source[0].toString().slice(0, -2)
                    messagesModel.append({'msgType':'sent', 'src':source, 'msg':''})
                }
                else
                    messagesModel.append({'msgType':'sent', 'msg':qsTr(str), 'src':""})
            }
        }
        onNewConnection:
        {
            connectionsModel.append({'ip':ipAdress, 'port':port, 'als':name, 'connected':false, 'pending':false})
        }

        onNewPendingConnection: connectionsModel.append({'ip':ipAdress, 'port':port, 'als':name, 'connected':false, 'pending':true})
        onSetAccepted: {
            connectionsModel.setProperty(index, "connected", true)
        }
        Component.onCompleted: {controller.loadConversations()}
    }


    //---------CONNECTIONS PANNEL---------------

    Rectangle {
        id: bgConnections
        color: "#3b3b3b"
        y: 0
        width: 0.3*parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0

        //---------CONNECTIONS LIST---------------

         ListView {
            id: connections
            width: parent.width
            height: parent.height - 100
            anchors.bottom: parent.bottom
            model: ListModel {
                id: connectionsModel
                property var pending: null
            }
            delegate: Rectangle {
                height: 55
                width: parent.width
                color: connections.currentIndex === index ? "#595959" : "#3b3b3b"
                Rectangle {
                      width: parent.width
                      height: 1
                      anchors.bottom: parent.bottom
                      color: "#636363"
                }
                Rectangle {
                    id: logoType
                    height: 42.5
                    width: 42.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    radius: width / 2
                    color: Qt.rgba(Math.random(),Math.random(),Math.random(), 1)
                    border.color: "#2e2e2e"
                    border.width: 1
                    Label {
                        anchors.fill: parent
                        font.pixelSize: 30
                        font.bold: true
                        text: als[0].toUpperCase()
                        color: '#ffffff'
                        verticalAlignment: TextInput.AlignVCenter
                        horizontalAlignment: TextInput.AlignHCenter
                    }
                }

                Rectangle {
                    anchors.left: logoType.right
                    anchors.top: parent.top
                    height: parent.height-1
                    width: parent.width-50
                    color: "transparent"
                    Label {
                        id: aliasLabel
                        anchors.top: parent.top
                        anchors.topMargin: 2
                        text: als
                        color: "#adadad"
                        font.bold: true
                        font.pixelSize: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: ipPortLabel
                        anchors.top: aliasLabel.bottom
                        anchors.topMargin: 2
                        text: ip + ":" + port
                        color: "#adadad"
                        font.pixelSize: 9
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        id: connectionIdenticator
                        visible: (!connected && !pending) ? true : false
                        color: '#ff0000'
                        width: 8
                        height: 8
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                        radius: 4
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            PropertyAnimation {
                             target: connectionIdenticator
                                property: "opacity"
                                from: 0.0
                                to: 1.0
                                duration: 1000
                            }
                            PropertyAnimation {
                                target: connectionIdenticator
                                property: "opacity"
                                from: 1.0
                                to: 0.0
                                duration: 1000
                            }
                        }
                    }
                    Rectangle {
                        visible: (connected && !pending) ? true : false
                        color: '#00ff00'
                        width: 8
                        height: 8
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 6
                        radius: 4
                    }

                    //-------------ACCEPT/REJECT BUTTONS

                    Rectangle {
                        id: acceptConnectionButton
                        z: 2
                        visible: pending ? true : false
                        anchors.top: ipPortLabel.bottom
                        anchors.topMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: -width / 2
                        anchors.leftMargin: 3
                        implicitWidth: acceptConnectionButtonText.contentWidth + 20
                        implicitHeight: 16
                        color: "#008502"
                        radius: 6
                        border.color: "#005701"
                        border.width: 1
                        Text {
                            id: acceptConnectionButtonText
                            text: "ACCEPT"
                            anchors.centerIn: parent
                            font.pixelSize: 9
                            color: '#ffffff'
                        }
                        MouseArea {
                            id: acceptConnectionButtonMouseArea
                            z: 2
                            hoverEnabled: true
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "#00b503"
                            }
                            onExited: {
                                parent.color = "#008502"
                            }
                            onClicked: {
                                controller.acceptConnection(index)
                                connectionsModel.setProperty(index, "pending", false)
                                connectionsModel.setProperty(index, "connected", true)
                            }
                        }
                    }

                    Rectangle {
                        id: rejectConnectionButton
                        visible: pending ? true : false
                        anchors.top: ipPortLabel.bottom
                        anchors.topMargin: 2
                        anchors.left: acceptConnectionButton.right
                        anchors.leftMargin: 3
                        implicitWidth: rejectConnectionButtonText.contentWidth + 20
                        implicitHeight: 16
                        color: "#ad0000"
                        radius: 6
                        border.color: "#6e0000"
                        border.width: 1
                        //z:2
                        Text {
                            id: rejectConnectionButtonText
                            text: "Reject"
                            anchors.centerIn: parent
                            font.pixelSize: 9
                            color: '#ffffff'
                        }
                        MouseArea {
                            id: rejectConnectionButtonMouseArea
                            hoverEnabled: true
                            anchors.fill: parent
                            onEntered: {
                                parent.color = "#ff0000"
                            }
                            onExited: {
                                parent.color = "#ad0000"
                            }
                            onClicked: {
                                connectionsModel.remove(index)
                                controller.rejectConnection(index)
                            }
                        }
                    }
                MouseArea {
                       anchors.fill: parent
                       onClicked: {
                             connections.currentIndex = index
                             controller.changeCurrentConversation(index)
                        }
                 }
            }

         }
         }

        //---------NEW CONNECTION---------------

         Rectangle {
             id: newConnection
             x: 0
             y: 0
             width: parent.width
             height: 100
             color: "#3b3b3b"
             z: 1
             Rectangle {
                     id: borderBottomNewConnection
                     width: parent.width
                     height: 1
                     anchors.bottom: parent.bottom
                     color: "#636363"
             }


             Label {
                id: newConnectionLabel
                text: "New connection"
                color: 'white'
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 3
             }


             TextField {
                 id: newAliasInput
                 anchors.top: newConnectionLabel.bottom
                 anchors.topMargin: 3
                 anchors.horizontalCenter: parent.horizontalCenter
                 width: parent.width * 0.8
                 height: 22
                 placeholderText: "Name"
                 font.pixelSize: 10
                 verticalAlignment: TextInput.AlignVCenter
                 horizontalAlignment: TextInput.AlignHCenter
                 color: "#adadad"
                 background: Rectangle {
                     radius: 8
                     color: "#2e2e2e"
                     border.color: "#242424"
                     border.width: 1
                 }
                 Keys.onReturnPressed: {
                     if(newPortInput.acceptableInput && newAliasInput.text !== "" && newIpInput.acceptableInput)
                         controller.createNewConnection(newAliasInput.text, newIpInput.text, newPortInput.text)
                         newIpInput.text = ""
                         newAliasInput.text = ""
                         newPortInput.text = ""
                     }
                 }




            TextField {
                id: newIpInput
                anchors.top: newAliasInput.bottom
                anchors.topMargin: 3
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.1
                placeholderText: "IP Adress"
                height: 22
                width: parent.width * 0.55 -1
                font.pixelSize: 10
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                color: "#adadad"
                validator: RegExpValidator { regExp: /([0-9]{1,3}\.){3}[0-9]{1,3}/ }
                background: Rectangle {
                    radius: 8
                    color: "#2e2e2e"
                    border.color: "#242424"
                    border.width: 1
                }
                Keys.onReturnPressed: {
                    if(newPortInput.acceptableInput && newAliasInput.text !== "" && newIpInput.acceptableInput)
                        controller.createNewConnection(newAliasInput.text, newIpInput.text, newPortInput.text)
                        newIpInput.text = ""
                        newAliasInput.text = ""
                        newPortInput.text = ""
                    }
                }



            TextField {
                id: newPortInput
                anchors.top: newAliasInput.bottom
                anchors.topMargin: 3
                anchors.left: newIpInput.right
                anchors.leftMargin: 2
                placeholderText: "Port"
                height: 22
                width: parent.width * 0.25 -1
                font.pixelSize: 10
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                color: "#adadad"
                validator: RegExpValidator { regExp: /[0-9]{1,5}/ }
                background: Rectangle {
                    radius: 8
                    color: "#2e2e2e"
                    border.color: "#242424"
                    border.width: 1
                }
                Keys.onReturnPressed: {
                    if(newPortInput.acceptableInput && newAliasInput.text !== "" && newIpInput.acceptableInput)
                        controller.createNewConnection(newAliasInput.text, newIpInput.text, newPortInput.text)
                        newIpInput.text = ""
                        newAliasInput.text = ""
                        newPortInput.text = ""
                    }
                }



            Rectangle {
                id: newConnectionButton
                anchors.top: newPortInput.bottom
                anchors.topMargin: 3
                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: newConnectionButtonText.contentWidth + 20
                implicitHeight: 22
                color: "#636363"
                radius: 8
                border.color: "#242424"
                border.width: 1
                Text {
                    id: newConnectionButtonText
                    text: "Connect"
                    anchors.centerIn: parent
                    font.pixelSize: 10
                    color: '#ffffff'
                }
                MouseArea {
                    id: newConnectionButtonMouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {
                        parent.color = "#adadad"
                        newConnectionButtonText.color = "#242424"
                    }
                    onExited: {
                        parent.color = "#636363"
                        newConnectionButtonText.color = "#ffffff"
                    }
                    onClicked: {
                        if(newPortInput.acceptableInput && newAliasInput.text !== "" && newIpInput.acceptableInput)
                            controller.createNewConnection(newAliasInput.text, newIpInput.text, newPortInput.text)
                            newIpInput.text = ""
                            newAliasInput.text = ""
                            newPortInput.text = ""
                            forceActiveFocus()
                        }
                    }
                }

            }
    }
    //---------MESSAGES PANNEL---------------

    Rectangle {
        id: bgMessages
        y: 0
        width: 0.5*parent.width
        height: parent.height
        anchors.right: bgRightPanel.left
        color: "#2e2e2e"
        //FontLoader { id: emojiFont; source: "qrc://qml/resource/NotoSans.ttf"; }

        Rectangle {
                id: borderLeftBgMessages
                width: 1
                height: parent.height
                anchors.left: parent.left
                color: "#000000"
        }

        Rectangle {
                id: borderRightBgMessages
                width: 1
                height: parent.height
                anchors.right: parent.right
                color: "#000000"
        }

        //---------MESSAGES LIST---------------

        ScrollView {
            height: parent.height - 80
            width: parent.width
            anchors.top: parent.top

            ListView {
                id: messages
                anchors.fill: parent
                spacing: 5
                model: ListModel {
                    id: messagesModel
                }
                delegate: Rectangle {
                    anchors.topMargin: 10
                    width: messages.width * 0.6
                    height: Math.max(mssg.contentHeight + 12, img.height)
                    color: msgType == 'sent' ? "#428bad" : "#4db3a3"
                    radius: 8
                    anchors.right: msgType == 'sent' ? parent.right : undefined
                    anchors.left: msgType == 'received' ? parent.left : undefined
                    anchors.rightMargin: msgType == 'sent' ? 10 : undefined
                    anchors.leftMargin: msgType == 'received' ? 10 : undefined
                            TextEdit {
                                anchors.fill: parent
                                anchors.leftMargin: 5
                                id: mssg
                                color: '#ffffff'
                                text: msg
                                font.pointSize: 9
                                wrapMode: Text.Wrap
                                textFormat: Text.RichText
                                verticalAlignment: Text.AlignVCenter
                                readOnly: true
                                selectByMouse: true
                                onLinkActivated: Qt.openUrlExternally(link)
                                MouseArea {
                                        anchors.fill: parent
                                        acceptedButtons: Qt.NoButton
                                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    }
                            }
                            Image {
                                id: img
                                source: src ? src : ""
                                fillMode: Image.PreserveAspectFit
                                sourceSize.width: messages.width * 0.6
                                MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            Qt.openUrlExternally(parent.source)
                                        }
                                    }
                            }
                    }
                onCountChanged: {
                    var newIndex = count - 1
                    positionViewAtEnd()
                    currentIndex = newIndex
                }
                }
        }

        //---------MESSAGES INPUT---------------

        Rectangle {
                id: messagesTextArea
                width: parent.width
                height: 70
                anchors.bottom: parent.bottom
                color: "#2e2e2e"
                Rectangle {
                    id: borderTopMessagesTextArea
                    width: parent.width
                    height: 1
                    anchors.top: parent.top
                    color: "#636363"
                }
                Rectangle {
                        id: borderLeftMessagesTextArea
                        width: 1
                        height: parent.height
                        anchors.left: parent.left
                        color: "#000000"
                }

                Rectangle {
                        id: borderRightMessagesTextArea
                        width: 1
                        height: parent.height
                        anchors.right: parent.right
                        color: "#000000"
                }

                    ScrollView {
                        id: messageInput
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        height: parent.height *0.67
                        width: parent.width-70                        
                        TextArea {
                            id: messageArea
                            enabled: (!connectionsModel.count || connectionsModel.get(connections.currentIndex).pending || !connectionsModel.get(connections.currentIndex).connected) ? false : true
                            placeholderText: "Type your message..."
                            verticalAlignment: TextEdit.AlignVCenter
                            wrapMode: TextArea.Wrap
                            font.pixelSize: 14
                            selectByMouse: true
                            color: "#adadad"
                            property var urls: []
                            //textFormat: Text.RichText
                            background: Rectangle {
                                height: parent.height
                                width: parent.width
                                id: bgMessageInput
                                radius: 5
                                color: "#242424"
                                border.color: '#1f1f1f'
                                border.width: 1
                            }
                            Keys.onReturnPressed: {
                                if (messageArea.text != ""){
                                    if(urls.length > 0 ){
                                        for(var file of urls)
                                        {
                                            console.log(file)
                                            if(file.match(/.png$/i) || file.match(/.jpg$/i))
                                            {
                                                messagesModel.append({'msgType':'sent', 'src':file, 'msg':''})
                                            }
                                            else
                                                messagesModel.append({'msgType':'sent', 'src':"", 'msg':qsTr(messageArea.text)})
                                            controller.sendMessage(file , 'f')
                                        }
                                        urls = []
                                    }
                                    else
                                    {
                                        messagesModel.append({'msgType':'sent', 'msg':qsTr(messageArea.text), 'src':""})
                                        controller.sendMessage(messageArea.text, 'm')
                                    }

                                    messageArea.textFormat = Text.PlainText
                                    messageArea.text=""
                                }
                            }
                            DropArea {
                                    id: drop
                                    anchors.fill: parent
                                    onDropped: {
                                        for(var file of drop.urls)
                                        {
                                            parent.text += '<style type="text/css">a{color: #ffffff;font-size:12px;}</style><a href="' + file + '"><i>' + file.match(/[^\/]+$/) + '</i></a>' + " "
                                            messageArea.urls.push(file)
                                        }
                                        messageArea.textFormat = Text.RichText
                                    }
                                }
                    }
                }
                Rectangle {
                    id: sendButton
                    anchors.left: messageInput.right
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 25
                    implicitHeight: 25
                    color: "#636363"
                    radius: 12.5
                    border.color: "#242424"
                    border.width: 1
                    Text {
                        text: ">"
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        id: sendMouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            parent.color = "#adadad"
                        }
                        onExited: {
                            parent.color = "#636363"
                        }
                        onClicked: {
                            if (messageArea.text != ""){
                                if(urls.length > 0 ){
                                    for(var file of urls)
                                    {
                                        console.log(file)
                                        if(file.match(/.png$/i) || file.match(/.jpg$/i))
                                        {
                                            messagesModel.append({'msgType':'sent', 'src':file, 'msg':''})
                                        }
                                        else
                                            messagesModel.append({'msgType':'sent', 'src':"", 'msg':qsTr(messageArea.text)})
                                        controller.sendMessage(file , 'f')
                                    }
                                    urls = []
                                }
                                else
                                {
                                    messagesModel.append({'msgType':'sent', 'msg':qsTr(messageArea.text), 'src':""})
                                    controller.sendMessage(messageArea.text, 'm')
                                }

                                messageArea.textFormat = Text.PlainText
                                messageArea.text=""
                            }
                        }
                    }
                }
        }

    }

    //---------RIGHT PANNEL---------------

    Rectangle {
        id: bgRightPanel
        color: "#3b3b3b"
        y: 0
        width: 0.2*parent.width
        height: parent.height
        anchors.right: parent.right     
        }
    }

