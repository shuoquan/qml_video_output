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
    property string auditorName: '所有判图员'
    property double startTime: 0
    property double endTime: 0
    property var auditorList: [{id: 0, username: '所有判图员'}]
    property string passengerBagCnt: ''
    property string actualUnpackBagCnt: ''
    property string registerContrabandCnt: ''
    property string auditorUnpackBagCnt: ''
    property string detectRecommendCnt: ''
    property string auditorWrongCnt: ''
    property string xmanWrongCnt: ''
    property string unpackRatio: ''
    property string contrabandRatio: ''
    property string auditorCorrectRatio: ''
    property string xmanCorrectRatio: ''
    Component.onCompleted: {
        //        auditorList = [
        //                    {
        //                        id: 0,
        //                        username: '所有判图员'
        //                    },
        //                    {
        //                        id: 1,
        //                        username: 'admin'
        //                    },
        ////                    {
        ////                        id: 2,
        ////                        username: '张三'
        ////                    },
        ////                    {
        ////                        id: 3,
        ////                        username: '李四'
        ////                    },
        ////                    {
        ////                        id: 4,
        ////                        username: '王五'
        ////                    },
        ////                    {
        ////                        id: 5,
        ////                        username: '赵六'
        ////                    }
        //                ]
        homeSrc.getAuditorList(0, 100);
        let date = new Date();
        const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
        const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
        startTime = new Date(time).getTime();
        endTime = startTime + 86400000;
        leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
        rightTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
//        console.log('111')
        getStatisticData();
    }

    function getStatisticData() {
//        console.log(startTime, endTime, '----')
        if (startTime > 0 && endTime > 0) {
            homeSrc.getStatisticData(startTime / 1000, endTime / 1000, (auditorList.find(v=>v.username == auditorName) || {}).id || 0);
        }
    }

    function goToImageList() {
        homeSrc.goToPage(6, JSON.stringify({startTime, endTime, auditorName}));
    }


    Connections {
        target: homeSrc
        function onSendAuditorList(auditorInfo) {
            auditorList = [{id: 0, username: '所有判图员'}].concat(JSON.parse(auditorInfo || '[]'))
        }
        function onSendStatisticData(statisticData) {
//            console.log('----------------');
            const statisticObj = JSON.parse(statisticData || '{}');
            passengerBagCnt = (statisticObj['passengerBagCnt'] || 0).toString();
            actualUnpackBagCnt = (statisticObj['actualUnpackBagCnt'] || 0).toString();
            registerContrabandCnt = (statisticObj['registerContrabandCnt'] || 0).toString();
            auditorUnpackBagCnt = (statisticObj['auditorUnpackBagCnt'] || 0).toString();
            detectRecommendCnt = (statisticObj['detectRecommendCnt'] || 0).toString();
            auditorWrongCnt = (statisticObj['auditorWrongCnt'] || 0).toString();
            xmanWrongCnt = (statisticObj['xmanWrongCnt'] || 0).toString();
            if (passengerBagCnt > 0) {
                unpackRatio = Math.min(100, (actualUnpackBagCnt / passengerBagCnt * 100).toFixed(1)).toString() + '%';
                contrabandRatio = Math.min(100, (registerContrabandCnt / passengerBagCnt * 100).toFixed(1)).toString() + '%';
            } else {
                unpackRatio = '-';
                contrabandRatio = '-';
            }
            if (auditorUnpackBagCnt > 0) {
                auditorCorrectRatio = Math.min(100, (Math.max(0, auditorUnpackBagCnt - auditorWrongCnt) / auditorUnpackBagCnt * 100).toFixed(1)).toString() + '%';
            } else {
                auditorCorrectRatio = '-';
            }
            if (detectRecommendCnt > 0) {
                xmanCorrectRatio = Math.min(100, (Math.max(0, detectRecommendCnt - xmanWrongCnt) / detectRecommendCnt * 100).toFixed(1)).toString() + '%';
            } else {
                xmanCorrectRatio = '-';
            }
        }
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
        height: parent.height / 7
        width: parent.width * 0.9
        anchors.left: parent.left
        anchors.leftMargin: 0.05 * parent.width
        id: header
        //        color: "blue"
        Rectangle {
            id: auditorSelect
            height: parent.height / 2
            width: parent.height * 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Text {
                text: auditorName
                font.pixelSize: parent.height / 3
                //                                            font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin:  0.1 * parent.width
                font.family: "微软雅黑"
            }
            Triangle {
                id: myTriangle
                width: parent.height / 4
                height: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0.1 * parent.width
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
                    auditorPopup.open();
                }
            }
        }
        Con2_1.Popup {
            id: auditorPopup
            width: auditorSelect.width
            height: auditorSelect.height * Math.min(4, auditorList.length)
            x: 0
            //            x: dateSelect.width + parent.height / 20
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
            Con2_1.ScrollView {
                //                anchors.fill: parent
                height: parent.height - 2
                width: parent.width - 2
                anchors.centerIn: parent
                clip: true
                ListModel {
                    id: auditorModel
                }
                Component {
                    id: auditorDelegate
                    Rectangle {
                        width: auditorSelect.width - 2
                        anchors.left: parent.left
                        height: auditorSelect.height
                        color: auditorName == auditorList[index].username ? "#d9d9d9" : '#fff'
                        Text {
                            text: auditorList[index].username
                            anchors.left: parent.left
                            anchors.leftMargin:  0.1 * parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            font.family: "微软雅黑"
                            font.pixelSize: parent.height / 3
                        }
//                        Rectangle {
//                            anchors.left: parent.left
//                            width: parent.width
//                            height: 2
//                            anchors.bottom: parent.bottom
////                            color: "red"
//                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                auditorName = auditorList[index].username
                                auditorPopup.close()
//                                console.log('2222')
                                getStatisticData();
                            }
                        }
                    }
                }

                ListView {
                    anchors.fill: parent
                    model: auditorList
                    //                    model: imageModel
                    delegate: auditorDelegate
                }
            }

        }

        Rectangle {
            id: dateSelect
            anchors.left: auditorSelect.right
            anchors.leftMargin: parent.height
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
                    const date = new Date(selectedDate);
                    const curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
                    leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
                    const time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
                    startTime = new Date(time).getTime();
                    leftCalendar = false;
//                    console.log('333')
                    getStatisticData();
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
                    rightCalendar = false;
//                    console.log('4444')
                    getStatisticData();
                }
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
    }
    Rectangle {
        id: contentOne
        anchors.top: header.bottom
        anchors.left: parent.left
        width: parent.width
        height: parent.height / 7 * 6 / 7 * 3
        color: "#F2F2F2"
        Rectangle {
            id: partOne
            height: parent.height / 3
            width: parent.width * 0.9
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: userBag
                anchors.left: parent.left
                text: "旅客过包数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: userBagNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - userBagNum.width
                text: passengerBagCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: partTwo
            height: parent.height / 3
            width: parent.width * 0.9
            anchors.top: partOne.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: actualBag
                anchors.left: parent.left
                text: "实际开包数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: actualBagNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - actualBagNum.width
                text: actualUnpackBagCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: unpackRatioText
                anchors.left: actualBagNum.right
                anchors.leftMargin: parent.width / 6
                text: "开包比例"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: unpackRatioNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 6 * 5 - unpackRatioNum.width
                text: unpackRatio
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: partThree
            height: parent.height / 3
            width: parent.width * 0.9
            anchors.top: partTwo.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: contrabandRegister
                anchors.left: parent.left
                text: "禁带品登记数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: contrabandRegisterNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - contrabandRegisterNum.width
                text: registerContrabandCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: contrabandRegisterRatio
                anchors.left: contrabandRegisterNum.right
                anchors.leftMargin: parent.width / 6
                text: "禁带品比例"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: contrabandRegisterRatioNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 6 * 5 - contrabandRegisterRatioNum.width
                text: contrabandRatio
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Rectangle {
        id: contentTwo
        anchors.top: contentOne.bottom
        anchors.left: parent.left
        width: parent.width
        height: parent.height / 7 * 6 / 7 * 2
        //        color: "#F2F2F2"
        Rectangle {
            id: partFour
            height: parent.height / 2
            width: parent.width * 0.9
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: auditorBag
                anchors.left: parent.left
                text: "判图员推送开包数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: auditorBagNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - auditorBagNum.width
                text: auditorUnpackBagCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: auditorCorrectRatioText
                anchors.left: auditorBagNum.right
                anchors.leftMargin: parent.width / 6
                text: "判图员准确率"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: auditorCorrectRatioNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 6 * 5 - auditorCorrectRatioNum.width
                text: auditorCorrectRatio
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: partFive
            height: parent.height / 2
            width: parent.width * 0.9
            anchors.top: partFour.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: auditorWrong
                anchors.left: parent.left
                text: "判图员错判数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: auditorWrongNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - auditorWrongNum.width
                text: auditorWrongCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Con2_1.Button {
                id: detailButtonOne
                anchors.left: auditorWrongNum.right
                anchors.leftMargin: parent.width / 6
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.6
                width: parent.height * 1.2
                background: Rectangle {
                    //                            implicitWidth:  parent.width * 0.6
                    //                            implicitHeight:  parent.height * 0.2
                    //                                                color: 'red'
                }
                contentItem: Text {
                    text:  "查看图片"
                    font.family: "微软雅黑"
                    color: "#2E75B6"
                    font.pixelSize: parent.height / 3
                    //                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                onClicked: {
                    goToImageList();
                }
            }
        }
    }
    Rectangle {
        id: contentThree
        anchors.top: contentTwo.bottom
        anchors.left: parent.left
        width: parent.width
        height: parent.height / 7 * 6 / 7 * 2
        color: "#F2F2F2"
        Rectangle {
            id: partSix
            height: parent.height / 2
            width: parent.width * 0.9
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: recommendBag
                anchors.left: parent.left
                text: "智能识别推荐数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: recommendBagNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - recommendBagNum.width
                text: detectRecommendCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: detectCorrectRatio
                anchors.left: recommendBagNum.right
                anchors.leftMargin: parent.width / 6
                text: "智能识别准确率"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: detectCorrectRatioNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 6 * 5 - detectCorrectRatioNum.width
                text: xmanCorrectRatio
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: partSeven
            height: parent.height / 2
            width: parent.width * 0.9
            anchors.top: partSix.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.05
            color: "transparent"
            Text {
                id: detectWrong
                anchors.left: parent.left
                text: "智能识别错判数"
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: detectWrongNum
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 3 - detectWrongNum.width
                text: xmanWrongCnt
                font.family: "微软雅黑"
                font.pixelSize: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
            }
            Con2_1.Button {
                id: detailButtonTwo
                anchors.left: detectWrongNum.right
                anchors.leftMargin: parent.width / 6
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.6
                width: parent.height * 1.2
                background: Rectangle {
                    //                            implicitWidth:  parent.width * 0.6
                    //                            implicitHeight:  parent.height * 0.2
                    color: 'transparent'
                }
                contentItem: Text {
                    text:  "查看图片"
                    font.family: "微软雅黑"
                    color: "#2E75B6"
                    font.pixelSize: parent.height / 3
                    //                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                onClicked: {
                    goToImageList();
                }
            }
        }
    }
}
