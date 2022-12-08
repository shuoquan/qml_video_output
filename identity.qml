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
    property int bagStaus: 2
    property int categoryIndex: -1
    property var categoryList: []
    property var bagInfo: ({})
    property string imagePath: ""
    property var userPicMap: ({})
    property string curUserPath: ''
    property string lastUserPath: ''
    property string userPicSource: './images/camera.png'
    property int popType: 1 // 1-用户 2-违禁品
    property int categoryModelIndex: -1  // 当前违禁品列表索引
    property var categoryModelPicMap: ({})
    property string curModelPicPath: ''
    property var qmlObject: []
    //    signal dealStack()
    Component.onCompleted: {
        //        camera.setCameraState(Camera.UnloadedState);
        //        camera.stop();
        imagePath = imagePrefix;
        console.log(JSON.stringify(bagInfo), 'test')
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
        //        console.log(JSON.stringify(categoryList))
        //        timer.start()
    }

    Connections {
        target: root
        function onGetNext() {
            console.log('ss', bagStaus, nameInputText.text, phoneInputText.text, userPicSource);
            const submitCategoryList = [];
            for(let i=0; i<categoryModel.count; i++) {
                console.log(JSON.stringify(categoryModel.get(i)))
                const curCategoryModel = categoryModel.get(i);
                if (curCategoryModel.categoryName != "类别" && curCategoryModel.imageSource.includes("file")) {
                    submitCategoryList.push({
                                                categoryName: curCategoryModel.categoryName,
                                                categoryId: categoryList.find(v=>v.name ==  curCategoryModel.categoryName).id,
                                                path: curCategoryModel.imageSource.replace('file:///', '')

                                            }
                                            )
                }
            }
            const userInfo = {
                bagId: bagInfo.id,
                bagUserName: nameInputText.text || '',
                bagUserPhone: phoneInputText.text || '',
                userPic: userPicSource.includes('file') ? userPicSource.replace('file:///', '') : ''
            }

            //            homeSrc.submitBagRegisterInfo(JSON.stringify(userInfo), JSON.stringify(submitCategoryList), bagStaus)

            homeSrc.fetchBag(bagInfo.id, 1, 1, 2);
        }

    }

    Connections {
        target: homeSrc
        function onSendBagInfo(bagListInfo, pageState) {
            if (pageState != 2) {
                return;
            }
            console.log(bagListInfo, '222222222', pageState);
            const bagList = JSON.parse(bagListInfo || '[]');
            if (bagList.length) {
                if (categoryModel.count) {
                    categoryModel.remove(0, categoryModel.count);
                    categoryModel.append( {
                                             categoryName: "类别",
                                             imageSource: '',
                                             selectActive: false
                                         })
                }
                nameInputText.text = '';
                phoneInputText.text = '';
                bagStaus = 2;
                userPicSource = './images/camera.png';
                //                bagInfo = {};
                const curBag = bagList[0];
                //                bagInfo = JSON.parse(JSON.stringify(bagList[0]));
                const date = new Date(curBag.block_create_at);
                //        console.log(date, 'd')
                const time = date.getFullYear().toString() +
                           '-' +
                           (date.getMonth() + 1).toString().padStart(2, '0') +
                           '-' +
                           date.getDate().toString().padStart(2, '0') +
                           ',' +
                           date.getHours().toString().padStart(2, '0') +
                           ':' +
                           date.getMinutes().toString().padStart(2, '0') +
                           ':' +
                           date.getSeconds().toString().padStart(2, '0');
                bagInfo.block_create_at = time;
                console.log(time, 'ddddddddddfsfgs')
                bagInfo.id = curBag.id;
                bagInfo.device = curBag.device;
                bagInfo.block_name = curBag.block_name;
                bagInfo.b

                const bagCoordinateList = curBag.bag_coordinate.replace(/\(|\)/g, '').split(',').map(Number);
                bagInfo.x0 = Math.min(bagCoordinateList[0], bagCoordinateList[2]);
                bagInfo.x1 = Math.max(bagCoordinateList[0], bagCoordinateList[2]);
                bagInfo.y0 = Math.min(bagCoordinateList[1], bagCoordinateList[3]);
                bagInfo.y1 = Math.max(bagCoordinateList[1], bagCoordinateList[3]);
                bagInfo.unpackBoxInfoList = JSON.stringify(bagInfo.unpackBoxInfoList || []);
                console.log('abcddfg', bagInfo.block_create_at)
            }
        }
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
            //            opacity: 0.6
            //            color: "transparent"
            //            border.color: "transparent"
            border.width: 1
            border.color: "#BFBFBF"
        }

        //        dim: true
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
                source: imagePath + bagInfo.block_path
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                sourceSize.width: bagInfo.block_width
                sourceSize.height: bagInfo.block_height
                sourceClipRect: Qt.rect(bagInfo.x0,bagInfo.y0,bagInfo.x1-bagInfo.x0,bagInfo.y1-bagInfo.y0)
                onStatusChanged:   {
                    while (qmlObject.length) {
                        console.log('pop')
                        const curQml = qmlObject.pop();
                        curQml.destroy();
                    }
                    const {x0,x1,y0,y1,unpackBoxInfoList,box} = bagInfo;
                    const heightRatio = popImage.height / (y1-y0);
                    const widthRatio = popImage.width / (x1-x0);
                    const ratio = Math.min(widthRatio, heightRatio);
                    const unpackBoxList = JSON.parse(unpackBoxInfoList);
                    if(heightRatio <= 0 || widthRatio <= 0) {
                        return;
                    }

                    console.log(x0, x1, y0, y1, 'ddddddddd', heightRatio, widthRatio)
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
                            const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
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
        padding: 0
        background: Rectangle {
            //            opacity: 0.6
            border.width: 1
            border.color: "#BFBFBF"
        }

        onOpened: {
            console.log(camera.availability, Camera.Available, Camera.Unavailable, camera.cameraStatus, camera.cameraState, 'abcdefg')
            homeSrc.modifyOpacity(0.7);
            if (popType == 1) {
                if (userPicSource == './images/camera.png') {
                    if (camera.availability == Camera.Available) {
                        userCamera = true;
                        camera.setCameraState(Camera.LoadedState);
                        camera.start();
                    }
                } else {
                    popUpImage.source = userPicSource;
                }
            } else if (popType == 2) {
                const curCategoryModel = categoryModel.get(categoryModelIndex);
                if (!curCategoryModel.imageSource) {
                    if (camera.availability == Camera.Available) {
                        userCamera = true;
                        camera.setCameraState(Camera.LoadedState);
                        camera.start();
                    }
                } else {
                    popUpImage.source = curCategoryModel.imageSource;
                }
            }
        }
        onClosed: {
            homeSrc.modifyOpacity(1.0);
            if (userCamera) {
                if (camera.availability == Camera.Available) {
                    userCamera = false;
                    camera.stop();
                }
            }
            //            if (popType == 1) {
            //                if (userCamera) {
            //                    if (camera.availability == Camera.Available) {
            //                        userCamera = false;
            //                        camera.stop();
            //                    }
            //                }
            //            } else if (popType == 2) {
            //                if (userCamera) {
            //                    if (camera.availability == Camera.Available) {
            //                        userCamera = false;
            //                        camera.stop();
            //                    }
            //                }
            //            }
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
                visible: userCamera
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('click 111')
                        if (popType == 1) {
                            if (camera.cameraStatus == Camera.LoadedStatus) {
                                camera.start();
                            } else if(camera.cameraStatus == Camera.ActiveStatus) {
                                //                            camera.stop();
                                //                            while(true) {
                                //                                if
                                //                            }
                                if (!lastUserPath) {
                                    lastUserPath = `F:/pic/user_1.jpg`;
                                    curUserPath = `F:/pic/user_1.jpg`;
                                    camera.imageCapture.captureToLocation(curUserPath);
                                } else {
                                    if (lastUserPath == curUserPath) {
                                        curUserPath = `F:/pic/user_2.jpg`;
                                        camera.imageCapture.captureToLocation(curUserPath);
                                    } else {
                                        if (lastUserPath === `F:/pic/user_1.jpg`) {
                                            if (userPicMap[`F:/pic/user_1.jpg`] == userPicSource) {
                                                curUserPath = `F:/pic/user_2.jpg`;
                                            } else {
                                                lastUserPath = `F:/pic/user_2.jpg`;
                                                curUserPath = `F:/pic/user_1.jpg`;
                                            }
                                        } else {
                                            if (userPicMap[`F:/pic/user_2.jpg`] == userPicSource) {
                                                curUserPath = `F:/pic/user_1.jpg`;
                                            } else {
                                                lastUserPath = `F:/pic/user_1.jpg`;
                                                curUserPath = `F:/pic/user_2.jpg`;
                                            }
                                        }
                                        camera.imageCapture.captureToLocation(curUserPath);
                                    }
                                }
                            }
                        } else if (popType == 2) {
                            if (camera.cameraStatus == Camera.LoadedStatus) {
                                camera.start();
                            } else if(camera.cameraStatus == Camera.ActiveStatus) {
                                curModelPicPath = `F:/pic/cat_${new Date().getTime()}.jpg`;
                                camera.imageCapture.captureToLocation(curModelPicPath);
                            }
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
                cameraState: Camera.UnloadedStatus
                imageCapture {
                    onImageCaptured: {
                        //                        console.log('capture Camera')
                        //                        okPic.source = preview;
                        console.log(preview, 'xx');
                        //  capturedImagePath
                        cameraPreview = preview;
                        if (popType == 1) {
                            userPicMap[curUserPath] = preview;
                        } else if(popType == 2) {
                            categoryModelPicMap[curModelPicPath] = preview;
                        }

                        camera.stop();
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

            Image {
                id: popUpImage
                visible: !userCamera
                //                source: './images/close-dark.png'
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                anchors.centerIn: parent
            }

            Rectangle {
                visible: !userCamera
                height: parent.height / 10
                width: parent.height / 10
                anchors.topMargin: parent.height / 30
                anchors.rightMargin: parent.height / 30
                anchors.top: parent.top
                anchors.right: parent.right
                color: "transparent"
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
                            userPopup.close();
                        }
                    }
                }
            }
            Rectangle {
                visible: userCamera
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
                            console.log('close', cameraPng.source, cameraPreview, curUserPath, JSON.stringify(userPicMap))
                        }
                    }
                }
            }

            Rectangle {
                visible: userCamera
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
                                if (popType == 1) {
                                    const localPath = Object.keys(userPicMap).find(v=>userPicMap[v]===cameraPreview);
                                    if (localPath) {
                                        userPicSource = `file:///${localPath}`;
                                    }

                                    //                                    userPicSource = cameraPreview;
                                    console.log(JSON.stringify(Object.keys(userPicMap).find(v=>userPicMap[v]===cameraPreview)))
                                    console.log('okokok', cameraPng.source, cameraPreview, curUserPath, JSON.stringify(userPicMap))
                                } else if (popType == 2) {
                                    const curCategoryModel = categoryModel.get(categoryModelIndex);
                                    const localPath = Object.keys(categoryModelPicMap).find(v=>categoryModelPicMap[v]===cameraPreview);
                                    if (localPath) {
                                        curCategoryModel.imageSource = `file:///${localPath}`;
                                    }
                                    //                                    curCategoryModel.imageSource = cameraPreview;
                                    categoryModel.set(categoryModelIndex, curCategoryModel);
                                    console.log('22ok', cameraPreview, curModelPicPath, JSON.stringify(categoryModelPicMap), JSON.stringify(curCategoryModel));
                                }

                                //                                homeSrc.loadImage(cameraPreview);

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
                        text: bagInfo.id - (bagInfo.minIndex || 0) + 1001
                        anchors.centerIn: parent
                        font.family: "微软雅黑"
                        font.pixelSize: bagNum.width / 4
                        color: "#fff"
                    }
                }
                Text {
                    text: bagInfo.block_create_at
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
                        id: image
                        source: imagePath + bagInfo.block_path
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        width: imageArea.width - 4
                        height: imageArea.height - 4
                        sourceSize.width: bagInfo.block_width
                        sourceSize.height: bagInfo.block_height
                        sourceClipRect: Qt.rect(bagInfo.x0,bagInfo.y0,bagInfo.x1-bagInfo.x0,bagInfo.y1-bagInfo.y0)
                        onStatusChanged:   {
                            const {x0,x1,y0,y1,unpackBoxInfoList,box} = bagInfo;
                            const heightRatio = image.height / (y1-y0);
                            const widthRatio = image.width / (x1-x0);
                            const ratio = Math.min(widthRatio, heightRatio);
                            const unpackBoxList = JSON.parse(unpackBoxInfoList);
                            if(heightRatio <= 0 || widthRatio <= 0) {
                                return;
                            }

                            console.log(x0, x1, y0, y1, 'ddddddddd', heightRatio, widthRatio)
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
                                                           parent, `myItem${box.id}`)
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
                                                           parent, `myItem${box.id}`)
                                    }
                                } else if(box.type == 2) {
                                    const leftTopX = 236;
                                    const leftTopY = 345;
                                    const rightBottomX = 343;
                                    const rightBottomY = 406;
                                    //                                                     Qt.createQmlObject(`
                                    //                                                     import QtQuick 2.0
                                    //                                                     Rectangle {
                                    //                                                        width: ${rightBottomX - leftTopX} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                    //                                                        height: ${rightBottomY - leftTopY} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                    //                                                        border.color: 'red'
                                    //                                                        border.width: 2
                                    //                                                        anchors.top: parent.top
                                    //                                                        anchors.left: parent.left
                                    //                                                        anchors.leftMargin: ${leftTopX - x0} * Math.min(image.height / (y1-y0), image.width / (x1-x0)) + (image.width - (x1-x0)*Math.min(image.height / (y1-y0), image.width / (x1-x0))) / 2
                                    //                                                        anchors.topMargin: ${leftTopY - y0} * Math.min(image.height / (y1-y0), image.width / (x1-x0))
                                    //                                                        color: 'transparent'
                                    //                                                     }
                                    //                                                     `,
                                    //                                                     parent, `myItem${box.id}`)
                                    //                                                     const pointList = [236, 345, 343, 345, 343, 406, 236, 406];
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
                                color: bagStaus == 2 ? '#7f7f7f' : "#fff"
                            }
                            contentItem: Text {
                                text: "禁带品登记"
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
                                color: bagStaus == 1 ? '#7f7f7f' : "#fff"
                            }
                            contentItem: Text {
                                text: "放行"
                                font.family: "微软雅黑"
                                color: bagStaus == 1 ? '#fff' : '#000'
                                font.pixelSize: buttonArea.height / 4
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                bagStaus = 1;
                                //                                console.log('sssf')
                                //                                 dealStack()
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
                                            font.pixelSize: parent.width / 3
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
                                        onOpened: {
                                            //                                            console.log('11');
                                            myTriangle.state = "rotated";
                                            //                                            myTriangle.state = '';
                                        }
                                        onClosed: {
                                            //                                            console.log('22')
                                            //                                            myTriangle.rotation.
                                            myTriangle.state = "";
                                        }

                                        //                                        visible: false

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
                                                            categoryPopup.close()
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
                                            source: './images/camera.png'
                                            fillMode: Image.PreserveAspectFit
                                            height: parent.height / 2
                                            anchors.centerIn: parent
                                            visible: !imageSource
                                        }
                                        Image {
                                            //                                            source: `file:///${catagoryModelPicMap[imageSource]}`
                                            //                                            source: `file:///${Object.keys(catagoryModelPicMap).find(v=>categoryModelPicMap[v]==imageSource)}`
                                            source: imageSource
                                            height: parent.height
                                            width: parent.width
                                            fillMode: Image.PreserveAspectFit
                                            anchors.centerIn: parent
                                            visible: !!imageSource
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                console.log(index, 'abcdf');
                                                categoryModelIndex = index;
                                                popType = 2;
                                                cameraPreview = '';
                                                userPopup.open();
                                            }
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
                        id: nameInputText
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
                        id: phoneInputText
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
                    id: myCam
                    //                    color: "red"
                    Image {
                        id: cameraPng_1
                        //                        source: "file:///H:/pic/user_1.jpg"
                        source: userPicSource
                        height: myCam.height * 0.6
                        width: myCam.width * 0.75
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: userPicSource === './images/camera.png'
                    }
                    Image {
                        id: cameraPng
                        source: userPicSource
                        height: myCam.height
                        width: myCam.width
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        visible: userPicSource !== './images/camera.png'
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popType = 1;
                        cameraPreview = '';
                        userPopup.open();
                    }
                }
            }
        }
    }
}
