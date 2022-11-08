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
//        const res = homeSrc.fetchBag(5);
//        console.log(screen.width, 'aa', res)
        mock();
    }

    function mock() {
        console.log("mock");
        const bagList = JSON.parse("[{\"id\":5,\"device\":\"shnth4\",\"block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"block_path\":\"F:/images/shnth4_20211015_111806_880_1.jpg\",\"block_width\":744,\"block_height\":1260,\"block_create_at\":\"2022-11-08T03:52:05.000Z\",\"block_id\":0,\"video_block_name\":\"shnth4_20211015_111806_880_1.jpg\",\"video_block_path\":\"F:/images/shnth4_20211015_111806_880_1.jpg\",\"video_block_width\":1260,\"video_block_height\":744,\"create_at\":\"2022-11-08T06:28:35.649Z\",\"bag_coordinate\":\"(744,580),(0,0)\",\"unpackBoxInfoList\":[{\"id\":1,\"categoryId\":1,\"bagId\":5,\"categoryName\":\"刀\",\"box\":\"{\\\"((20,20),(80,80))\\\"}\",\"type\":1},{\"id\":2,\"categoryId\":0,\"bagId\":5,\"categoryName\":\"\",\"box\":\"{\\\"((120,120),(130,130),(140,140),(150,150))\\\"}\",\"type\":2}]}]");
        console.log(insertDirection)
        for(const bag of bagList) {
//            console.log(JSON.stringify(bag));
            addImageToBottom(bag);
        }
    }

    Connections {
        target: homeSrc
        function onSendBagInfo(bagInfo) {
            const bagList = JSON.parse(bagInfo || "[]");
            console.log(insertDirection)
            for(const bag of bagList) {
                console.log(JSON.stringify(bag));
            }
        }
    }

    property int imageIdx: 1
    // 默认头部插入
    property int insertDirection: 1

    function addImageToBottom(bagInfo) {
        const date = new Date(bagInfo.block_create_at);
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
        imageModel.append(bagInfo);
        console.log("abc", imageModel.count)
        while (imageModel.count > 5) {
            imageModel.remove(imageModel.count - 1)
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
                                         source: "file:///" + block_path
                                         fillMode: Image.PreserveAspectFit
                                         anchors.centerIn: parent
//                                         Component.onStatusChanged: {
//                                             console.log('aa')
//                                         }

                                         Component.onCompleted:   {
                                             console.log('abcdef');
//                                             console.log(x0, x1, y0, y1)
                                             console.log(image.width, image.height);
                                             const heightRatio = image.height / (y1-y0);
                                             const widthRatio = image.width / (x1-x0);
                                             const ratio = Math.min(widthRatio, heightRatio);
                                             const width = 80 * ratio;
                                             const height = 100 * ratio;
                                             if (heightRatio < widthRatio) {
                                                 console.log('1x')
                                                 Qt.createQmlObject(`
                                                 import QtQuick 2.0
                                                 Rectangle {
                                                    width: ${width}
                                                    height: ${height}
                                                    border.color: 'red'
                                                    border.width: 2
                                                    anchors.top: parent.top
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: ${160 * ratio + (image.width - width) / 2 - 40}
                                                    anchors.topMargin: ${60 * ratio}
                                                    color: 'transparent'
                                                 }
                                                 `,
                                                 parent, "myItem")
                                             } else {
                                                 console.log('2x')
                                                 Qt.createQmlObject(`
                                                 import QtQuick 2.0
                                                 Rectangle {
                                                    width: ${width}
                                                    height: ${height}
                                                    border.color: 'red'
                                                    border.width: 2
                                                    anchors.top: parent.top
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: ${160 * ratio}
                                                    anchors.topMargin: ${60 * ratio + (image.height - height) / 2}
                                                    color: 'transparent'
                                                 }
                                                 `,
                                                 parent, "myItem")
                                             }

//                                             console.log(ratio)
//                                             const unpackBoxList = JSON.parse(unpackBoxInfoList);
//                                             for(const box of unpackBoxList) {
//                                                 Qt.createQmlObject(`
//                                                    import QtQuick 2.0


//                                                 `)
//                                             }

//                                             const newObject = Qt.createQmlObject(`
//                                                 import QtQuick 2.0

//                                                 Rectangle {
//                                                                                  color: 'red'
//                                                     width: 20
//                                                     height: 20
//                                                 }
//                                                 `,
//                                                                                  parent,
//                                                                                  "myItem"
//                                             );

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
                                         source: "file:///" + video_block_path
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
                         console.log(contentY, contentHeight, height, 'ddd')
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
                // anchors.horizontalCenter: parent.horizontalCenter
                // anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent
                fillMode: VideoOutput.PreserveAspectFit
//                source: camera
                focus : visible // to receive focus and capture key events when visible
//                source: provider
            }


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
//                    videoSrc.startPlay()
//                    addImageToBottom()

//                    fruitModel.append({"cost": 5.95, "name":"Pizza"})
//                    console.log(fruitModel)
                }
            }
        }
    }
}
