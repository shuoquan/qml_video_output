import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQml 2.15

Rectangle {
    property string userPhoneNum: ''
    //    property string userPic: './images/demo.jpg'
    property string userPic: ''
    property var imageList: []
    property var bagInfo: ({})
    property string imagePath: ""
    property int imageIndex: 0
    property var qmlObject: []
    anchors.fill: parent
    color: "green"
    Component.onCompleted: {
        //        imageList = [...imageList, ...imageList, ...imageList]
        //                timer2.start()
        imagePath = imagePrefix;
        timeText.text = `${bagInfo.date} ${bagInfo.time}`;
        contrabandText.text = bagInfo.contraband;
        unpackAuditorText.text = bagInfo.unpack_auditor_name;
        bagUserText.text = bagInfo.bag_user_name;
        popBagUserText.text = bagInfo.bag_user_name || '无';
        userPhoneNum = bagInfo.bag_user_phone;
        userPic = bagInfo.bag_user_pic;
        imageList = [];
        if (bagInfo.block_path) {
            imageList = [...imageList,                         {
                             imageSource: bagInfo.block_path,
                             type: 1
                         }]
        }
        if (bagInfo.video_block_path) {
            imageList = [...imageList,     {
                             imageSource: bagInfo.video_block_path,
                             type: 2
                         }]
        }
        const unpackRecordList = (bagInfo.unpackRecordList || []);
        for (const unpackRecord of unpackRecordList) {
            imageList = [...imageList,                             {
                             imageSource: unpackRecord.contrabandPic,
                             type: 2
                         }]
        }
        //        console.log(JSON.stringify(imageList), 'asf')
    }

    Timer {
        id: timer2
        interval: 3000
        triggeredOnStart: false
        repeat: true
        onTriggered: {
            imageList = [...imageList, './images/demo.jpg']
            //            imageList.push('./images/demo.jpg')
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
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            contentHeight: picArea.height + time.height + contraband.height + auditor.height + bagUser.height * 2
            //            width: parent.width / 10 * 9
            //            height: parent.height / 10 * 9
            //            anchors.centerIn: parent
            clip: true
            Rectangle {
                id: picArea
                anchors.left: parent.left
                width: parent.width
                height: grid.height
                //                color: "Red"
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
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    imageIndex = index;
                                }
                            }

                            Image {
                                id: image
                                source: imagePath + modelData.imageSource
                                //                                source: './images/demo.jpg'
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: parent.width - 2
                                height: parent.height - 2
                                sourceSize.width: bagInfo.block_width
                                sourceSize.height: bagInfo.block_height
                                sourceClipRect: Qt.rect(bagInfo.x0,bagInfo.y0,bagInfo.x1-bagInfo.x0,bagInfo.y1-bagInfo.y0)
                                visible: modelData.type == 1
                                onStatusChanged:   {
                                    if (modelData.type != 1) {
                                        return
                                    }

                                    const {x0,x1,y0,y1,unpackBoxInfoList,box} = bagInfo;
                                    const heightRatio = image.height / (y1-y0);
                                    const widthRatio = image.width / (x1-x0);
                                    const ratio = Math.min(widthRatio, heightRatio);
                                    const unpackBoxList = JSON.parse(unpackBoxInfoList);
                                    if(heightRatio <= 0 || widthRatio <= 0) {
                                        return;
                                    }
                                    //                            homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
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
                                                Qt.createQmlObject(`
                                                                   import QtQuick 2.0
                                                                   Rectangle {
                                                                   width: ${rightBottomX - leftTopX} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   height: ${rightBottomY - leftTopY} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   border.color: 'red'
                                                                   border.width: 2
                                                                   anchors.top: parent.top
                                                                   anchors.left: parent.left
                                                                   anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.width - (bagInfo.x1-bagInfo.x0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2
                                                                   anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   color: 'transparent'
                                                                   }
                                                                   `,
                                                                   parent, `myItem${box.id}`);
                                            } else {
                                                //                                                             console.log('2x')
                                                Qt.createQmlObject(`
                                                                   import QtQuick 2.0
                                                                   Rectangle {
                                                                   width: ${rightBottomX - leftTopX} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   height: ${rightBottomY - leftTopY} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   border.color: 'red'
                                                                   border.width: 2
                                                                   anchors.top: parent.top
                                                                   anchors.left: parent.left
                                                                   anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                                                   anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.height - (bagInfo.y1-bagInfo.y0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2
                                                                   color: 'transparent'
                                                                   }
                                                                   `,
                                                                   parent, `myItem${box.id}`);
                                            }
                                        } else if(box.type == 2) {
                                            const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
                                            let dynamicStr = "";
                                            for(let i=0; i<pointList.length; i+=2) {
                                                const [x, y] = [pointList[i], pointList[i+1]];
                                                let param1, param2;
                                                //                                                         console.log(heightRatio, ratio, 'xx');
                                                if (heightRatio < widthRatio) {
                                                    param1 = `${x - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.width - (bagInfo.x1-bagInfo.x0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2`;
                                                    param2 = `${y - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))`;
                                                } else {
                                                    param1 = `${x - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))`;
                                                    param2 = `${y - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.height - (bagInfo.y1-bagInfo.y0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2`;
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
                            Image {
                                source: imagePath + modelData.imageSource
                                //                                source: './images/demo.jpg'
                                fillMode: Image.PreserveAspectFit
                                height: parent.height / 10 * 9
                                anchors.centerIn: parent
                                visible: modelData.type == 2
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
                        id: timeText
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: ''
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
                        id: contrabandText
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: ""
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
                        id: unpackAuditorText
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: ""
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
                        id: bagUserText
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: ""
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
                                id: popBagUserText
                                anchors.left: userNameLeft.right
                                anchors.leftMargin: 10
                                text: ''
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
                            source: imagePath + userPic
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
            id: image
            source: imagePath + imageList[imageIndex].imageSource
            //                                source: './images/demo.jpg'
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            sourceSize.width: bagInfo.block_width
            sourceSize.height: bagInfo.block_height
            sourceClipRect: Qt.rect(bagInfo.x0,bagInfo.y0,bagInfo.x1-bagInfo.x0,bagInfo.y1-bagInfo.y0)
            visible: !!imageList[imageIndex] && imageList[imageIndex].type == 1
            onStatusChanged:   {
                if (imageList[imageIndex].type != 1) {
                    while (qmlObject.length) {
                        const curQml = qmlObject.pop();
                        curQml.destroy();
                    }

                    return
                }

                const {x0,x1,y0,y1,unpackBoxInfoList,box} = bagInfo;
                const heightRatio = image.height / (y1-y0);
                const widthRatio = image.width / (x1-x0);
                const ratio = Math.min(widthRatio, heightRatio);
                const unpackBoxList = JSON.parse(unpackBoxInfoList);
                if(heightRatio <= 0 || widthRatio <= 0) {
                    return;
                }
                //                            homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
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
                            qmlObject.push(Qt.createQmlObject(`
                                               import QtQuick 2.0
                                               Rectangle {
                                               width: ${rightBottomX - leftTopX} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               height: ${rightBottomY - leftTopY} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               border.color: 'red'
                                               border.width: 2
                                               anchors.top: parent.top
                                               anchors.left: parent.left
                                               anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.width - (bagInfo.x1-bagInfo.x0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2
                                               anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               color: 'transparent'
                                               }
                                               `,
                                               parent, `myItem${box.id}`))
                        } else {
                            //                                                             console.log('2x')
                            qmlObject.push(Qt.createQmlObject(`
                                               import QtQuick 2.0
                                               Rectangle {
                                               width: ${rightBottomX - leftTopX} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               height: ${rightBottomY - leftTopY} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               border.color: 'red'
                                               border.width: 2
                                               anchors.top: parent.top
                                               anchors.left: parent.left
                                               anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))
                                               anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.height - (bagInfo.y1-bagInfo.y0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2
                                               color: 'transparent'
                                               }
                                               `,
                                               parent, `myItem${box.id}`))
                        }
                    } else if(box.type == 2) {
                        const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
                        let dynamicStr = "";
                        for(let i=0; i<pointList.length; i+=2) {
                            const [x, y] = [pointList[i], pointList[i+1]];
                            let param1, param2;
                            //                                                         console.log(heightRatio, ratio, 'xx');
                            if (heightRatio < widthRatio) {
                                param1 = `${x - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.width - (bagInfo.x1-bagInfo.x0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2`;
                                param2 = `${y - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))`;
                            } else {
                                param1 = `${x - x0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))`;
                                param2 = `${y - y0} * Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0)) + (image.height - (bagInfo.y1-bagInfo.y0)*Math.min(image.height / (bagInfo.y1-bagInfo.y0), image.width / (bagInfo.x1-bagInfo.x0))) / 2`;
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
        Image {
            source: imagePath + imageList[imageIndex].imageSource
            //                                source: './images/demo.jpg'
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.centerIn: parent
            visible: !!imageList[imageIndex] && imageList[imageIndex].type == 2
        }
    }
}
