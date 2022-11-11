import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import VideoAdapter 1.0

Window {
    minimumWidth: 640
    minimumHeight: 360
//    maximumWidth: 1200
//    maximumHeight: 720
    visible: true

    Component.onCompleted: {
        video.source = videoSrc
        homeSrc.fetchBag(0, -1, 2);

//        homeSrc.fetchBag(13, 0, 1);
//        const res = homeSrc.fetchBag(5);
//        console.log(screen.width, 'aa', res)
//        mock();
    }

    function mock() {
        console.log("mock");
//        http://192.168.7.25:8256/images/core7/data2/images/raw_data/nj_jms_tf_1/rgb_data/202111/22/njjmstf1_20211122_131655_706_12031733.jpg
        const bagList = JSON.parse("[{\"id\":5,\"type\":0,\"device\":\"shnth4\",\"block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"block_path\":\"/home/core/Pictures/shnth4_20211015_111806_880_1.jpg\",\"block_width\":744,\"block_height\":1260,\"block_create_at\":\"2022-11-08T03:52:05.000Z\",\"block_id\":0,\"video_block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"video_block_path\":\"/home/core/Pictures/shnth4_20211015_111806_880_1.jpg\",\"video_block_width\":1260,\"video_block_height\":744,\"create_at\":\"2022-11-08T06:28:35.649Z\",\"bag_coordinate\":\"(744,580),(0,0)\",\"unpackBoxInfoList\":[{\"id\":1,\"categoryId\":1,\"bagId\":5,\"categoryName\":\"刀\",\"box\":\"{\\\"((160,60),(240,160))\\\"}\",\"type\":1},{\"id\":2,\"categoryId\":0,\"bagId\":5,\"categoryName\":\"\",\"box\":\"{\\\"((120,120),(130,130),(140,140),(150,150))\\\"}\",\"type\":2}]}]");
//        console.log(insertDirection)
//        const tmpBagList = bagList.concat(bagList);
        for(const bag of bagList) {
//            console.log(JSON.stringify(bag));
            bag.id = new Date().getTime();
            addImage(bag, 0);
        }
//        const tmp = JSON.parse("[{\"id\":5,\"device\":\"shnth4\",\"block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"block_path\":\"F:/images/shnth4_20211015_111806_880_1.jpg\",\"block_width\":744,\"block_height\":1260,\"block_create_at\":\"2022-11-08T03:52:05.000Z\",\"block_id\":0,\"video_block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"video_block_path\":\"F:/images/shnth4_20211015_111806_880_1.jpg\",\"video_block_width\":1260,\"video_block_height\":744,\"create_at\":\"2022-11-08T06:28:35.649Z\",\"bag_coordinate\":\"(744,580),(0,0)\",\"unpackBoxInfoList\":[{\"id\":1,\"categoryId\":1,\"bagId\":5,\"categoryName\":\"刀\",\"box\":\"{\\\"((0,0),(240,160))\\\"}\",\"type\":1},{\"id\":2,\"categoryId\":0,\"bagId\":5,\"categoryName\":\"\",\"box\":\"{\\\"((120,120),(130,130),(140,140),(150,150))\\\"}\",\"type\":2}]}]");
//        for(const bag1 of tmp) {
//            addImageToBottom(bag1);
//        }
    }

    Connections {
        target: homeSrc
        function onSendBagInfo(bagInfo) {
            const bagList = JSON.parse(bagInfo || "[]");
//            console.log(insertDirection)
            for(const bag of bagList) {
                if (bag.type == -1) {
                    addImage(bag, -1);
                } else {
                    addImage(bag, 0);
                }

//                console.log(JSON.stringify(bag));
            }
        }
    }

    property int imageIdx: 1
    // 默认头部插入
//    property int insertDirection: 0

    // position 0 头部插入， -1 尾部插入
    function addImage(bagInfo, position) {
        const date = new Date(bagInfo.block_create_at);
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
        const bagCoordinateList = bagInfo.bag_coordinate.replace(/\(|\)/g, '').split(',').map(Number);
        bagInfo.x0 = Math.min(bagCoordinateList[0], bagCoordinateList[2]);
        bagInfo.x1 = Math.max(bagCoordinateList[0], bagCoordinateList[2]);
        bagInfo.y0 = Math.min(bagCoordinateList[1], bagCoordinateList[3]);
        bagInfo.y1 = Math.max(bagCoordinateList[1], bagCoordinateList[3]);
        bagInfo.unpackBoxInfoList = JSON.stringify(bagInfo.unpackBoxInfoList);
//        imageModel.append({'imageIdx': imageIdx, 'time': time, 'mainViewSrc': './images/demo.jpg', 'sideViewSrc': 'http://www.gov.cn/xhtml/2016gov/images/guoqing/bigmap.jpg'})
////                    imageModel.sync()
//        imageIdx += 1
        if (position === 0) {
            imageModel.insert(0, bagInfo);
        } else {
            imageModel.append(bagInfo);
        }
        while (imageModel.count > 5) {
            if (position === 0) {
                imageModel.remove(imageModel.count - 1);
            } else {
                imageModel.remove(0);
            }
        }
    }

    Rectangle {
        id: outer
        anchors.fill: parent
        color: '#f7f7f7'
        ScrollView {
            id: leftBox
            anchors.left: outer.left
            anchors.top: outer.top
            height: parent.height - 20
            width: parent.width * 2 / 3 - 10
//            width: 800 - 10
            //            color: 'green'
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            clip: true

//            flickableItem.onContentYChanged: {

//            }

//            color: '#f7f7f7'
            //        anchors.margins: 20

            Column {
                id: column
                spacing: 10
//                width: parent.width
//                height: parent.height
                anchors.fill: parent // 注意

                 ListModel {
                     id: imageModel
                 }
                 Component {
                     id: imageDelegate

                     Rectangle {
//                         height: 370
//                         width: 790
                         height: parent.width / 2
                         width: parent.width
                         color: '#ffffff'
                         //                    anchors.margins: 10
                         Rectangle {
                             anchors.left: parent.left
                             anchors.right: parent.right
                             anchors.top: parent.top
                             anchors.leftMargin: 20
                             anchors.rightMargin: 20
                             anchors.topMargin: 10
                             //                            color: 'red'
                             width: parent.width - 40
//                             height: 80
                             height:  (parent.width - 40) / 8
                             Text {
                                 text: id
//                                 font.pixelSize: 30
                                 font.pixelSize: (parent.width - 40) / 24
                                 font.bold: true
                                 anchors.left: parent.left
                                 anchors.verticalCenter: parent.verticalCenter
                             }
                             Text {
                                 text: block_create_at
//                                 font.pixelSize: 20
                                 font.pixelSize: (parent.width - 40) / 36
                                 font.bold: true
                                 anchors.verticalCenter: parent.verticalCenter
                                 anchors.left: parent.left
                                 anchors.leftMargin: 90
                             }
                             Button {
                                 text: '开包检查'
//                                 font.pixelSize: 18
                                 font.pixelSize: (parent.width - 40) / 40
                                 font.bold: true
                                 anchors.verticalCenter: parent.verticalCenter
                                 //                                width: 100
                                 //                                height: 40
                                 anchors.right: parent.right
                                 anchors.rightMargin: 20
                                 background: Rectangle {
//                                     implicitWidth: 100
//                                     implicitHeight: 40
                                     implicitWidth: (parent.width - 40) / 7
                                     implicitHeight: (parent.width - 40) / 18
                                     border.color: '#293351'
                                     border.width: 2
                                     radius: 4
                                 }
                             }
                         }
                         Rectangle {
                             id: imageArea
                             anchors.right: parent.right
                             anchors.left: parent.left
                             anchors.bottom: parent.bottom
                             anchors.leftMargin: 20
                             anchors.rightMargin: 20
                             anchors.bottomMargin: 10
                             //                            color: 'red'
                             width: parent.width - 40
//                             height: 250
                             height: (parent.width - 40) / 3
                             Row {
                                 spacing: 10
                                 Rectangle {
//                                     width: 364
//                                     height: 254
                                     width: (imageArea.width - 30) / 2 + 4
                                     height: (imageArea.width - 30) / 3 + 4
                                     border.color: '#f7f7f7'
                                     border.width: 2
                                     radius: 2
                                     Image {
                                         id: image
//                                         width: 360
//                                         height: 250
                                         width: (imageArea.width - 30) / 2
                                         height: (imageArea.width - 30) / 3
                                         sourceSize.width: block_width
                                         sourceSize.height: block_height
                                         sourceClipRect: Qt.rect(x0,y0,x1-x0,y1-y0)
//                                         source: "file:///" + block_path
                                         source: "http://192.168.8.173:8256/images" + block_path
                                         fillMode: Image.PreserveAspectFit
                                         anchors.centerIn: parent

                                         Component.onCompleted:   {
                                             const heightRatio = image.height / (y1-y0);
                                             const widthRatio = image.width / (x1-x0);
                                             const ratio = Math.min(widthRatio, heightRatio);
                                             const unpackBoxList = JSON.parse(unpackBoxInfoList);
                                             for(const box of unpackBoxList) {
//                                                 console.log('box')
//                                                 console.log(JSON.stringify(box))
                                                 // 处理矩形情况
                                                 if (box.type == 1) {
                                                     const pointList = box.box.replace(/[(|)|{|}|"]/g, '').split(",").map(Number);
                                                     const leftTopX = Math.min(pointList[0], pointList[2]);
                                                     const leftTopY = Math.min(pointList[1], pointList[3]);
                                                     const rightBottomX = Math.max(pointList[0], pointList[2]);
                                                     const rightBottomY = Math.max(pointList[1], pointList[3]);
                                                     if (heightRatio < widthRatio) {
                                                         console.log('1x')
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
                                                         console.log('2x')
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

                                 Rectangle {
//                                     width: 364
//                                     height: 254
                                     width: (imageArea.width - 30) / 2 + 4
                                     height: (imageArea.width - 30) / 3 + 4
                                     border.color: '#f7f7f7'
                                     border.width: 2
                                     radius: 2
                                     Image {
//                                         width: 360
//                                         height: 250
                                         width: (imageArea.width - 30) / 2
                                         height: (imageArea.width - 30) / 3
//                                         source: "file:///" + video_block_path
                                         source: "http://192.168.8.173:8256/images" + video_block_path
                                         fillMode: Image.PreserveAspectFit
                                         anchors.centerIn: parent
                                     }
                                 }
                             }
                         }
                     }
                 }

                 ListView {
                     anchors.fill: parent
                     model: imageModel
                     delegate: imageDelegate
                     onContentYChanged: {
                         console.log(contentY, contentHeight, height, 'ddd', originY)
                         if (contentHeight > height && contentY - originY == contentHeight - height) {
                             console.log('getFromBottom-------');
//                             insertDirection = -1;
                             homeSrc.fetchBag(imageModel.get(imageModel.count - 1).id, -1, 1);
                         }
                         if (contentY == 0 || contentY == originY) {
                             console.log('getFromTop----');
//                             insertDirection = 0;
                             homeSrc.fetchBag(imageModel.get(0).id, 1, 1);
                         }

//                         if (contentY === contentHeight - height) {
//                             addImageToBottom()
//                         }
//                         if (contentY >= 1520 && (contentY - 1520) % 370 === 0) {
//                             addImageToBottom()
//                         }
                     }
                 }
            }
        }

        Rectangle {
            id: rightBox
            height: parent.height - 20
//            width: 400 - 20
            width: (parent.width) / 3 - 20
//            color: 'yellow'
            anchors.left: leftBox.right
            anchors.top: outer.top
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.rightMargin: 10

//            ScrollView {
//                anchors.fill: parent
//                clip: true
//                Column {
//                    spacing: 10
//                    anchors.fill: parent
//                    Rectangle {
//    //                    anchors.fill: parent
//                        height: 250
//                        width: parent.width
//                        color: 'red'
//                    }
//                    Rectangle {
//                        height: 250
//                        width: parent.width
//                        color: 'green'
//                    }
//                    Rectangle {
//                        height: 200
//                        width: parent.width
//                        color: 'yellow'
//                    }
//                    Rectangle {
//                        height: 200
//                        width: parent.width
//                        color: 'red'
//                    }
//                    Rectangle {
//                        height: 200
//                        width: parent.width
//                        color: 'yellow'
//                    }
//                    Rectangle {
//                        height: 200
//                        width: parent.width
//                        color: 'green'
//                    }
//                }
//            }


            VideoOutput {
                id: video
                 width: parent.width
                 height: parent.height
//                 height: parent.height
                // anchors.horizontalCenter: parent.horizontalCenter
                // anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent
                fillMode: VideoOutput.PreserveAspectFit
//                source: camera
                focus : visible // to receive focus and capture key events when visible
//                source: provider
            }


//            Rectangle {
//                width: 100
//                height: 100
//                anchors.left: parent.left
//                anchors.top: video.bottom
////                color: 'red'
//                Canvas {
//                    id: canvas
//                    anchors.fill: parent
//                    onPaint: {
//                        console.log('xxxxx')
//                        const ctx = getContext('2d');
////                        ctx.strokeRect(20,20,60,60);
////                        ctx.strokeStyle = "white";

//                        ctx.beginPath();
//                        ctx.strokeStyle="#FF0000";
//                        ctx.lineWidth = 2;
////                        ctx.moveTo(400, 280);
////                        ctx.lineTo(420, 300);
////                        ctx.lineTo(400, 300);
//                        ctx.moveTo(20, 20);
//                        ctx.lineTo(60, 60);
//                        ctx.lineTo(20, 60);
////                        ctx.closePath();
//                        ctx.stroke();
//                        console.log('ajklsjl')
//                    }
//                }
//            }


//            MediaPlayer {
//                    id: videoPlayer
//                    source: "rtmp://192.168.133.128:1935/live/test"
//                    muted: true
//                    autoPlay: true
//              }

//            VideoAdapter {
//                id: provider
//                source: "rtmp://192.168.133.128:1935/live/test"
//            }

//            Camera {
//                id: camera
//            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
//                    mock();
//                    videoSrc.startPlay()
//                    addImageToBottom()

//                    fruitModel.append({"cost": 5.95, "name":"Pizza"})
//                    console.log(fruitModel)
                }
            }
        }
    }
}
