import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQml 2.15

Rectangle {
    anchors.fill: parent
    Rectangle {
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent
        color: "yellow"
        ScrollView {
            anchors.fill: parent
            clip: true
//            ColumnLayout {

//            }
        }
    }
}
