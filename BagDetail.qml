import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQml 2.15

Rectangle {
    property string userPhoneNum: ''
    //    property string userPic: './images/demo.jpg'
    property string userPic: ''
    property var imageList: ['./images/demo.jpg', './images/demo.jpg', './images/demo.jpg', './images/demo.jpg']
    anchors.fill: parent
    color: "green"
    Component.onCompleted: {
//        timer2.start()
    }

    Timer {
        id: timer2
        interval: 3000
        triggeredOnStart: false
        repeat: true
        onTriggered: {
            imageList = [...imageList, './images/demo.jpg']
//            imageList.push('./images/demo.jpg')
            console.log('aaa')
        }
    }
    Rectangle {
        id: leftArea
        anchors.left: parent.left
        width: parent.width / 4
        height: parent.height
        //        color: "blue"
        ScrollView {
            id: leftScroll
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0.05 * parent.width
            anchors.rightMargin: 0.05 * parent.width
            anchors.topMargin: 0.05 * parent.height
            anchors.bottomMargin: 0.05 * parent.height
//            width: parent.width / 10 * 9
//            height: parent.height / 10 * 9
//            anchors.centerIn: parent
            clip: true
            Rectangle {
                id: picArea
                anchors.left: parent.left
                width: parent.width
                height: grid.height
                color: "Red"
                Grid {
                    id: grid
                    columns: 2
                    anchors.left: parent.left
                    Repeater {
                        model: imageList
                        delegate: imageDelegate
                    }
                    Component {
                        id: imageDelegate
                        Rectangle {
                            width: leftScroll.width / 2 - 2
                            height: leftScroll.width / 3 - 2
                            border.width: 1
                            border.color: "#bfbfbf"
                            Image {
                                source: modelData
                                fillMode: Image.PreserveAspectFit
                                height: parent.height / 10 * 9
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: time
                anchors.left: parent.left
                anchors.top: picArea.bottom
                anchors.topMargin: parent.width / 6
                width: parent.width
                height: parent.width / 6
                Rectangle {
                    id: timeLeft
                    width: parent.width / 5
                    height: parent.height
                    //                    color: "red"
                    Text {
                        anchors.left: parent.left
                        text: '时间'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                    Text {
                        anchors.right: parent.right
                        text: ':'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
                Rectangle {
                    width: parent.width / 5 * 4
                    height: parent.height
                    anchors.left: timeLeft.right
                    //                    color: "yellow"
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: '2022-12-05 09:19:05'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
            }
            Rectangle {
                id: contraband
                anchors.left: parent.left
                anchors.top:time.bottom
                width: parent.width
                height: parent.width / 6
                Rectangle {
                    id: contrabandLeft
                    width: parent.width / 5
                    height: parent.height
                    Text {
                        anchors.left: parent.left
                        text: '禁带品'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                    Text {
                        anchors.right: parent.right
                        text: ':'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
                Rectangle {
                    width: parent.width / 5 * 4
                    height: parent.height
                    anchors.left: contrabandLeft.right
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: '刀具、压力罐'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
            }
            Rectangle {
                id: auditor
                anchors.left: parent.left
                anchors.top: contraband.bottom
                width: parent.width
                height: parent.width / 6
                Rectangle {
                    id: auditorLeft
                    width: parent.width / 5
                    height: parent.height
                    Text {
                        anchors.left: parent.left
                        text: '开包员'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                    Text {
                        anchors.right: parent.right
                        text: ':'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
                Rectangle {
                    width: parent.width / 5 * 4
                    height: parent.height
                    anchors.left: auditorLeft.right
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: '张三'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
            }
            Rectangle {
                id: bagUser
                anchors.left: parent.left
                anchors.top: auditor.bottom
                width: parent.width
                height: parent.width / 6
                Rectangle {
                    id: bagUserLeft
                    width: parent.width / 5
                    height: parent.height
                    Text {
                        anchors.left: parent.left
                        text: '旅客'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                    Text {
                        anchors.right: parent.right
                        text: ':'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
                Rectangle {
                    width: parent.width / 5 * 2
                    height: parent.height
                    anchors.left: bagUserLeft.right
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: '李四'
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 3
                    }
                }
                Rectangle {
                    width: parent.width / 5 * 2
                    height: parent.height
                    anchors.right: parent.right
                    Button {
                        id: detailButton
                        anchors.centerIn: parent
                        height: parent.height * 0.6
                        width: parent.width * 0.6
                        background: Rectangle {
                            //                            implicitWidth:  parent.width * 0.6
                            //                            implicitHeight:  parent.height * 0.2
                            //                            color: 'red'
                        }
                        contentItem: Text {
                            text:  "详细信息"
                            font.family: "微软雅黑"
                            color: "#2E75B6"
                            font.pixelSize: parent.height / 2
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: {
                            detailPop.open();
                        }
                    }
                }
                Popup {
                    id: detailPop
                    width: time.width * 1.2
                    height: time.width * 1.2 * 0.75
                    x: time.width
                    y: time.width * 1.2 * 0.75 * (-0.6)
                    padding: 0
                    background: Rectangle {
                        border.width: 1
                        border.color: "#BFBFBF"
                    }

                    Rectangle {
                        anchors.fill: parent
                        Rectangle {
                            height: parent.height / 10
                            width: parent.height / 10
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.rightMargin: parent.height / 10 * 0.6
                            anchors.topMargin: parent.height / 10 * 0.2                            //                color: "green"
                            Image {
                                source: './images/close-dark.png'
                                fillMode: Image.PreserveAspectFit
                                height: parent.height
                                anchors.centerIn: parent
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log('close')
                                        detailPop.close();
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: userName
                            width: parent.width * 0.8
                            anchors.left: parent.left
                            anchors.leftMargin: 0.1 * parent.width
                            height: parent.height / 8
                            //                            color: "red"
                            anchors.top: parent.top
                            anchors.topMargin: parent.height / 8
                            Text {
                                id: userNameLeft
                                anchors.left: parent.left
                                text: '姓名:'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                            Text {
                                anchors.left: userNameLeft.right
                                anchors.leftMargin: 10
                                text: '李四'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                        }
                        Rectangle {
                            id: userPhone
                            width: parent.width * 0.8
                            anchors.left: parent.left
                            anchors.leftMargin: 0.1 * parent.width
                            height: parent.height / 8
                            //                            color: "red"
                            anchors.top: userName.bottom
                            //                            anchors.topMargin: parent.height / 16
                            Text {
                                id: userPhoneLeft
                                anchors.left: parent.left
                                text: '电话:'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                            Text {
                                anchors.left: userPhoneLeft.right
                                anchors.leftMargin: 10
                                text: userPhoneNum ? userPhoneNum : '无'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                        }
                        Rectangle {
                            id: identity
                            visible: !userPic
                            width: parent.width * 0.8
                            anchors.left: parent.left
                            anchors.leftMargin: 0.1 * parent.width
                            height: parent.height / 8
                            anchors.top: userPhone.bottom
                            Text {
                                id: identityLeft
                                anchors.left: parent.left
                                text: '身份证:'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                            Text {
                                anchors.left: identityLeft.right
                                anchors.leftMargin: 10
                                text: '无'
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 2
                            }
                        }
                        Image {
                            visible: !!userPic
                            width: parent.width * 0.8
                            anchors.left: parent.left
                            anchors.leftMargin: 0.1 * parent.width
                            anchors.top: userPhone.bottom
                            height: parent.height * 0.6
                            source: userPic
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                }
            }
        }
    }
    Rectangle {
        id: middleArea
        anchors.left: leftArea.right
        width: 10
        height: parent.height
        color: "#d9d9d9"
    }
    Rectangle {
        id: rightArea
        anchors.right: parent.right
        width: parent.width / 4 * 3 - 10
        height: parent.height
        Image {
            source: './images/demo.jpg'
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }
    }
}
