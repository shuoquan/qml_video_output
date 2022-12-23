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
    property var typeOptions: [{id: 0, value: '开包图片'}, {id: 1, value: '收藏图片'}, {id: 2, value: '漏开图片'}, {id: 3, value: '误开图片'}]
    property string typeName: '开包图片'
    property var imageList: []
    property string imagePath: "file:///"
    property var bagInfo: ({})
    property var qmlObject: []
    property var params: ({})
    Component.onCompleted: {
        //        imagePath = imagePrefix;
        homeSrc.getAuditorList(0, 100);
        auditorName = params.auditorName;
        console.log(new Date(params.startTime).getDate(), 'time')
        let date = new Date(params.startTime);
        let curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
        let time =  Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
        startTime = new Date(time).getTime();
        leftTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
        date = new Date(params.endTime - 86400000);
        curTime = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`
        time = Date.fromLocaleString(Qt.locale(), curTime, "dd/MM/yyyy")
        endTime = new Date(time).getTime() + 86400000;
        rightTime.text = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`
        console.log(startTime, endTime, 'ddd')
        getStatisticImageList();
    }


    Connections {
        target: homeSrc
        function onSendAuditorList(auditorInfo) {
            auditorList = [{id: 0, username: '所有判图员'}].concat(JSON.parse(auditorInfo || '[]'))
        }
        function onSendStatisticImageList(imageInfo) {
            imageList = JSON.parse(imageInfo || '[]');

//            imageList = [...imageList, ...imageList, ...imageList, ...imageList, ...imageList, ...imageList]
//            return;

            let remainNum = 4 - (imageList.length % 4);
            if (remainNum == 4) return
            while (remainNum > 0) {
                remainNum -= 1;
                imageList = [...imageList, {}];
            }
        }
    }

    function getStatisticImageList() {
        homeSrc.getStatisticImageList(startTime / 1000, endTime / 1000, (auditorList.find(v=>v.username == auditorName) || {}).id || 0, 0, 100, (typeOptions.find(v=>v.value == typeName) || {}).id || 0)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            leftCalendar = false;
            rightCalendar = false;
        }
    }
    Con2_1.Popup {
        id: mainImagePopup
        parent: Con2_1.Overlay.overlay
        x: parent.width * 0.1
        y: parent.height * 0.1
        width: parent.width * 0.8
        height: parent.height * 0.8
        background: Rectangle {
            border.width: 1
            border.color: "#BFBFBF"
        }
        onOpened: {
            homeSrc.modifyOpacity(0.7);
        }
        onClosed: {
            homeSrc.modifyOpacity(1.0);
        }

        Rectangle {
            anchors.fill: parent
            //            color: "#f2f2f2"
            Image {
                id: popImage
                source: bagInfo.path ? imagePath + bagInfo.path : './images/camera.png'
                visible: !!bagInfo.path
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                sourceSize.width: bagInfo.width
                sourceSize.height: bagInfo.height
                sourceClipRect: Qt.rect(bagInfo.x0,bagInfo.y0,bagInfo.x1-bagInfo.x0,bagInfo.y1-bagInfo.y0)
                onStatusChanged:   {
                    const {x0,x1,y0,y1} = bagInfo;
                    const heightRatio = popImage.height / (y1-y0);
                    const widthRatio = popImage.width / (x1-x0);
                    const ratio = Math.min(widthRatio, heightRatio);
                    const unpackBoxList = bagInfo.annotations || [];
                    if(heightRatio <= 0 || widthRatio <= 0) {
                        return;
                    }
                    //                            homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
                    for(const box of unpackBoxList) {
                        //                                                     console.log('box')
                        //                                                     console.log(JSON.stringify(box))
                        // 处理矩形情况
                        if (box.type == 1) {
                            const pointList = [parseInt(box.x0), parseInt(box.y0), parseInt(box.x1), parseInt(box.y1)];
                            const leftTopX = Math.min(pointList[0], pointList[2]);
                            const leftTopY = Math.min(pointList[1], pointList[3]);
                            const rightBottomX = Math.max(pointList[0], pointList[2]);
                            const rightBottomY = Math.max(pointList[1], pointList[3]);
                            // 超出区局部分不显示
                            if (leftTopX<x0 || leftTopY < y0 || rightBottomX > x1 || rightBottomY > y1) {
                                continue;
                            }
                            if (heightRatio < widthRatio) {
                                qmlObject.push(Qt.createQmlObject(`
                                                                  import QtQuick 2.0
                                                                  Rectangle {
                                                                  width: ${rightBottomX - leftTopX} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  height: ${rightBottomY - leftTopY} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  border.color: 'red'
                                                                  border.width: 2
                                                                  anchors.top: parent.top
                                                                  anchors.left: parent.left
                                                                  anchors.leftMargin: ${leftTopX - x0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0)) + (popImage.width - (bagInfo.x1-bagInfo.x0)*Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))) / 2
                                                                  anchors.topMargin: ${leftTopY - y0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  color: 'transparent'
                                                                  }
                                                                  `,
                                                                  parent, `myItem${box.id}`))
                            } else {
                                //                                                             console.log('2x')
                                qmlObject.push(Qt.createQmlObject(`
                                                                  import QtQuick 2.0
                                                                  Rectangle {
                                                                  width: ${rightBottomX - leftTopX} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  height: ${rightBottomY - leftTopY} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  border.color: 'red'
                                                                  border.width: 2
                                                                  anchors.top: parent.top
                                                                  anchors.left: parent.left
                                                                  anchors.leftMargin: ${leftTopX - x0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))
                                                                  anchors.topMargin: ${leftTopY - y0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0)) + (popImage.height - (bagInfo.y1-bagInfo.y0)*Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))) / 2
                                                                  color: 'transparent'
                                                                  }
                                                                  `,
                                                                  parent, `myItem${box.id}`))
                            }
                        } else if(box.type == 2) {
                            const pointList = box.checkPts.map(Number);
                            let dynamicStr = "";
                            for(let i=0; i<pointList.length; i+=2) {
                                const [x, y] = [pointList[i], pointList[i+1]];
                                let param1, param2;
                                //                                                         console.log(heightRatio, ratio, 'xx');
                                if (heightRatio < widthRatio) {
                                    param1 = `${x - x0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0)) + (popImage.width - (bagInfo.x1-bagInfo.x0)*Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))) / 2`;
                                    param2 = `${y - y0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))`;
                                } else {
                                    param1 = `${x - x0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))`;
                                    param2 = `${y - y0} * Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0)) + (popImage.height - (bagInfo.y1-bagInfo.y0)*Math.min(popImage.height / (bagInfo.y1-bagInfo.y0), popImage.width / (bagInfo.x1-bagInfo.x0))) / 2`;
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
                            qmlObject.push(Qt.createQmlObject(createQmlStr, parent, `myItem${box.id}`));
                        }
                    }

                }

            }
            Rectangle {
                height: parent.height / 10
                width: parent.height / 10
                anchors.top: parent.top
                anchors.right: parent.right
                //                color: "green"
                Image {
                    source: './images/close-dark.png'
                    fillMode: Image.PreserveAspectFit
                    height: parent.height
                    anchors.centerIn: parent
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainImagePopup.close();
                        }
                    }
                }
            }
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

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                auditorName = auditorList[index].username
                                auditorPopup.close()
                                getStatisticImageList();
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
            id: typeSelect
            height: parent.height / 2
            width: parent.height * 2
            anchors.left: auditorSelect.right
            anchors.leftMargin: parent.height
            anchors.verticalCenter: parent.verticalCenter
            border.width: 1
            border.color: "#bfbfbf"
            Text {
                text: typeName
                font.pixelSize: parent.height / 3
                //                                            font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin:  0.1 * parent.width
                font.family: "微软雅黑"
            }
            Triangle {
                id: myTriangleTwo
                width: parent.height / 4
                height: parent.height / 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0.1 * parent.width
                states: State {
                    name: "rotated"
                    PropertyChanges {
                        target: myTriangleTwo
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
                    typePopup.open();
                }
            }
        }

        Con2_1.Popup {
            id: typePopup
            width: typeSelect.width
            height: typeSelect.height * Math.min(4, typeOptions.length)
            x: auditorSelect.width + parent.height
            //            x: dateSelect.width + parent.height / 20
            y: parent.height / 4 * 3 + 2
            padding: 0
            background: Rectangle {
                border.width: 1
                border.color: "#BFBFBF"
            }
            onOpened: {
                myTriangleTwo.state = "rotated";
            }
            onClosed: {
                myTriangleTwo.state = "";
            }
            Con2_1.ScrollView {
                //                anchors.fill: parent
                height: parent.height - 2
                width: parent.width - 2
                anchors.centerIn: parent
                clip: true
                ListModel {
                    id: typeModel
                }
                Component {
                    id: typeDelegate
                    Rectangle {
                        width: typeSelect.width - 2
                        anchors.left: parent.left
                        height: typeSelect.height
                        color: typeName == typeOptions[index].value ? "#d9d9d9" : '#fff'
                        Text {
                            text: typeOptions[index].value
                            anchors.left: parent.left
                            anchors.leftMargin:  0.1 * parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            font.family: "微软雅黑"
                            font.pixelSize: parent.height / 3
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                typeName = typeOptions[index].value
                                typePopup.close()
                                getStatisticImageList();
                            }
                        }
                    }
                }

                ListView {
                    anchors.fill: parent
                    model: typeOptions
                    //                    model: imageModel
                    delegate: typeDelegate
                }
            }

        }

        Rectangle {
            id: dateSelect
            anchors.left: typeSelect.right
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
                    getStatisticImageList();
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
                    getStatisticImageList();
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
        id: content
        height: parent.height / 7 * 5.5
        width: parent.width * 0.9
        anchors.left: parent.left
        anchors.leftMargin: 0.05 * parent.width
        anchors.top: header.bottom
        Text {
            anchors.left: parent.left
            text: '暂无图片'
            anchors.centerIn: parent
            font.family: "微软雅黑"
            font.pixelSize: parent.height / 15
            visible: imageList.length == 0
        }
        //        color: "red"
        Con2_1.ScrollView {
            id: imageScroll
            anchors.fill: parent
            Con2_1.ScrollBar.vertical.policy: Con2_1.ScrollBar.AlwaysOff
            //            contentHeight: content.height
            clip: true
            Grid {
                id: grid
                columns: 4
                anchors.left: parent.left
                Repeater {
                    model: imageList
                    delegate: imageDelegate
                }
                Component {
                    id: imageDelegate
                    Rectangle {
                        width: imageScroll.width / 4
                        height: imageScroll.width / 4
                        Rectangle {
                            width: parent.width
                            height: parent.height / 4 * 3
                            anchors.left: parent.left
                            anchors.top: parent.top
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData.path) {
                                        if (bagInfo.path != modelData.path) {
                                            while (qmlObject.length) {
                                                const curQml = qmlObject.pop();
                                                curQml.destroy();
                                            }
                                        }
                                        bagInfo = modelData;
                                        mainImagePopup.open()
                                    }
                                }
                            }

                            Image {
                                id: image
                                source: modelData.path ? imagePath + modelData.path : './images/camera.png'
                                visible: !!modelData.path
                                //                                source: './images/demo.jpg'
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: parent.width
                                height: parent.height
                                sourceSize.width: modelData.width
                                sourceSize.height: modelData.height
                                sourceClipRect: Qt.rect(modelData.x0,modelData.y0,modelData.x1-modelData.x0,modelData.y1-modelData.y0)
                                onStatusChanged:   {
                                    const {x0,x1,y0,y1} = modelData;
                                    const heightRatio = image.height / (y1-y0);
                                    const widthRatio = image.width / (x1-x0);
                                    const ratio = Math.min(widthRatio, heightRatio);
                                    const unpackBoxList = modelData.annotations || [];
                                    if(heightRatio <= 0 || widthRatio <= 0) {
                                        return;
                                    }
                                    //                            homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
                                    for(const box of unpackBoxList) {
                                        //                                                     console.log('box')
                                        //                                                     console.log(JSON.stringify(box))
                                        // 处理矩形情况
                                        if (box.type == 1) {
                                            const pointList = [parseInt(box.x0), parseInt(box.y0), parseInt(box.x1), parseInt(box.y1)];
                                            const leftTopX = Math.min(pointList[0], pointList[2]);
                                            const leftTopY = Math.min(pointList[1], pointList[3]);
                                            const rightBottomX = Math.max(pointList[0], pointList[2]);
                                            const rightBottomY = Math.max(pointList[1], pointList[3]);
                                            // 超出区局部分不显示
                                            if (leftTopX<x0 || leftTopY < y0 || rightBottomX > x1 || rightBottomY > y1) {
                                                continue;
                                            }
                                            if (heightRatio < widthRatio) {
                                                Qt.createQmlObject(`
                                                                   import QtQuick 2.0
                                                                   Rectangle {
                                                                   width: ${rightBottomX - leftTopX} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   height: ${rightBottomY - leftTopY} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   border.color: 'red'
                                                                   border.width: 2
                                                                   anchors.top: parent.top
                                                                   anchors.left: parent.left
                                                                   anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0)) + (image.width - (modelData.x1-modelData.x0)*Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))) / 2
                                                                   anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   color: 'transparent'
                                                                   }
                                                                   `,
                                                                   parent, `myItem${box.id}`);
                                            } else {
                                                //                                                             console.log('2x')
                                                Qt.createQmlObject(`
                                                                   import QtQuick 2.0
                                                                   Rectangle {
                                                                   width: ${rightBottomX - leftTopX} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   height: ${rightBottomY - leftTopY} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   border.color: 'red'
                                                                   border.width: 2
                                                                   anchors.top: parent.top
                                                                   anchors.left: parent.left
                                                                   anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))
                                                                   anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0)) + (image.height - (modelData.y1-modelData.y0)*Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))) / 2
                                                                   color: 'transparent'
                                                                   }
                                                                   `,
                                                                   parent, `myItem${box.id}`);
                                            }
                                        } else if(box.type == 2) {
                                            const pointList = box.checkPts.map(Number);
                                            let dynamicStr = "";
                                            for(let i=0; i<pointList.length; i+=2) {
                                                const [x, y] = [pointList[i], pointList[i+1]];
                                                let param1, param2;
                                                //                                                         console.log(heightRatio, ratio, 'xx');
                                                if (heightRatio < widthRatio) {
                                                    param1 = `${x - x0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0)) + (image.width - (modelData.x1-modelData.x0)*Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))) / 2`;
                                                    param2 = `${y - y0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))`;
                                                } else {
                                                    param1 = `${x - x0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))`;
                                                    param2 = `${y - y0} * Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0)) + (image.height - (modelData.y1-modelData.y0)*Math.min(image.height / (modelData.y1-modelData.y0), image.width / (modelData.x1-modelData.x0))) / 2`;
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
                        Rectangle {
                            width: parent.width
                            height: parent.height / 4 - 1
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 1
                            Text {
                                anchors.left: parent.left
                                text: new Date(parseInt(modelData.time)).getFullYear().toString() +
                                      '-' +
                                      (new Date(parseInt(modelData.time)).getMonth() + 1).toString().padStart(2, '0') +
                                      '-' +
                                      new Date(parseInt(modelData.time)).getDate().toString().padStart(2, '0') +
                                      ',' +
                                      new Date(parseInt(modelData.time)).getHours().toString().padStart(2, '0') +
                                      ':' +
                                      new Date(parseInt(modelData.time)).getMinutes().toString().padStart(2, '0') +
                                      ':' +
                                      new Date(parseInt(modelData.time)).getSeconds().toString().padStart(2, '0')
                                anchors.centerIn: parent
                                font.family: "微软雅黑"
                                font.pixelSize: parent.height / 4
                                visible: !!modelData.path
                            }
                        }
                        Rectangle {
                            width: parent.width
                            height: 1
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            color: "#bfbfbf"
                        }
                    }
                }
            }
        }
    }
}
