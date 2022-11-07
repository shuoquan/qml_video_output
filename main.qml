import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
import VideoAdapter 1.0

Window {
    minimumWidth: 640
    minimumHeight: 360
//    maximumWidth: 1200
//    maximumHeight: 720
    visible: true

    Component.onCompleted: {
        video.source = videoSrc
        console.log(screen.width, 'aa')
    }

    property int imageIdx: 1

    function addImageToBottom() {
        const time = new Date().getFullYear().toString() +
                   '-' +
                   (new Date().getMonth() + 1).toString().padStart(2, '0') +
                   '-' +
                   new Date().getDate().toString().padStart(2, '0') +
                   ',' +
                   new Date().getHours().toString().padStart(2, '0') +
                   ':' +
                   new Date().getMinutes().toString().padStart(2, '0') +
                   ':' +
                   new Date().getSeconds().toString().padStart(2, '0');
        imageModel.append({'imageIdx': imageIdx, 'time': time, 'mainViewSrc': './images/demo.jpg', 'sideViewSrc': './images/demo.jpg'})
//                    imageModel.sync()
        imageIdx += 1
        console.log("abc", imageModel.count)
        while (imageModel.count > 5) {
            imageModel.remove(0)
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
                                 text: imageIdx
//                                 font.pixelSize: 30
                                 font.pixelSize: (parent.width - 40) / 24
                                 font.bold: true
                                 anchors.left: parent.left
                                 anchors.verticalCenter: parent.verticalCenter
                             }
                             Text {
                                 text: time
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
//                                         width: 360
//                                         height: 250
                                         width: (imageArea.width - 30) / 2
                                         height: (imageArea.width - 30) / 3
                                         sourceSize.width: (imageArea.width - 30) / 2
                                         sourceSize.height: (imageArea.width - 30) / 3
                                         sourceClipRect: Qt.rect(100, 100, 512, 512)
                                         source: mainViewSrc
                                         fillMode: Image.PreserveAspectFit
                                         anchors.centerIn: parent
                                         Component.onCompleted: {
                                             console.log('abcdef', mainViewSrc);
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
                                         source: sideViewSrc
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
                         if (contentY === contentHeight - height) {
                             addImageToBottom()
                         }
                         if (contentY >= 1520 && (contentY - 1520) % 370 === 0) {
                             addImageToBottom()
                         }
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
                    addImageToBottom()

//                    fruitModel.append({"cost": 5.95, "name":"Pizza"})
//                    console.log(fruitModel)
                }
            }
        }
    }
}
