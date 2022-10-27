import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15

Window {
    minimumWidth: 1200
    minimumHeight: 720
    maximumWidth: 1200
    maximumHeight: 720
    visible: true

    Component.onCompleted: {
        video.source = videoSrc
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
            width: 800 - 10
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
                anchors.fill: parent // 注意

                 ListModel {
                     id: imageModel
                 }
                 Component {
                     id: imageDelegate

                     Rectangle {
                         height: 370
                         width: 790
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
                             height: 80
                             Text {
                                 text: imageIdx
                                 font.pixelSize: 30
                                 font.bold: true
                                 anchors.left: parent.left
                                 anchors.verticalCenter: parent.verticalCenter
                             }
                             Text {
                                 text: time
                                 font.pixelSize: 20
                                 font.bold: true
                                 anchors.verticalCenter: parent.verticalCenter
                                 anchors.left: parent.left
                                 anchors.leftMargin: 90
                             }
                             Button {
                                 text: '开包检查'
                                 font.pixelSize: 18
                                 font.bold: true
                                 anchors.verticalCenter: parent.verticalCenter
                                 //                                width: 100
                                 //                                height: 40
                                 anchors.right: parent.right
                                 anchors.rightMargin: 20
                                 background: Rectangle {
                                     implicitWidth: 100
                                     implicitHeight: 40
                                     border.color: '#293351'
                                     border.width: 2
                                     radius: 4
                                 }
                             }
                         }
                         Rectangle {
                             anchors.right: parent.right
                             anchors.left: parent.left
                             anchors.bottom: parent.bottom
                             anchors.leftMargin: 20
                             anchors.rightMargin: 20
                             anchors.bottomMargin: 10
                             //                            color: 'red'
                             width: parent.width - 40
                             height: 250
                             Row {
                                 spacing: 10
                                 Rectangle {
                                     width: 364
                                     height: 254
                                     border.color: '#f7f7f7'
                                     border.width: 2
                                     radius: 2
                                     Image {
                                         width: 360
                                         height: 250
                                         source: mainViewSrc
                                         fillMode: Image.PreserveAspectFit
                                         anchors.centerIn: parent
                                     }
                                 }

                                 Rectangle {
                                     width: 364
                                     height: 254
                                     border.color: '#f7f7f7'
                                     border.width: 2
                                     radius: 2
                                     Image {
                                         width: 360
                                         height: 250
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
                 }
            }
        }

        Rectangle {
            id: rightBox
            height: parent.height - 20
            width: 400 - 20
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
                //source: camera
                focus : visible // to receive focus and capture key events when visible
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    videoSrc.startPlay()
                    imageModel.append({'imageIdx': parseInt(Math.random() * 10).toString(), 'time': '2022-09-23, 08:19:05', 'mainViewSrc': './images/demo.jpg', 'sideViewSrc': './images/demo.jpg'})
//                    imageModel.sync()
                    console.log("abc", imageModel.count)
                    while (imageModel.count > 5) {
                        imageModel.remove(0)
                    }

//                    fruitModel.append({"cost": 5.95, "name":"Pizza"})
//                    console.log(fruitModel)
                }
            }
        }
    }
}
