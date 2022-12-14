import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import QtQuick.VirtualKeyBoard
//import QtQuick.VirtualKeyBoard 2.15

Rectangle {
    anchors.fill: parent
    signal loginSuccess(bool status)
    Component.onCompleted: {
    }

    Connections {
        target: homeSrc
        function onSendLoginRes(loginRes) {
            const loginObj = JSON.parse(loginRes);
            console.log(loginObj['statusCode'])
            if (loginObj['statusCode']) {
                const message = loginObj['message'] || '';
                if (message.includes('用户')) {
                    userMsg.text = message;
                }
                if (message.includes('密码')) {
                    passwordMsg.text = message;
                }
            } else {
                homeSrc.saveToken(loginObj['token'] || '');
//                console.log(loginRes, 'abc')
//                return
                homeSrc.goToPage(1, JSON.stringify({username: (loginObj['user'] || {})['username']}));
            }
        }
    }

    function login() {
        console.log("123", userText.text, passwordText.text)
        if (!userText.text) {
            userMsg.text = "请输入用户名"
        } else {
            userMsg.text = ""
        }
        if (!passwordText.text) {
            passwordMsg.text = "请输入密码"
        } else {
            passwordMsg.text = ""
        }
        if (userText.text && passwordText.text) {
            homeSrc.login(userText.text, passwordText.text);
//            loginSuccess(true);
        }
    }

    Image {
        source: './images/login.jpg'
        fillMode: Image.PreserveAspectCrop
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }
    Rectangle {
        height: 0.6 * parent.height
        width: 0.5 * parent.width
        anchors.centerIn: parent
        opacity: 0.6
    }

    Rectangle {
        id: loginBox
        height: 0.6 * parent.height
        width: 0.5 * parent.width
        anchors.centerIn: parent
        color: "transparent"
        //        opacity: 0.6
        Rectangle {
            id: title
            width: 0.8 * parent.width
            height: 0.28 * parent.height
            anchors.left: parent.left
            anchors.leftMargin: 0.1 * parent.width
            color: "transparent"
            Text {
                text: "智能安检查危登记系统"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 3.3
                font.bold: true
                color: "#203864"
                //                opacity: 1
            }
        }
        Rectangle {
            id: user
            anchors.top: title.bottom
            anchors.topMargin: 0.05 * parent.height
            width: 0.6 * parent.width
            height: 0.2 * parent.height
            anchors.left: parent.left
            anchors.leftMargin: 0.2 * parent.width
            color: "transparent"
            Rectangle {
                id: userPic
                width: 0.5 * parent.height
                height: 0.5 * parent.height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                //                color: "red"
                color: "transparent"
                anchors.bottomMargin: 0.1 * parent.height
                Image {
                    source: './images/user.png'
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                }
            }
            Rectangle {
                height: 0.5 * parent.height
                width: parent.width - userPic.width * 1.5
                anchors.left: userPic.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0.1 * parent.height
                anchors.leftMargin: 0.5 * userPic.width
                color: "transparent"
                TextField {
                    id: userText
                    anchors.fill: parent
                    anchors.margins: 6
                    font.pointSize: parent.height / 3
                    focus: true
                    placeholderText: "用户名"
                    placeholderTextColor: "#7f7f7f"
                    verticalAlignment: TextInput.AlignVCenter
                    background: Rectangle {
                        color: "transparent"
                        border.width: 0
                    }
                    onEditingFinished: {
//                        login();
                    }
                    Keys.onReleased: {
                        if (event.key === Qt.Key_Return) {
                            login();
                        }
                    }
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                color: "#7f7f7f"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
            }
        }
        Text {
            id: userMsg
            text: ""
            color: "red"
            font.family: "微软雅黑"
            font.pixelSize: 16
            anchors.top: user.bottom
            anchors.left: parent.left
            anchors.leftMargin: 0.2 * parent.width + 1.5 * userPic.width
        }

        Rectangle {
            id: password
            anchors.top: user.bottom
            width: 0.6 * parent.width
            height: 0.2 * parent.height
            anchors.left: parent.left
            anchors.leftMargin: 0.2 * parent.width
            color: "transparent"
            Rectangle {
                id: passwordPic
                width: 0.5 * parent.height
                height: 0.5 * parent.height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                //                color: "red"
                color: "transparent"
                anchors.bottomMargin: 0.1 * parent.height
                Image {
                    source: './images/password.png'
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                }
            }
            Rectangle {
                height: 0.5 * parent.height
                width: parent.width - passwordPic.width * 1.5
                anchors.left: passwordPic.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0.1 * parent.height
                anchors.leftMargin: 0.5 * passwordPic.width
                color: "transparent"
                TextField {
                    id: passwordText
                    anchors.fill: parent
                    anchors.margins: 6
                    font.pointSize: parent.height / 3
                    focus: true
                    placeholderText: "密码"
                    placeholderTextColor: "#7f7f7f"
                    echoMode: TextInput.Password
                    verticalAlignment: TextInput.AlignVCenter
                    background: Rectangle {
                        color: "transparent"
                        border.width: 0
                    }
                    onEditingFinished: {
//                        login();
                    }
                    Keys.onReleased: {
                        if (event.key === Qt.Key_Return) {
                            login();
                        }
                    }
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                color: "#7f7f7f"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 1
            }
        }
        Text {
            id: passwordMsg
            text: ""
            color: "red"
            font.family: "微软雅黑"
            font.pixelSize: 16
            anchors.top: password.bottom
            anchors.left: parent.left
            anchors.leftMargin: 0.2 * parent.width + 1.5 * userPic.width
        }
        Button {
            id: loginButton
            text: "确认"
            anchors.left: parent.left
            anchors.leftMargin: 0.2 * parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0.15 * parent.height / 2
            background: Rectangle {
                implicitHeight: 0.12 * loginBox.height
                implicitWidth: 0.6 * loginBox.width
                radius: 4
                color: "#3664B1"
            }
            contentItem: Text {
                text: loginButton.text
                font.bold: true
                font.pixelSize: loginButton.height / 2
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                login();
            }
        }
    }
}
