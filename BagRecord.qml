import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15 as Con2_1
import QtQuick.Controls 1.4  as Con1_4
import QtQuick.Controls.Styles 1.4
import QtQml 2.15

Rectangle {
    anchors.fill: parent
    property bool leftCalendar: false
    property bool rightCalendar: false
    property double startTime: 0
    property double endTime: 0
    property string categoryName: '类别'
    property int categoryId: 0
    property string bagUserName: ''
    property string auditorName: ''
    property int categoryIndex: -1
    property var categoryList: []
    Component.onCompleted: {
        categoryList = [
                    {
                        id: 1,
                        name: '刀具',
                    },
                    {
                        id: 2,
                        name: '枪支',
                    },
                    {
                        id: 3,
                        name: '弹药',
                    },
                    {
                        id: 4,
                        name: '警械',
                    },
                    {
                        id: 5,
                        name: '爆炸物',
                    },
                    {
                        id: 6,
                        name: '烟花爆竹',
                    },
                    {
                        id: 7,
                        name: '危险液体',
                    },
                    {
                        id: 8,
                        name: '压力罐',
                    },
                    {
                        id: 9,
                        name: '锤子斧头',
                    },
                    {
                        id: 10,
                        name: '蓄电池',
                    },
                    {
                        id: 11,
                        name: '移动电源',
                    },
                    {
                        id: 12,
                        name: '打火机',
                    },
                    {
                        id: 13,
                        name: '打火机',
                    },
                    {
                        id: 14,
                        name: '其他',
                    }
                ];
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            leftCalendar = false;
            rightCalendar = false;
        }
    }

    Rectangle {
        z: 2
        height: parent.height / 6
        width: parent.width * 0.92
        anchors.left: parent.left
        anchors.leftMargin: 0.04 * parent.width
//        color: "green"
        Rectangle {
            id: dateSelect
            height: parent.height / 2
            width: parent.height * 3
            //            color: "yellow"
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Text {
                id: leftTime
                text: "2022-10-30"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0.05 * parent.width
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rightCalendar = false;
                        leftCalendar = true
                    }
                }
            }
            Con1_4.Calendar {
                //                minimumDate: new Date(2022, 1, 1)
                anchors.top: dateSelect.bottom
                anchors.left: leftTime.left
                anchors.topMargin: 1
                visible: leftCalendar
                onSelectedDateChanged: {

                    //                    startTime = new Date(new Date(selectedDate).toLocaleDateString()).getTime()
                    console.log(new Date(new Date(new Date(selectedDate).getTime()).toLocaleDateString()))
                    startTime = new Date(new Date(new Date(selectedDate).getTime()).toLocaleDateString()).getTime()
                    console.log(new Date(new Date(new Date(Qt.formatDateTime(selectedDate, "yyyy-MM-dd hh:mm:ss")).getTime()).toLocaleDateString()))
                    console.log(new Date('2022/12/5'))
                    console.log(startTime, 'xxx')
                }
            }
            Text {
                id: middleText
                text: "至"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: leftTime.right
                anchors.leftMargin: 0.05 * parent.width
            }
            Text {
                id: rightTime
                text: "2022-10-30"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: middleText.right
                anchors.leftMargin: 0.05 * parent.width
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rightCalendar = true;
                        leftCalendar = false;
                    }
                }
            }
            Con1_4.Calendar {
                //                minimumDate: new Date(2022, 1, 1)
                anchors.top: dateSelect.bottom
                anchors.left: rightTime.left
                anchors.topMargin: 1
                visible: rightCalendar
//                z: 3
            }
            Image {
                source: './images/calendar.png'
                fillMode: Image.PreserveAspectCrop
                anchors.verticalCenter: parent.verticalCenter
                //                   width: parent.width
                height: parent.height / 2
                anchors.right: parent.right
                anchors.rightMargin:  0.05 * parent.width
            }
        }

        Rectangle {
            id: categorySelect
            height: parent.height / 2
            width: parent.width / 0.92 < 1400 ? parent.height * 1.2 : parent.height * 1.5
            anchors.left: dateSelect.right
            anchors.leftMargin: parent.height / 20
            //            color: "red"
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Text {
                text: categoryName
                font.pixelSize: parent.height / 3
                //                                            font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin:  0.2 * parent.width
                font.family: "微软雅黑"
            }
            Triangle {
                id: myTriangle
                width: parent.height / 4
                height: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0.2 * parent.width
                states: State {
                    name: "rotated"
                    PropertyChanges {
                        target: myTriangle
                        rotation: 180
                    }
                }
                transitions: Transition {
                    RotationAnimation {
                        duration: 200
                        direction: RotationAnimation.Clockwise
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    categoryPopup.open();
                }
            }
        }
        Con2_1.Popup {
            id: categoryPopup
            width: categorySelect.width * 2 + 2
            height: categorySelect.height * 7 + 12
            x: dateSelect.width + parent.height / 20
            y: parent.height / 4 * 3 + 2
            padding: 0
            background: Rectangle {
                border.width: 1
                border.color: "#BFBFBF"
            }
            onOpened: {
                myTriangle.state = "rotated";
            }
            onClosed: {
                myTriangle.state = "";
            }

            Grid {
                id: grid
                columns: 2
                rowSpacing: 2
                columnSpacing: 2
                anchors.fill: parent
                anchors.left: parent.left
                Repeater {
                    model: categoryList
                    delegate: categoryRepeaterDelegate
                }
                Component {
                    id: categoryRepeaterDelegate
                    Rectangle {
                        width: categorySelect.width
                        height: categorySelect.height
                        color: categoryName == modelData.name ? '#fff' : "#d9d9d9"
                        Text {
                            text: modelData.name
                            anchors.centerIn: parent
                            font.family: "微软雅黑"
                            font.pixelSize: parent.height / 3
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                categoryName = modelData.name
                            }
                        }
                    }
                }

            }
        }
        Rectangle {
            id: nameSelect
            height: parent.height / 2
            width: parent.width / 0.92 < 1400 ? parent.height * 1.2 : parent.height * 1.5
            anchors.left: categorySelect.right
            anchors.leftMargin: parent.height / 20
            //            color: "red"
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Con2_1.TextField {
                id: userText
                anchors.left: parent.left
                width: parent.width * 0.7
                height: parent.height
                anchors.margins: 6
                font.pointSize: parent.height / 5
                focus: true
                placeholderText: "旅客姓名"
                placeholderTextColor: "#7f7f7f"
                verticalAlignment: TextInput.AlignVCenter
                background: Rectangle {
                    color: "transparent"
                    //                    color: "red"
                    border.width: 0
                }
                onEditingFinished: {
                    //                        login();
                }
            }
            Rectangle {
                height: parent.height
                width: parent.width * 0.3 - 6
                color: "transparent"
                anchors.right: parent.right
                Image {
                    source: './images/little-search.png'
                    fillMode: Image.PreserveAspectFit
                    //                    width: Math.min(parent.width * 0.6, parent.height / 3.2)
                    width: parent.width
                    height: parent.height / 2
                    anchors.centerIn: parent
                }
            }

        }
        Rectangle {
            id: auditorSelect
            height: parent.height / 2
            width: parent.width / 0.92 < 1400 ? parent.height * 1.2 : parent.height * 1.5
            anchors.left: nameSelect.right
            anchors.leftMargin: parent.height / 20
            //            color: "red"
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Con2_1.TextField {
                id: auditorName
                anchors.left: parent.left
                width: parent.width * 0.7
                height: parent.height
                anchors.margins: 6
                font.pointSize: parent.height / 5
                focus: true
                placeholderText: "开包员"
                placeholderTextColor: "#7f7f7f"
                verticalAlignment: TextInput.AlignVCenter
                background: Rectangle {
                    color: "transparent"
                    //                    color: "red"
                    border.width: 0
                }
                onEditingFinished: {
                    //                        login();
                }
            }
            Rectangle {
                height: parent.height
                width: parent.width * 0.3 - 6
                color: "transparent"
                anchors.right: parent.right
                Image {
                    source: './images/little-search.png'
                    fillMode: Image.PreserveAspectFit
                    //                    width: Math.min(parent.width * 0.6, parent.height / 3.2)
                    width: parent.width
                    height: parent.height / 2
                    anchors.centerIn: parent
                }
            }

        }
        Con2_1.Button {
            id: searchButton
            text: "重置"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height / 2
            width: parent.height * 1
            background: Rectangle {
                anchors.fill: parent
                border.width: 1
                border.color: "#293351"
                //                implicitHeight: 0.12 * loginBox.height
                //                implicitWidth: 0.6 * loginBox.width
                //                radius: 4
                //                color: "#3664B1"
            }
            contentItem: Text {
                text: searchButton.text
                font.bold: true
                font.pixelSize: searchButton.height / 2
                color: "#293351"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
            }
        }

    }
    Rectangle {
        id: content
        anchors.bottom: parent.bottom
        height: parent.height / 6 * 5
        width: parent.width * 0.92
        anchors.left: parent.left
        anchors.leftMargin: 0.04 * parent.width
//        color: "blue"
        Rectangle {
            id: header
            width: parent.width
            height: parent.height / 7
            color: "#f2f2f2"
            Row {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    height: parent.height
                    width: parent.width / 16
                    color: "transparent"
                    Text {
                        text: "编号"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 3
                    color: "transparent"
                    Text {
                        text: "日期"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 2
                    color: "transparent"
                    Text {
                        text: "时间"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 2
                    color: "transparent"
                    Text {
                        text: "禁带品"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 2
                    color: "transparent"
                    Text {
                        text: "旅客"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 2
                    color: "transparent"
                    Text {
                        text: "开包员"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16 * 3
                    color: "transparent"
                    Text {
                        text: "安检图片"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
                Rectangle {
                    height: parent.height
                    width: parent.width / 16
                    color: "transparent"
                    Text {
                        text: "操作"
                        font.family: "微软雅黑"
                        font.pixelSize: parent.height / 4
                        anchors.centerIn: parent
                        font.bold: true
                    }
                }
            }
        }
        Con2_1.ScrollView {
            id: bagScroll
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            clip: true
            Column {
                id: column
                spacing: 10
                anchors.fill: parent
                ListModel {
                    id: bagModel
                    ListElement {
                        bagId: 1007
                        date: '2022-12-05'
                        time: '09:19:05'
                        contraband: '刀具,枪支'
                        bagUserName: '张三'
                        auditorName: '李四'
                        blockPath: './images/demo.jpg'
                    }
                    ListElement {
                        bagId: 1006
                        date: '2022-12-05'
                        time: '09:19:05'
                        contraband: '刀具,枪支'
                        bagUserName: '张三'
                        auditorName: '李四'
                        blockPath: './images/demo.jpg'
                    }
                    ListElement {
                        bagId: 1006
                        date: '2022-12-05'
                        time: '09:19:05'
                        contraband: '刀具,枪支'
                        bagUserName: '张三'
                        auditorName: '李四'
                        blockPath: './images/demo.jpg'
                    }
                    ListElement {
                        bagId: 1006
                        date: '2022-12-05'
                        time: '09:19:05'
                        contraband: '刀具,枪支'
                        bagUserName: '张三'
                        auditorName: '李四'
                        blockPath: './images/demo.jpg'
                    }
                }
                Component {
                    id: bagDelegate

                    Rectangle {
                        width: content.width
                        height: content.height / 7 * 2
                        Rectangle {
                            width: content.width
                            height: 1
                            color: "#bfbfbf"
                            anchors.top: bagItem.bottom
                            anchors.left: parent.left
                            z: 1
                        }
                        Row {
                            id: bagItem
//                            anchors.fill: parent
                            width: parent.width
                            height: parent.height - 1
                            spacing: 0
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16
                                color: "transparent"
                                Text {
                                    text: bagId
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 3
                                color: "transparent"
                                Text {
                                    text: date
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 2
                                color: "transparent"
                                Text {
                                    text: time
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 2
                                color: "transparent"
                                Text {
                                    text: contraband
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 2
                                color: "transparent"
                                Text {
                                    text: bagUserName
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 2
                                color: "transparent"
                                Text {
                                    text: auditorName
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 8
                                    anchors.centerIn: parent
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 3
                                color: "transparent"
                                Rectangle {
                                    width: parent.width - 2
                                    height: parent.height * 0.9
                                    border.width: 1
                                    border.color: "#f7f7f7"
                                    anchors.centerIn: parent
                                    //                                    color: "yellow"
                                    Image {
                                        id: image
                                        width: parent.width
                                        height: parent.height
                                        source: blockPath
                                        fillMode: Image.PreserveAspectFit
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                            Rectangle {
                                height: parent.height
                                width: parent.width / 16 * 1
                                color: "transparent"
                                Con2_1.Button {
                                    id: bagDetail
                                    anchors.centerIn: parent
                                    background: Rectangle {
                                        implicitWidth:  parent.width * 0.6
                                        implicitHeight: parent.width * 1.2
//                                        border.width: 1
//                                        border.color: "#BFBFBF"
//                                        color: "#293351"
                                    }
                                    contentItem: Text {
                                        text: "详情"
                                        font.family: "微软雅黑"
                                        color: "#2f5597"
                                        font.pixelSize: parent.width * 1.2 / 2
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: {
//                                        bagStaus = 1;
                                    }
                                }
                            }
                        }
                    }
                }

                ListView {
                    anchors.fill: parent
                    model: bagModel
                    delegate: bagDelegate
                }
            }
        }
    }
}
