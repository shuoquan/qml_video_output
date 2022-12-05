import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import VideoAdapter 1.0

Window {
    title: " "
    minimumWidth: 1280
    minimumHeight: 720
//    width: Screen.desktopAvailableWidth
    width: screen.width
    height: screen.height
    visible: true
    visibility: "Maximized"
//    visibility: Window.FullScreen
//    flags:  Qt.FramelessWindowHint
//    maximumWidth: 1200
//    maximumHeight: 720
//    property int count: 0
    property bool fullScreen: true
    property double mainOpacity: 1
    property bool loginPage: false
//    http://192.168.8.173:8256/images
//    flags: fullScreen ? Qt.FramelessWindowHint : Qt.Window

    Component.onCompleted: {
        timer.start();
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
//            homeSrc.printLog("aaaaa");
            const dayMap = {
                '0': '日',
                '1': '一',
                '2': '二',
                '3': '三',
                '4': '四',
                '5': '五',
                '6': '六',
            }

//            console.log(new Date().getDay(), '----')
            time.text = `${new Date().getFullYear()}-${(new Date().getMonth() + 1).toString().padStart(2, '0')}-${new Date()
            .getDate()
            .toString()
            .padStart(2, '0')} 星期${dayMap[new Date().getDay()]} ${new Date()
            .getHours()
            .toString()
            .padStart(2, '0')}:${new Date().getMinutes().toString().padStart(2, '0')}:${new Date()
            .getSeconds()
            .toString()
            .padStart(2, '0')}`;
            // http://192.168.7.25:8256/images//core7/data2/dingshuoquan/images/jms_gj_2_20220106_112704_18461_01.jpg
//            if (count > 1) {
//                const bag = imageModel.get(0);
//                bag.block_path = '/core10/data2/images/raw_data/xm_tb_hs_1/202211/19/xm_tb_hs_34_20221119_060956_00000.jpg';
//                bag.block_width = 544;
//                bag.block_height = 636;
//                bag.bag_coordinate = '(0, 0),(362, 360)';
//                bag.unpackBoxInfoList = '[{"box":"{\\"((120,120),(150,150))\\"}", "type": 1}]';
//                imageModel.set(0, bag);
//            }
//            count += 1;

//            console.log(JSON.stringify(bag), 'xx');
//            time.text = `${new Date().getFullYear().toString()}-${(new Date().getMonth() + 1).toString().padStart(2, '0')} +
//                               '-' +
//                               ${new Date().getDate().toString().padStart(2, '0')} +
//                               ' ' +
//                               ${new Date().getHours().toString().padStart(2, '0')} +
//                               ':' +
//                               ${new Date().getMinutes().toString().padStart(2, '0')} +
//                               ':' +
//                               ${new Date().getSeconds().toString().padStart(2, '0')}`;
        }
    }

    Rectangle {
//        visible: false
        anchors.fill: parent
        opacity: mainOpacity
//        Keys.enabled: true
//        focus: true

//        Keys.onPressed: {
//            switch (event.key) {
//                case 16777216:
//                    fullScreen = false;
//                    break;
//                case 16777274:
//                    fullScreen = !fullScreen;
//                    break;
//                case 16777329:
//                    fullScreen = !fullScreen;
//                    break;
//                default:
//                    break;
//            }
//        }

        Rectangle {
            id: header
            width: parent.width
            height: loginPage ? 0 : 60
//            height: Math.min(parent.height / 12, 40)
            color: "#203864"
            Image {
                anchors.left: parent.left
                anchors.top: parent.top
//                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.6
                source: './images/company.png'
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 0.4 * parent.height
            }
//            Rectangle {
//                id: productBox
//                height: parent.height
//                width: Math.max(0.2 * parent.width, 400)
////                color: "black"
//                color: "#203864"
//                anchors.right: parent.right
//                anchors.rightMargin: (parent.width - productBox.width) / 2
////                opacity: mainOpacity
//                Text {
////                    width: parent.width
//                    height: parent.height
//                    id: productName
//                    text: "智能查危登记系统"
//                    font.family: "微软雅黑"
//                    color: "#fff"
//                    font.pixelSize: 28
//                    font.bold: true
////                    font.pixelSize: Math.min(20,  parent.height / 2)
////                    anchors.topMargin: 0.2 * parent.height
//                    anchors.top: parent.top
////                    anchors.topMargin: 0.06 * parent.height
//                    anchors.horizontalCenter: parent.horizontalCenter
////                    anchors.right: parent.right
//                }
//            }
            Text {
                height: parent.height
                id: productName
                text: "智能查危登记系统"
                font.family: "微软雅黑"
                color: "#fff"
                font.pixelSize: 28
                font.bold: true
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
//            Rectangle {
//                height: parent.height
//                width: Math.max(0.2 * parent.width, 400)
////                color: "black"
//                color: "#203864"
//                anchors.right: parent.right
//                anchors.rightMargin: 0.4 * parent.height
//                Text {
//                    id: time
//                    text: ""
//                    color: "#fff"
//                    font.pixelSize: 18
//                    font.family: "微软雅黑"
////                    font.pixelSize: Math.min(16,  parent.height / 2 * 0.8)
//                    anchors.topMargin: 0.2 * parent.height
//                     anchors.top: parent.top
////                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.right: parent.right
//                }
//            }
            Text {
                id: time
                text: ""
                color: "#fff"
                font.pixelSize: 18
                font.family: "微软雅黑"
                anchors.topMargin: 0.2 * parent.height
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.rightMargin: 0.4 * parent.height
            }
        }

        Rectangle {
            id: footer
            width: parent.width
            height: loginPage ? 0 : Math.min(parent.height / 5 * 0.75, 80)
            color: "#203864"
            anchors.bottom: parent.bottom
            Rectangle {
                id: leftArea
                height: parent.height
                anchors.left: parent.left
                color: "#3664b1"
                width: Math.max(parent.width / 12, 100)
                Image {
                    id: search
                    anchors.left: parent.left
                    anchors.leftMargin: (leftArea.width - 10 - search.width - searchText.width) / 2
                    height: parent.height / 2
                    source: './images/search.jpg'
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: searchText
                    anchors.left: search.right
                    anchors.leftMargin: 10
                    text: "查询"
                    color: "#fff"
                    font.family: "微软雅黑"
                    font.pixelSize: search.height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
            Rectangle {
                id: rightArea
                height: parent.height
                anchors.right: parent.right
                color: "#3664b1"
                width: Math.max(parent.width / 12, 100)
                Image {
                    id: setting
                    anchors.left: parent.left
                    anchors.leftMargin: (rightArea.width - 10 - setting.width - settingText.width) / 2
                    height: parent.height / 2
                    source: './images/setting.jpg'
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: settingText
                    anchors.left: setting.right
                    anchors.leftMargin: 10
                    text: "设置"
                    color: "white"
                    font.family: "微软雅黑"
                    font.pixelSize: setting.height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
        }

        Rectangle {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: footer.top
            Loader {
                id: loader
                anchors.fill: parent
//                sourceComponent: comp
//                source: './home.qml'
//                source: './identity.qml'
//                source: './scale.qml'
//                source: './login.qml'
//                source: './rotate.qml'
//                source: './BagRecord.qml'
                source: './BagDetail.qml'
                Connections {
                    target: loader.item
                    ignoreUnknownSignals: true
                    function onModifyOpacity(opacity) {
//                        console.log("receive", opacity);
                        mainOpacity = opacity;
                    }
                }
            }
        }
//        Component {
//            id: comp
//            Rectangle {
//                width: 30
//                height: 30
//                color: "red"
//                signal modifyOpacity(double opacity)
//                MouseArea {
//                    anchors.fill: parent

//                    onClicked: {
//                        console.log("11111")
//                        modifyOpacity(0.2);
//                    }
//                }
//            }
//        }
    }
}
