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
    property string imagePath: ""
    signal compTest(string msg)
    Component.onCompleted: {
        imagePath = imagePrefix;
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
                        name: '未知',
                    },
                    {
                        id: 14,
                        name: '其他',
                    }
                ];
        let date = new Date();
        const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
        const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
        startTime = new Date(time).getTime();
        endTime = startTime + 86400000;
        leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
        //        date = new Date(date.getTime() + 86400000)
        rightTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
        timer.start()
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            leftCalendar = false;
            rightCalendar = false;
//            console.log('signal test');
//            compTest("112233");
        }
    }
    Timer {
        id: timer
        interval: 1000
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            getBagList()
        }
    }

    Connections {
        target: homeSrc
        function onSendBagInfo(bagListStr, pageState) {
//            console.log('-------------------', bagListStr)
            if (pageState != 3) {
                return;
            }
            const bagList = JSON.parse(bagListStr || "[]");
            if (bagModel.count > 0) {
                bagModel.remove(0, bagModel.count);
            }

            for(const bagInfo of bagList) {
//                console.log('aaa', JSON.stringify(bagInfo))
                const date = new Date(bagInfo.block_create_at);
                //                const time = date.getFullYear().toString() +
                //                           '-' +
                //                           (date.getMonth() + 1).toString().padStart(2, '0') +
                //                           '-' +
                //                           date.getDate().toString().padStart(2, '0') +
                //                           ',' +
                //                           date.getHours().toString().padStart(2, '0') +
                //                           ':' +
                //                           date.getMinutes().toString().padStart(2, '0') +
                //                           ':' +
                //                           date.getSeconds().toString().padStart(2, '0');
                //                bagInfo.block_create_at = time;
                bagInfo.date = date.getFullYear().toString() +
                        '-' +
                        (date.getMonth() + 1).toString().padStart(2, '0') +
                        '-' +
                        date.getDate().toString().padStart(2, '0');
                bagInfo.time =  date.getHours().toString().padStart(2, '0') +
                        ':' +
                        date.getMinutes().toString().padStart(2, '0') +
                        ':' +
                        date.getSeconds().toString().padStart(2, '0');
//                bagInfo.contraband = (bagInfo.unpackBoxInfoList || []).map(v=>v.categoryName).filter(v=>v!=="").join(',');
                bagInfo.contraband = (bagInfo.unpackRecordList || []).map(v=>v.categoryName).filter(v=>v!=="").join(',');
                bagInfo.bagNum = 1001 + bagInfo.id - bagInfo.minIndex;

                const bagCoordinateList = bagInfo.bag_coordinate.replace(/\(|\)/g, '').split(',').map(Number);
                bagInfo.x0 = Math.min(bagCoordinateList[0], bagCoordinateList[2]);
                bagInfo.x1 = Math.max(bagCoordinateList[0], bagCoordinateList[2]);
                bagInfo.y0 = Math.min(bagCoordinateList[1], bagCoordinateList[3]);
                bagInfo.y1 = Math.max(bagCoordinateList[1], bagCoordinateList[3]);
                bagInfo.unpackBoxInfoList = JSON.stringify(bagInfo.unpackBoxInfoList || []);
                bagModel.append(bagInfo);
            }
        }
    }

    function getBagList() {
        console.log(startTime, endTime, categoryName, userText.text, auditorName.text)
        if (startTime > 0 && endTime > 0) {
            homeSrc.getBagList(startTime / 1000, endTime / 1000, categoryName == "类别" ? "" : categoryName, userText.text, auditorName.text);
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
//            visible: false
            Text {
                id: leftTime
                text: ""
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
                id: leftCalendarComp
                anchors.top: dateSelect.bottom
                anchors.left: leftTime.left
                anchors.topMargin: 1
                visible: leftCalendar
                onSelectedDateChanged: {
                    //                    console.log(new Date(new Date(new Date(selectedDate).getTime()).toLocaleDateString()))
                    //                    startTime = new Date(new Date(new Date(selectedDate).getTime()).toLocaleDateString()).getTime()
                    //                    console.log(new Date(new Date(new Date(Qt.formatDateTime(selectedDate, "yyyy-MM-dd hh:mm:ss")).getTime()).toLocaleDateString()))
                    const date = new Date(selectedDate);
                    const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
                    leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
                    const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
                    startTime = new Date(time).getTime();
                    //                    console.log(new Date(time).getTime(), 'xx')
                    getBagList()
                    leftCalendar = false;
                }
                //                Component.onCompleted: {
                //                    console.log(leftCalendarComp.__selectNextDay())
                //                }
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
                text: ""
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
                id: rightCalendarComp
                anchors.top: dateSelect.bottom
                anchors.left: rightTime.left
                anchors.topMargin: 1
                visible: rightCalendar
                //                z: 3
                onSelectedDateChanged: {
                    const date = new Date(selectedDate);
                    const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
                    rightTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
                    const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
                    endTime = new Date(time).getTime() + 86400000;
                    getBagList();
                    rightCalendar = false;
//                    console.log('---change---')
                }

                //                Component.onCompleted: {
                //                    rightCalendarComp.__selectNextDay()
                //                }
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
//            visible: false
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
                getBagList()
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
                                categoryPopup.close()
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
                Keys.onReleased: {
                    if (event.key === Qt.Key_Return) {
                        getBagList();
                    }
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
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        getBagList();
                    }
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
                Keys.onReleased: {
                    if (event.key === Qt.Key_Return) {
                        getBagList();
                    }
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
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        getBagList();
                    }
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
                console.log('重置')
                categoryName = '类别';
                let date = new Date();
                const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
                const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
                startTime = new Date(time).getTime();
                endTime = startTime + 86400000;
                leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
                //                date = new Date(date.getTime() + 86400000)
                rightTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
                userText.text = '';
                auditorName.text = '';
                leftCalendarComp.selectedDate = new Date();
                rightCalendarComp.selectedDate = new Date();
                //                leftCalendarComp.__select
                //                homeSrc.goToPage(100);
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
                    //                    ListElement {
                    //                        bagId: 1007
                    //                        date: '2022-12-05'
                    //                        time: '09:19:05'
                    //                        contraband: '刀具,枪支'
                    //                        bagUserName: '张三'
                    //                        auditorName: '李四'
                    //                        blockPath: './images/demo.jpg'
                    //                    }
                    //                    ListElement {
                    //                        bagId: 1006
                    //                        date: '2022-12-05'
                    //                        time: '09:19:05'
                    //                        contraband: '刀具,枪支'
                    //                        bagUserName: '张三'
                    //                        auditorName: '李四'
                    //                        blockPath: './images/demo.jpg'
                    //                    }
                    //                    ListElement {
                    //                        bagId: 1006
                    //                        date: '2022-12-05'
                    //                        time: '09:19:05'
                    //                        contraband: '刀具,枪支'
                    //                        bagUserName: '张三'
                    //                        auditorName: '李四'
                    //                        blockPath: './images/demo.jpg'
                    //                    }
                    //                    ListElement {
                    //                        bagId: 1006
                    //                        date: '2022-12-05'
                    //                        time: '09:19:05'
                    //                        contraband: '刀具,枪支'
                    //                        bagUserName: '张三'
                    //                        auditorName: '李四'
                    //                        blockPath: './images/demo.jpg'
                    //                    }
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
                                    text: bagNum
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
                                    text: bag_user_name
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
                                    text: unpack_auditor_name
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
                                        sourceSize.width: block_width
                                        sourceSize.height: block_height
                                        sourceClipRect: Qt.rect(x0,y0,x1-x0,y1-y0)                                                                            //                                         source: "file:///" + block_path
                                        source: imagePath + block_path
                                        fillMode: Image.PreserveAspectFit
                                        anchors.centerIn: parent
                                        onStatusChanged:   {
                                            const heightRatio = image.height / (y1-y0);
                                            const widthRatio = image.width / (x1-x0);
                                            const ratio = Math.min(widthRatio, heightRatio);
                                            const unpackBoxList = JSON.parse(unpackBoxInfoList);
                                            homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
                                            for(const box of unpackBoxList) {
                                                //                                                     console.log('box')
                                                //                                                     console.log(JSON.stringify(box))
                                                // 处理矩形情况
                                                if (box.type == 1) {
                                                    const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
                                                    const leftTopX = Math.min(pointList[0], pointList[2]);
                                                    const leftTopY = Math.min(pointList[1], pointList[3]);
                                                    const rightBottomX = Math.max(pointList[0], pointList[2]);
                                                    const rightBottomY = Math.max(pointList[1], pointList[3]);
                                                    // 超出区局部分不显示
                                                    if (leftTopX<x0 || leftTopY < y0 || rightBottomX > x1 || rightBottomY > y1) {
                                                        continue;
                                                    }

                                                    if (heightRatio < widthRatio) {
                                                        //                                                             console.log('1x')
                                                        //                                                 Qt.createQmlObject(`
                                                        //                                                 import QtQuick 2.0
                                                        //                                                 Rectangle {
                                                        //                                                    width: ${width}
                                                        //                                                    height: ${height}
                                                        //                                                    border.color: 'red'
                                                        //                                                    border.width: 2
                                                        //                                                    anchors.top: parent.top
                                                        //                                                    anchors.left: parent.left
                                                        //                                                    anchors.leftMargin: ${160 * ratio + (image.width - (x1-x0)*ratio) / 2}
                                                        //                                                    anchors.topMargin: ${60 * ratio}
                                                        //                                                    color: 'transparent'
                                                        //                                                 }
                                                        //                                                 `,
                                                        //                                                 parent, "myItem")
                                                        Qt.createQmlObject(`
                                                                           import QtQuick 2.0
                                                                           Rectangle {
                                                                           width: ${rightBottomX - leftTopX} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           height: ${rightBottomY - leftTopY} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           border.color: 'red'
                                                                           border.width: 2
                                                                           anchors.top: parent.top
                                                                           anchors.left: parent.left
                                                                           anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.width - (x1-x0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2
                                                                           anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           color: 'transparent'
                                                                           }
                                                                           `,
                                                                           parent, `myItem${box.id}`)
                                                    } else {
                                                        //                                                             console.log('2x')
                                                        Qt.createQmlObject(`
                                                                           import QtQuick 2.0
                                                                           Rectangle {
                                                                           width: ${rightBottomX - leftTopX} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           height: ${rightBottomY - leftTopY} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           border.color: 'red'
                                                                           border.width: 2
                                                                           anchors.top: parent.top
                                                                           anchors.left: parent.left
                                                                           anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                                                           anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.height - (y1-y0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2
                                                                           color: 'transparent'
                                                                           }
                                                                           `,
                                                                           parent, `myItem${box.id}`)
                                                    }
                                                } else if(box.type == 2) {
                                                    const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
                                                    let dynamicStr = "";
                                                    for(let i=0; i<pointList.length; i+=2) {
                                                        const [x, y] = [pointList[i], pointList[i+1]];
                                                        let param1, param2;
                                                        //                                                         console.log(heightRatio, ratio, 'xx');
                                                        if (heightRatio < widthRatio) {
                                                            param1 = `${x - x0} * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.width - (x1-x0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2`;
                                                            param2 = `${y - y0} * Math.min(image.height / (y1-y0), image.width / (x1-x0))`;
                                                        } else {
                                                            param1 = `${x - x0} * Math.min(image.height / (y1-y0), image.width / (x1-x0))`;
                                                            param2 = `${y - y0} * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.height - (y1-y0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2`;
                                                        }
                                                        if (i==0) {
                                                            dynamicStr += `ctx.moveTo(${param1}, ${param2});`
                                                        } else {
                                                            dynamicStr += `ctx.lineTo(${param1}, ${param2});`
                                                        }

                                                    }
                                                    //                                                     console.log(dynamicStr)
                                                    //                                                     dynamicStr = `ctx.moveTo(234 * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.width - (x1-x0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2, 330 * Math.min(image.height / (y1-y0), image.width / (x1-x0))); ctx.lineTo(image.width, image.height);`
                                                    //                                                     console.log(dynamicStr)
                                                    const createQmlStr = `
                                                    import QtQuick 2.0
                                                    Canvas {
                                                    id: canvas
                                                    anchors.fill: parent
                                                    onPaint: {
                                                    const ctx =  getContext('2d');
                                                    ctx.beginPath();
                                                    ctx.strokeStyle = "#FF0000";
                                                    ctx.lineWidth = 2;
                                                    ${dynamicStr}
                                                    ctx.stroke();
                                                    }
                                                    }
                                                    `;
                                                    Qt.createQmlObject(createQmlStr, parent, `myItem${box.id}`);
                                                }
                                            }

                                        }
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
                                        homeSrc.goToPage(4, JSON.stringify(bagModel.get(index)));
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
