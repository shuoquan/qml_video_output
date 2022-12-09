import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import VideoAdapter 1.0

Window {
    id: root
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
    property bool loginPage: true
    property int pageState: 1  // 页面状态 1-首页, 2-登记页面， 3-统计页面， 4-详情页面
    property string username: ""
    property bool nextEnable: true
    signal dealStack()
    signal getNext()
    //    http://192.168.8.173:8256/images
    //    flags: fullScreen ? Qt.FramelessWindowHint : Qt.Window

    Component.onCompleted: {
        timer.start();
//        content.push('./home.qml');
//        loginPage = false;
                content.push('./login.qml');
    }

    Connections {
        target: homeSrc
        function onNavigatePage(state, params) {
            //            back.visible = false;
            console.log(pageState, params, 'page', state)
            const obj = JSON.parse(params || '{}');
            if (state == 2) {
                console.log("getBagId", obj['id'])
                content.push('./identity.qml', {bagInfo: obj});
                search.source = './images/new-home.png';
                searchText.text = "返回";
                setting.source = "./images/next.png";
                settingText.text = "下一个";
                pageState = 2;
                nextEnable = true;
            } else if (state == 1) {
                content.push('./home.qml');
                username = obj['username'];
                loginPage = false;
                pageState = 1;
            } else if (state == 3) {
                const item = content.push('./BagRecord.qml');
                search.source = './images/new-home.png';
                searchText.text = "返回";
//                StackView子组件传递信号案例
//                item.compTest.connect(onCompTest);
                pageState = 3;
            } else if (state == 4) {
                content.push('./BagDetail.qml', {bagInfo: obj});
                pageState = 4;
            }
        }
        function onModifyOpacity(opacity) {
            //                        console.log("receive", opacity);
            mainOpacity = opacity;
        }
        function onModifyNextStatus(flag) {
            console.log(flag, 'onModifyNextStatus');
            if (pageState == 2) {
                nextEnable = flag;
                setting.source = flag ? "./images/next.png" :  "./images/next-dark.png"
            }
        }
    }
    // StackView子组件传递信号案例
//    function onCompTest(msg) {
//        console.log(msg, 'sssss');
//    }

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
            //            time.text = `${new Date().getFullYear()}-${(new Date().getMonth() + 1).toString().padStart(2, '0')}-${new Date()
            //            .getDate()
            //            .toString()
            //            .padStart(2, '0')} 星期${dayMap[new Date().getDay()]} ${new Date()
            //            .getHours()
            //            .toString()
            //            .padStart(2, '0')}:${new Date().getMinutes().toString().padStart(2, '0')}:${new Date()
            //            .getSeconds()
            //            .toString()
            //            .padStart(2, '0')}`;

            time.text = `${new Date()
            .getHours()
            .toString()
            .padStart(2, '0')}:${new Date().getMinutes().toString().padStart(2, '0')}:${new Date()
            .getSeconds()
            .toString()
            .padStart(2, '0')}      开包员:   ${username}`;
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
        MouseArea {
            anchors.fill: parent
            onClicked: {
                //                back.visible = false;
            }
        }

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
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('change page', pageState)
                        if (pageState == 2) {
                            pageState = 1;
                            search.source = './images/search.jpg';
                            searchText.text = "查询";
                            setting.source = "./images/setting.jpg";
                            settingText.text = "设置";
                            content.pop()
                            //                            dealStack()
                        } else if (pageState == 3) {
                            pageState = 1;
                            search.source = './images/search.jpg';
                            searchText.text = "查询";
                            content.pop();
                        } else if (pageState == 4) {
                            pageState = 3;
                            content.pop();
                        }
                    }
                }
            }
            Rectangle {
                id: line
                anchors.left: leftArea.right
                width: 2
                height: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter
                visible: pageState == 1
            }
            Rectangle {
                id: statisticArea
                height: parent.height
                anchors.left: line.right
                color: "#3664b1"
                width: Math.max(parent.width / 12, 100)
                visible: pageState == 1
                Image {
                    id: statisticPic
                    anchors.left: parent.left
                    anchors.leftMargin: (statisticArea.width - 10 - statisticPic.width - statisticText.width) / 2
                    height: parent.height / 2.5
                    source: './images/statistic.png'
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: statisticText
                    anchors.left: statisticPic.right
                    anchors.leftMargin: 10
                    text: "统计"
                    color: "white"
                    font.family: "微软雅黑"
                    font.pixelSize: statisticPic.height / 2 * 1.25
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('go to statistic page')
                        if (pageState == 1) {
                            homeSrc.goToPage(3);
                        }
                    }
                }
            }

            Rectangle {
                id: rightArea
                height: parent.height
                anchors.right: parent.right
                color: "#3664b1"
                width: Math.max(parent.width / 12, 100)
                visible: pageState != 3
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
                    color: pageState == 2 && !nextEnable ? "#bfbfbf" : "#fff"
                    font.family: "微软雅黑"
                    font.pixelSize: setting.height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (pageState == 2) {
                            console.log('get next')
                            getNext();
                        } else if (pageState == 1) {
                            //                            back.visible = true;
                            backPopup.open();
                        }
                    }
                }
            }
            Popup {
                id: backPopup
                //                parent: Overlay.overlay
                x: parent.width - rightArea.width
                y:  0 - rightArea.height * 3
                width: rightArea.width
                height: rightArea.height * 3
                background: Rectangle {
                    //                    color: "red"
                }
                padding: 0

                Rectangle {
                    anchors.fill: parent
                    id: back
                    width: rightArea.width
                    height: rightArea.height * 3
                    anchors.right: parent.right
                    anchors.bottom: footer.top
                    //                    visible: false
                    //                    z: 3
                    Rectangle {
                        width: parent.width - 2
                        height: parent.height - 2
                        anchors.centerIn: parent
                        color: "#DBE8F9"
                        Rectangle {
                            id: backArea
                            anchors.left: parent.left
                            height: parent.height / 3
                            width: parent.width
                            anchors.top: parent.top
                            color: "transparent"
                            //                    color: "green"
                            Rectangle {
                                width: parent.width / 3
                                height: parent.height
                                anchors.left: parent.left
                                //                        color: "red"
                                color: "transparent"
                                Image {
                                    anchors.left: parent.left
                                    //                                    height: parent.height / 4
                                    source: './images/logout.png'
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                }
                            }

                            Rectangle {
                                width: parent.width / 3 * 2
                                height: parent.height
                                anchors.right: parent.right
                                //                        color: "green"
                                color: "transparent"
                                Text {
                                    text: '退出'
                                    //                            anchors.centerIn: parent
                                    font.family: "微软雅黑"
                                    font.pixelSize: parent.height / 4
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: parent.width / 6
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (pageState == 1) {
                                        content.pop();
                                        backPopup.close()
                                        loginPage = true;
                                        console.log('goout')
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: blankLine
                            width: parent.width * 0.9
                            height: 2
                            anchors.top: backArea.bottom
                            //                    anchors.left: parent.left
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        StackView {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: footer.top
            pushEnter: Transition {

            }
            pushExit: Transition {

            }
            popEnter: Transition {

            }
            popExit: Transition {

            }
            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }

            //            Connections {
            //                target: root
            //                function onDealStack() {
            //                    console.log('aasfs', content.depth)
            //                    content.pop();
            //                }
            //            }

            //            function onRegisterBag(bagId) {
            //                console.log("getBagId", bagId)
            //                content.push('./identity.qml');
            //                search.source = './images/new-home.png';
            //                searchText.text = "返回";
            //                setting.source = "./images/next.png";
            //                settingText.text = "下一个";
            //                pageState = 2;
            //            }

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
                //                source: './BagDetail.qml'
                //                source: './scroll.qml'
                Connections {
                    target: loader.item
                    ignoreUnknownSignals: true
                    function onModifyOpacity(opacity) {
                        //                        console.log("receive", opacity);
                        mainOpacity = opacity;
                    }
                    function onLoginSuccess(status) {
                        console.log(status)
                        if (status) {
                            loginPage = false;
                            loader.source = './home.qml';
                        }
                    }
                    function onRegisterBag(bagId) {
                        console.log("getBagId", bagId)
                        content.push('./identity.qml');
                        search.source = './images/new-home.png';
                        searchText.text = "返回";
                        setting.source = "./images/next.png";
                        settingText.text = "下一个";
                        pageState = 2;
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
