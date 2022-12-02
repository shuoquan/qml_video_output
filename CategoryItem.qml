import QtQuick 2.0


Rectangle {
    property string categoryName: ''
//    width: 100
//    height: 100
//    color: 'red'
    Text {
        text: categoryName
        anchors.centerIn: parent
        font.family: "微软雅黑"
        font.pixelSize: parent.width / 3
    }
}
