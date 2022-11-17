import QtQuick 2.15
import QtQuick.Window 2.15
import QtMultimedia 5.14
import QtQuick.Controls 2.15
//import VideoAdapter 1.0

Window {
    title: "开包台"
    minimumWidth: 640
    minimumHeight: 360
//    width: Screen.desktopAvailableWidth
    width: screen.width
    height: screen.height
    visible: true
    visibility: "Maximized"
//    visibility: Window.FullScreen
//    flags:  Qt.FramelessWindowHint
//    maximumWidth: 1200
//    maximumHeight: 720
    property bool fullScreen: true
//    http://192.168.8.173:8256/images
    property string imagePath: ""
    property bool scroll: false
//    flags: fullScreen ? Qt.FramelessWindowHint : Qt.Window

    Component.onCompleted: {
//        console.log(Screen.height, Screen.desktopAvailableWidth, Screen.desktopAvailableHeight)
        video.source = videoSrc
        imagePath = imagePrefix;
        homeSrc.fetchBag(0, -1, 10);
//        homeSrc.fetchBag(12456, -1, 2);
        timer.start();
//        homeSrc.fetchBag(71, 0, 1);
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
        let index = -1;
        let curBagInfo = {};
        for(let i=0; i<imageModel.count; i++) {
            curBagInfo = imageModel.get(i);
            if (curBagInfo.id == bagInfo.id) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            curBagInfo.video_block_path = bagInfo.video_block_path;
            curBagInfo.video_block_name = bagInfo.video_block_name;
            curBagInfo.video_block_width = bagInfo.video_block_width;
            curBagInfo.video_block_height = bagInfo.video_block_height;
            imageModel.set(index, curBagInfo);
        } else {
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
            const maxQueueNum = scroll ? 100 : 10;
//            console.log(scroll, 'ss')
            if (position === 0) {
                imageModel.insert(0, bagInfo);
            } else { 
                if (imageModel.count < maxQueueNum) {
                    imageModel.append(bagInfo);
                }
            }
            while (imageModel.count > maxQueueNum) {
                imageModel.remove(imageModel.count - 1);
            }
//            while (imageModel.count > 10) {
//                if (position === 0) {
//                    imageModel.remove(imageModel.count - 1);
//                } else {
//                    imageModel.remove(0);
//                }
//            }
        }
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
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
            height: Math.min(parent.height / 10, 60)
            color: "#203864"
            Image {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 0.7
                source: './images/company.png'
                fillMode: Image.PreserveAspectFit
                anchors.leftMargin: 0.2 * parent.height
            }
            Rectangle {
                height: parent.height
                width: Math.max(0.2 * parent.width, 400)
//                color: "black"
                color: "#203864"
                anchors.right: parent.right
                anchors.rightMargin: 0.3 * parent.height
                Text {
                    id: time
                    text: ""
                    color: "white"
                    font.pixelSize: Math.min(20,  parent.height / 2)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                }
            }
        }

        Rectangle {
            id: footer
            width: parent.width
            height: Math.min(parent.height / 5 * 0.75, 80)
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
                    color: "white"
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
                    font.pixelSize: setting.height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
        }

        Rectangle {
            id: outer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.bottom: footer.top
//            anchors.fill: parent
            color: '#f7f7f7'
            ScrollView {
                id: leftBox
                anchors.left: outer.left
                anchors.top: outer.top
                height: parent.height - 20
                width: parent.width * 0.7 - 10 // 2/3改为3/4
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
                             id: itemBox
//                             height: parent.width / 2
                             height: parent.width / 3
                             width: parent.width
                             color: '#ffffff'
                             //                    anchors.margins: 10
                             Rectangle {
                                 id: itemTitle
//                                 border.width: 2
//                                 border.color: "red"
                                 anchors.left: parent.left
                                 anchors.right: parent.right
                                 anchors.top: parent.top
                                 anchors.leftMargin: 20
                                 anchors.rightMargin: 20
                                 anchors.topMargin: 10
                                 //                            color: 'red'
                                 width: parent.width - 40
    //                             height: 80
//                                 height:  (parent.width - 40) / 8
                                 height:  (parent.width - 40) / 24
                                 Text {
                                     text: id
    //                                 font.pixelSize: 30
//                                     font.pixelSize: (parent.width - 40) / 24
                                     font.pixelSize: (parent.width - 40) / 48
                                     font.bold: true
                                     anchors.left: parent.left
                                     anchors.verticalCenter: parent.verticalCenter
                                 }
                                 Text {
                                     text: block_create_at
    //                                 font.pixelSize: 20
//                                     font.pixelSize: (parent.width - 40) / 36
                                     font.pixelSize: (parent.width - 40) / 72
                                     font.bold: true
                                     anchors.verticalCenter: parent.verticalCenter
                                     anchors.left: parent.left
                                     anchors.leftMargin: 90
                                 }
                                 Button {
                                     id: unpack
                                     text: '开包记录'
    //                                 font.pixelSize: 18
                                     font.pixelSize: (parent.width - 40) / 60 / 1.5
                                     font.bold: true
                                     anchors.verticalCenter: parent.verticalCenter
                                     //                                width: 100
                                     //                                height: 40
                                     anchors.right: parent.right
                                     anchors.rightMargin: 20
                                     background: Rectangle {
//                                         implicitWidth: 100
//                                         implicitHeight: 40
                                         implicitWidth: (itemBox.width - 40) / 7 / 1.8
                                         implicitHeight: (itemBox.width - 40) / 18 / 2
                                         color: "#3664b1"
//                                         border.color: '#293351'
//                                         border.width: 2
                                         radius: 2
                                     }
                                     contentItem: Text {
                                         text: unpack.text
                                         font.bold: true
                                         font.pixelSize: unpack.font.pixelSize
                                         color: "#ffffff"
                                         horizontalAlignment: Text.AlignHCenter
                                         verticalAlignment: Text.AlignVCenter
                                     }
                                 }
                             }
                             Rectangle {
                                 id: imageArea
                                 anchors.right: parent.right
                                 anchors.left: parent.left
                                 anchors.top: itemTitle.bottom
                                 anchors.leftMargin: 20
                                 anchors.rightMargin: 20
                                 anchors.topMargin: 15
//                                 border.width: 2
//                                 border.color: '#000000'
                                 //                            color: 'red'
                                 width: parent.width - 40
    //                             height: 250
//                                 height: (parent.width - 40) / 3
                                 height: (parent.width - 40) / 4 / 1.1
                                 Row {
                                     spacing: 10
                                     Rectangle {
    //                                     width: 364
    //                                     height: 254
                                         width: (imageArea.width - 30) / 2 + 4
//                                         height: (imageArea.width - 30) / 3 + 4
                                         height: (imageArea.width - 30) / 5 * 1.1 + 4
                                         border.color: '#f7f7f7'
                                         border.width: 2
                                         radius: 2
                                         Image {
                                             id: image
    //                                         width: 360
    //                                         height: 250
                                             width: (imageArea.width - 30) / 2
//                                             height: (imageArea.width - 30) / 3
                                             height: (imageArea.width - 30) / 5 * 1.1
                                             sourceSize.width: block_width
                                             sourceSize.height: block_height
                                             sourceClipRect: Qt.rect(x0,y0,x1-x0,y1-y0)
    //                                         source: "file:///" + block_path
                                             source: imagePath + block_path
                                             fillMode: Image.PreserveAspectFit
                                             anchors.centerIn: parent

                                             Component.onCompleted:   {
                                                 const heightRatio = image.height / (y1-y0);
                                                 const widthRatio = image.width / (x1-x0);
                                                 const ratio = Math.min(widthRatio, heightRatio);
                                                 const unpackBoxList = JSON.parse(unpackBoxInfoList);
                                                 homeSrc.printLog(`比例信息:heightRatio:${heightRatio}:widthRatio:${widthRatio}`);
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
                                                         // 超出区局部分不显示
                                                         if (leftTopX<x0 || leftTopY < y0 || rightBottomX > x1 || rightBottomY > y1) {
                                                             continue;
                                                         }

                                                         if (heightRatio < widthRatio) {
//                                                             console.log('1x')
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
//                                                             console.log('2x')
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
//                                         height: (imageArea.width - 30) / 3 + 4
                                         height: (imageArea.width - 30) / 5 * 1.1 + 4
                                         border.color: '#f7f7f7'
                                         border.width: 2
                                         radius: 2
                                         Image {
    //                                         width: 360
    //                                         height: 250
                                             width: (imageArea.width - 30) / 2
//                                             height: (imageArea.width - 30) / 3
                                             height: (imageArea.width - 30) / 5 * 1.1
    //                                         source: "file:///" + video_block_path
                                             source: imagePath + video_block_path
                                             fillMode: Image.PreserveAspectFit
                                             anchors.centerIn: parent
                                             visible: !!video_block_path
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
//                             console.log(contentY, contentHeight, height, 'ddd', originY)
                             // 不再严格相等，允许误差
                             // contentHeight > height && contentY - originY == contentHeight - height
                             if (contentHeight > height && Math.abs(contentY - originY - contentHeight + height) < 10 ** -5) {
                                 homeSrc.printLog("到达底端");
//                                 console.log('getFromBottom-------');
    //                             insertDirection = -1;
                                 // 超过100不再显示
                                 if (imageModel.count < 100) {
                                     homeSrc.fetchBag(imageModel.get(imageModel.count - 1).id, -1, 10);
                                 }
                             }
                             if (contentY == 0 || Math.abs(contentY - originY) < 10 ** -5) {
                                 homeSrc.printLog("到达顶端");
//                                 console.log('getFromTop----');
    //                             insertDirection = 0;
                                 homeSrc.fetchBag(imageModel.get(0).id, 1, 10);
                                 scroll = false;
                                 if (imageModel.count > 10) {
                                     imageModel.remove(10, imageModel.count - 10);
                                 }
                             }

                             if (Math.abs(contentY - originY - height) > 10 ** -5) {
                                 scroll = true;
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
                width: (parent.width) * 0.3 - 20
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
}
