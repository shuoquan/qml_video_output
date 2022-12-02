import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import './'

Rectangle {
    anchors.fill: parent
    signal modifyOpacity(double opacity)
    property bool hasUserPic: false
    property bool userCamera: false
    property string cameraPreview: ''
    // 包状态 0 - 默认 1 - 放行 2 - 登记
    property int bagStaus: 0
    property int categoryIndex: -1
    property var categoryList: []
    Component.onCompleted: {
        //        camera.stop();
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
        console.log(JSON.stringify(categoryList))
//        timer.start()
    }
    Timer {
        id: timer
        interval: 5000
        triggeredOnStart: false
        onTriggered: {
            categoryList = categoryList.slice(1);
        }
    }

    Popup {
        id: mainImagePopup
        parent: Overlay.overlay
        //        x: 0
        //        y: 0
        //        width: Screen.width
        //        height: Screen.height
        //        opacity: 0.5
        x: parent.width * 0.1
        y: parent.height * 0.1
        width: parent.width * 0.8
        height: parent.height * 0.8
        background: Rectangle {
            //            color: "#f2f2f2"
            opacity: 0.6
            //            color: "transparent"
            //            border.color: "transparent"
            border.width: 1
            border.color: "#BFBFBF"
        }

        //        dim: true
        onOpened: {
            modifyOpacity(0.5);
        }
        onClosed: {
            modifyOpacity(1.0);
        }

        Rectangle {
            anchors.fill: parent
            //            color: "#f2f2f2"
            Image {
                source: './images/demo.jpg'
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
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
                            console.log('close')
                            mainImagePopup.close();
                        }
                    }
                }
            }
        }

        //        Rectangle {
        //            width: parent.width * 0.8
        //            height: parent.height * 0.8
        //            anchors.centerIn: parent
        //            color: "#fff"
        //            opacity: 1
        //            z: 1
        //        }
    }

    Popup {
        id: userPopup
        parent: Overlay.overlay
        x: parent.width * 0.1
        y: parent.height * 0.1
        width: parent.width * 0.8
        height: parent.height * 0.8
        background: Rectangle {
            opacity: 0.6
            border.width: 1
            border.color: "#BFBFBF"
        }

        onOpened: {
            modifyOpacity(0.5);
            userCamera = true;
        }
        onClosed: {
            modifyOpacity(1.0);
            userCamera = false;
        }

        Rectangle {
            anchors.fill: parent
            //            color: "#f2f2f2"
            //            Image {
            //                source: './images/demo.jpg'
            //                fillMode: Image.PreserveAspectFit
            //                anchors.centerIn: parent
            //                width: parent.width
            //                height: parent.height
            //            }


            VideoOutput {
                id: viewfinder;
                source: camera;//视频输出源
                focus : visible;
                anchors.fill: parent;
                autoOrientation: true;
                visible: !hasUserPic && userCamera
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('click 111')
                        if (camera.cameraStatus == Camera.LoadedStatus) {
                            camera.start();
                        } else if(camera.cameraStatus == Camera.ActiveStatus) {
                            //                            camera.stop();
                            //                            while(true) {
                            //                                if
                            //                            }

                            camera.imageCapture.captureToLocation('H:/capture.jpg');
                            camera.stop();
                        }

                        //                        camera.searchAndLock()

                        //                        const filepath = 'H:/capture.jpg';
                        //                        camera.imageCapture.captureToLocation(filepath)
                        //                        //                        photoPreview.imagePath = filepath+".jpg";
                        //                        console.log('click 222')
                        console.log(camera.cameraStatus)
                        console.log(Camera.ActiveStatus, Camera.StartingStatus, Camera.StoppingStatus, Camera.StandbyStatus, Camera.LoadedStatus, Camera.LoadingStatus, Camera.UnloadingStatus, Camera.UnloadedStatus, Camera.UnavailableStatus)
                    }
                }
            }
            Camera {
                id: camera
                imageCapture {
                    onImageCaptured: {
                        //                        console.log('capture Camera')
                        //                        okPic.source = preview;
                        console.log(preview, 'xx');
                        cameraPreview = preview;
                        //                        camera.stop();
                        //                        if (camera.cameraStatus == Camera.LoadedStatus) {
                        ////                            console.log('start')
                        ////                            camera.start();
                        //                        } else if(camera.cameraStatus == Camera.ActiveStatus) {
                        //                            console.log('stop')
                        //                            camera.stop();
                        //                        }
                    }
                }
                onLockStatusChanged: {
                    console.log(lockStatus, 'df')
                }
            }

            Rectangle {
                visible: hasUserPic
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
                            console.log('close')
                            mainImagePopup.close();
                        }
                    }
                }
            }
            Rectangle {
                visible: !hasUserPic
                height: parent.height / 12
                width: parent.height / 12
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: parent.height / 24
                anchors.leftMargin: parent.width / 3
                color: "transparent"
                Image {
                    source: './images/close-dark.png'
                    fillMode: Image.PreserveAspectFit
                    height: parent.height
                    anchors.centerIn: parent
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            userPopup.close();
                        }
                    }
                }
            }

            Rectangle {
                visible: !hasUserPic
                height: parent.height / 12
                width: parent.height / 12
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: parent.height / 24
                anchors.leftMargin: parent.width / 3 * 2
                color: "transparent"
                //                color: "green"
                Image {
                    id: okPic
                    source: './images/ok.png'
                    fillMode: Image.PreserveAspectFit
                    height: parent.height
                    anchors.centerIn: parent
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (cameraPreview) {
                                cameraPng.source = cameraPreview;
                                console.log('okokok')
                            }
                            userPopup.close();
                        }
                    }
                }
            }
        }

    }

    Rectangle {
        id: leftArea
        width: parent.width / 4 * 3 - 10
        height: parent.height
        //        color: "#f2f2f2"
        Rectangle {
            id: innerArea
            anchors.fill: parent
            anchors.topMargin: 30
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 30
            //            color: "green"
            Rectangle {
                id: header
                width: parent.width
                height: parent.height / 10
                Rectangle {
                    id: bagNum
                    anchors.left: parent.left
                    width: parent.height - 5
                    height: parent.height - 5
                    radius: 10
                    color: "#EC9A0F"
                    Text {
                        text: "1006"
                        anchors.centerIn: parent
                        font.family: "微软雅黑"
                        font.pixelSize: bagNum.width / 4
                        color: "#fff"
                    }
                }
                Text {
                    text: "2022-11-03,09:19:05"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: bagNum.right
                    anchors.leftMargin: bagNum.width / 2
                    font.family: "微软雅黑"
                    font.pixelSize: bagNum.width / 4
                }
            }
            Rectangle {
                //                color: "red"
                width: parent.width
                height: parent.height / 10 * 9 - 20
                anchors.top: header.bottom
                anchors.topMargin: 20
                Rectangle {
                    id: imageArea
                    height: parent.height * 0.8 + 4
                    width: parent.width * 0.45 + 4
                    anchors.top: parent.top
                    //                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    //                    color: "yellow"
                    border.width: 2
                    border.color: "#BFBFBF"
                    Image {
                        source: './images/demo.jpg'
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        width: imageArea.width - 4
                        height: imageArea.height - 4
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("点击图片");
                            mainImagePopup.open();
                        }
                    }
                }

                Rectangle {
                    id: operationArea
                    height: parent.height
                    width: parent.width - imageArea.width - 20
                    anchors.top: parent.top
                    //                    anchors.verticalCenter: parent.verticalCenter
                    //                    color: "blue"
                    anchors.left: imageArea.right
                    anchors.leftMargin: 20
                    Rectangle {
                        id: buttonArea
                        height: parent.height / 8
                        //                        color: "red"
                        width: parent.width
                        Button {
                            id: registerButton
                            anchors.left: parent.left
                            anchors.leftMargin: 0.1 * parent.width
                            anchors.top: parent.top
                            background: Rectangle {
                                implicitWidth:  buttonArea.width * 0.3
                                implicitHeight: buttonArea.height * 0.8
                                border.width: 1
                                border.color: "#BFBFBF"
                                color: bagStaus == 1 ? '#7f7f7f' : "#fff"
                            }
                            contentItem: Text {
                                text: "禁带品登记"
                                font.family: "微软雅黑"
                                color: bagStaus == 1 ? '#fff' : '#000'
                                font.pixelSize: buttonArea.height / 4
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                bagStaus = 1;
                            }
                        }
                        Button {
                            id: passButton
                            anchors.right: parent.right
                            anchors.rightMargin: 0.1 * parent.width
                            anchors.top: parent.top
                            background: Rectangle {
                                implicitWidth:  buttonArea.width * 0.3
                                implicitHeight: buttonArea.height * 0.8
                                border.width: 1
                                border.color: "#BFBFBF"
                                color: bagStaus == 2 ? '#7f7f7f' : "#fff"
                            }
                            contentItem: Text {
                                text: "放行"
                                font.family: "微软雅黑"
                                color: bagStaus == 2 ? '#fff' : '#000'
                                font.pixelSize: buttonArea.height / 4
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                bagStaus = 2;
                            }
                        }
                    }

                    ScrollView {
                        id: scroll
                        anchors.left: parent.left
                        anchors.top: buttonArea.bottom
                        width: parent.width * 0.8
                        height: operationArea.height / 5 * Math.max(0, Math.min(categoryModel.count, 3))
                        anchors.leftMargin: parent.width * 0.1
                        clip: true
                        //                        maxi
                        Rectangle {
                            id: scrollRect
                            anchors.fill: parent
                            //                            color: "red"
                            ListModel {
                                id: categoryModel
                                ListElement {
                                    categoryName: "类别"
                                    imageSource: ''
                                    selectActive: false
                                }
                                //                                ListElement {
                                //                                    categoryName: '类别'
                                //                                    imageSource: ''
                                //                                    selectActive: false
                                //                                }
                                //                                ListElement {

                                //                                }
                                //                                ListElement {

                                //                                }
                            }
                            Component {
                                id: categoryDelegate
                                Rectangle {
                                    id: item
                                    width: operationArea.width
                                    height: operationArea.height / 5
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    //                                    anchors.fill: parent
                                    Rectangle {
                                        id: itemNum
                                        width: parent.height / 2.5
                                        height: parent.height / 2.5
                                        color: "#f2f2f2"
                                        anchors.left: parent.left
                                        Text {
                                            text: index + 1
                                            anchors.centerIn: parent
                                            font.family: "微软雅黑"
                                            font.pixelSize: parent.width / 2
                                            //                                font.bold: true
                                        }
                                    }
                                    Rectangle {
                                        id: selectArea
                                        width: parent.width / 3 * 1.0
                                        height: parent.height / 2.5
                                        color: "#f2f2f2"
                                        anchors.left: itemNum.right
                                        anchors.leftMargin: parent.width / 3 * 0.2
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
                                            width: parent.height / 4
                                            height: parent.height / 4
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.right: parent.right
                                            anchors.rightMargin: 0.2 * parent.width
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (categoryIndex >= 0) {
                                                    const categoryInfo = categoryModel.get(categoryIndex);
                                                    categoryInfo.selectActive = false;
                                                    categoryModel.set(categoryIndex, categoryInfo);
                                                }
                                                categoryIndex = index;
                                                //                                                console.log('11', selectArea.position, selectActive, index)
                                                //                                                console.log(selectArea.x, selectArea.y)
                                                categoryPopup.open();
                                                selectActive = true;
                                                //                                                console.log(JSON.stringify(categoryModel.get(index)))
                                                //                                                console.log(selectArea.width, selectArea.height, 'xx')
                                                //                                                const component = Qt.createComponent('./CategoryItem.qml');
                                                //                                                console.log('abcd', component.status, Component.Error)
                                                //                                                if (component.status === Component.Ready) {
                                                //                                                    console.log(item.width, operationArea.height)
                                                //    //                                                {'width': selectArea.width, 'height': selectArea.height}
                                                //                                                    const object = component.createObject(grid, {'width': selectArea.width, 'height': selectArea.height, 'categoryName': 'aaa'})
                                                //                                                    console.log('ready')
                                                //                                                }
                                                //                                            }
                                            }
                                        }
                                    }
                                    Popup {
                                        id: categoryPopup
                                        //                                        parent: Overlay.overlay
                                        //                                        anchors.left: selectArea.right
                                        width: selectArea.width * 2 + 2
                                        height: selectArea.height * 7 + 12
                                        //                                        color: "#d9d9d9"
                                        //                                        anchors.top: parent.top
                                        //                                        visible: selectActive
                                        x: parent.width / 3 * 0.2 + itemNum.width + selectArea.width + 2
                                        y: 0
                                        padding: 0
                                        background: Rectangle {
                                            border.width: 1
                                            border.color: "#BFBFBF"
                                        }
                                        visible: false

                                        //                                        Rectangle {
                                        //                                            anchors.fill: parent
                                        //                                            anchors.left: parent.leftInset
                                        //                                            anchors.right: parent.right
                                        //                                            anchors.top: parent.top
                                        //                                            anchors.bottom: parent.bottom
                                        //                                            color: "red"
                                        //                                        }

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
                                                    width: selectArea.width
                                                    height: selectArea.height
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

                                            //                                            spacing: 2
                                            //                                            Rectangle {
                                            //                                                color: "red"
                                            //                                                width: selectArea.width
                                            //                                                height: selectArea.height
                                            //                                            }
                                            //                                            Rectangle {
                                            //                                                color: "yellow"
                                            //                                                width: selectArea.width
                                            //                                                height: selectArea.height
                                            //                                            }
                                            //                                            Rectangle {
                                            //                                                color: "green"
                                            //                                                width: selectArea.width
                                            //                                                height: selectArea.height
                                            //                                            }
                                            //                                            Rectangle {
                                            //                                                color: "blue"
                                            //                                                width: selectArea.width
                                            //                                                height: selectArea.height
                                            //                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: itemCamera
                                        width: parent.width / 3 * 1.0
                                        height: parent.height / 1.1
                                        color: "#f2f2f2"
                                        anchors.left: selectArea.right
                                        anchors.leftMargin: parent.width / 3 * 0.2
                                        Image {
                                            source: imageSource ? imageSource : './images/camera.png'
                                            fillMode: Image.PreserveAspectFit
                                            height: parent.height / 2
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        id: itembin
                                        width: parent.height / 2.5
                                        height: parent.height / 2.5
                                        //                                        anchors.right: item.right
                                        //                                        color: "yellow"
                                        //                                        z: 2
                                        anchors.right: item.right
                                        //                                        anchors.leftMargin: parent.width / 20
                                        Image {
                                            source: './images/bin.png'
                                            fillMode: Image.PreserveAspectFit
                                            height: parent.height / 2
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                categoryModel.remove(index);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        ListView {
                            anchors.fill: parent
                            model: categoryModel
                            delegate: categoryDelegate
                            onCountChanged: {
                                if (categoryModel.count > 3) {
                                    positionViewAtEnd();
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: addCategory
                        width: operationArea.height / 5 / 2.5
                        height: operationArea.height / 5 / 2.5
                        anchors.left: parent.left
                        anchors.top: scroll.bottom
                        anchors.topMargin: 10
                        anchors.leftMargin: 0.1 * parent.width
                        color: "#f2f2f2"
                        Text {
                            text: "+"
                            font.pixelSize: parent.width / 2
                            font.bold: true
                            anchors.centerIn: parent
                            font.family: "微软雅黑"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                categoryModel.append({
                                                         categoryName: "类别",
                                                         imageSource: '',
                                                         selectActive: false,
                                                     })
                            }
                        }
                    }
                }
            }
        }
        //            Rectangle {
        //                id: footer
        //                height: parent.height / 10 * 2
        //                width: parent.width
        //                //                color: "yellow"
        //                anchors.bottom: parent.bottom
        //                Button {
        //                    id: botomButton
        //                    text: "放行"
        //                    font.bold: true
        //                    font.family: "微软雅黑"
        //                    font.pixelSize: footer.height / 3 * 1.2 / 2.5
        //                    anchors.verticalCenter: parent.verticalCenter
        //                    background: Rectangle {
        //                        implicitWidth: footer.height
        //                        implicitHeight: footer.height / 3 * 1.2
        //                        radius: 2
        //                        color: "#fff"
        //                        border.width: 1
        //                        border.color: "#203864"
        //                    }
        //                    contentItem: Text {
        //                        text: botomButton.text
        //                        font.pixelSize: botomButton.font.pixelSize
        //                        color: "#203864"
        //                        horizontalAlignment: Text.AlignHCenter
        //                        verticalAlignment: Text.AlignVCenter
        //                    }
        //                }
        //            }
    }
    Rectangle {
        height: parent.height
        width: 10
        color: "#f2f2f2"
        anchors.left: leftArea.right
    }
    Rectangle {
        id: identifyInfo
        width: parent.width / 4
        height: parent.height
        //        color: "yellow"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Rectangle {
            id: title
            width: parent.width
            height: parent.height / 8
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            Text {
                //                anchors.fill: parent
                text: '个人信息登记'
                color: "#000"
                font.bold: false
                font.weight: Font.Light
                //                font.weight: 20
                font.family: "微软雅黑"
                font.pixelSize: parent.width / 20
                anchors.centerIn: parent
            }
        }
        Rectangle {
            anchors.top: title.bottom
            width: 0.8 * parent.width
            height: 1
            color: '#BFBFBF'
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            id: textArea
            width: parent.width
            height: parent.height / 8 * 3 - 1
            anchors.bottom: cameraArea.top
            //            color: "blue"
            Rectangle {
                id: nameArea
                anchors.top: parent.top
                width: parent.width
                height: 0.5 * parent.height
                //                color: "gray"
                Text {
                    id: name
                    text: "姓名"
                    color: "#000"
                    font.family: "微软雅黑"
                    font.pixelSize: parent.width / 24
                    //                    anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 3 * 2 - name.height / 2
                    anchors.left: parent.left
                    anchors.leftMargin: 0.1 * parent.width
                }
                Rectangle {
                    id: nameInput
                    //                    anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 3 * 2 - nameInput.height / 2
                    width: parent.width * 0.8 - phone.width - 25
                    height: parent.height / 3
                    anchors.right: parent.right
                    anchors.rightMargin: 0.1 * parent.width
                    color: "#f2f2f2"
                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 6
                        font.pointSize: parent.height / 3
                        focus: true
                        verticalAlignment: TextInput.AlignVCenter
                    }
                }
            }
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 0.5 * parent.height
                //                color: "red"
                Text {
                    id: phone
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 3 - phone.height / 2
                    text: "电话"
                    color: "#000"
                    font.family: "微软雅黑"
                    font.pixelSize: parent.width / 24
                    //                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0.1 * parent.width
                }
                Rectangle {
                    //                    anchors.verticalCenter: parent.verticalCenter
                    id: phoneInput
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 3 - phoneInput.height / 2
                    width: parent.width * 0.8 - phone.width - 25
                    height: parent.height / 3
                    anchors.right: parent.right
                    anchors.rightMargin: 0.1 * parent.width
                    color: "#f2f2f2"
                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 6
                        font.pointSize: parent.height / 3
                        focus: true
                        verticalAlignment: TextInput.AlignVCenter
                    }
                }
            }
        }
        Rectangle {
            id: cameraArea
            width: parent.width
            height: parent.height * 0.5
            //            color: "green"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            Rectangle {
                width: parent.width
                height: parent.height / 5
                Text {
                    text: '身份证'
                    color: "#000"
                    font.family: "微软雅黑"
                    font.pixelSize: parent.width / 20
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                anchors.bottom: cameraArea.bottom
                anchors.left: parent.left
                width: parent.width * 0.8
                height: parent.height * 0.8 * 0.6
                anchors.bottomMargin: parent.height * 0.8 * 0.3
                anchors.leftMargin: parent.width * 0.1
                color: "#f2f2f2"
                Rectangle {
                    //                    width: parent.width / 4
                    //                    height: parent.height / 3
                    anchors.fill: parent
                    anchors.centerIn: parent
                    color: "#f2f2f2"
                    Image {
                        id: cameraPng
                        anchors.fill: parent
                        source: './images/camera.png'
                        //                         source: 'H:/shnhs4_20210804_212305_00020.jpg'
                        fillMode: Image.PreserveAspectFit
                        // anchors.centerIn: parent
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userPopup.open();
                        cameraPreview = '';
                        camera.start()
                    }
                }
            }
        }
    }
}
