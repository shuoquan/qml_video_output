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

    Row {
        id: row
        spacing: 10

        Rectangle {
            width: 800
            height: 720
            color: '#f7f7f7'
            Column {
                id: column
                anchors.fill: parent
                spacing: 10
                ListModel {
                    id: imageModel

                    ListElement {
                        name: "Apple"
                        cost: 2.45
                    }
                }
                Component {
                    id: imageDelegate
                    Column {
                        Rectangle {
                            height: 50
                            width: 720
                            Row {
                                spacing: 12
                                Text {
                                    text: "1005"
                                    font.pixelSize: 30
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "2022-09-23, 08:19:05"
                                    font.pixelSize: 16
                                    font.bold: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Button {
                                    text: '开包检查'
                                    anchors.verticalCenter: parent.verticalCenter
                                    // background: Rectangle {
                                    //     color: Qt.rgba(1, 1, 1, 1)
                                    // }
                                    // anchors.right: parent.right
                                }
                            }
                        }
                        Row {
                            spacing: 10
                            leftPadding: 30
                            Image {
                                width: 360
                                height: 300
                                source: './images/demo.jpg'
                            }
                            Image {
                                width: 360
                                height: 300
                                source: './images/demo.jpg'
                            }
                        }
                    }
                }

                ListView {
                    anchors.fill: parent
                    model: imageModel
                    delegate: imageDelegate
                }

                Component.onCompleted: {
                    console.log("onCompleted", imageModel.count);
                    // fruitModel.append({
                    //     name: "Pear",
                    //     cost: 2.25
                    // });
                }
            }

        }

        Rectangle {
            id: rectVideoOutput
            width: 400
            height: 720
            color: '#f7f7f7'

            VideoOutput {
                id: video
                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fillMode: VideoOutput.PreserveAspectFit
                //source: camera
                focus : visible // to receive focus and capture key events when visible
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    videoSrc.startPlay()
                }
            }
        }

        //        Rectangle {
        //            width: 400
        //            height: 720
        //            // AnimatedSprite {
        //            //     id: sideImage
        //            //     width: 360
        //            //     height: 300
        //            //     source: './images/demo.jpg'
        //            //     frameDuration: 16
        //            // }
        //            VideoOutput {
        //                anchors.fill: parent
        //                source: camera
        //            }
        //            //摄像头元素
        //            Camera {
        //                id: camera
        //            }
        //        }
    }
}
