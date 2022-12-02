import QtQuick 2.0

Item {
    width: 300; height: 300

    Rectangle {
        id: rect
        width: 150; height: 100; anchors.centerIn: parent
        color: "red"
        antialiasing: true

        states: State {
            name: "rotated"
            PropertyChanges { target: rect; rotation: 180 }
        }

        transitions: Transition {
            RotationAnimation { duration: 500; direction: RotationAnimation.Counterclockwise }
        }
    }

    MouseArea { anchors.fill: parent; onClicked: {
            console.log(rect.state)
            if(rect.state == "rotated"){
                rect.state = "unrotated"
            } else {
                rect.state = "rotated"
            }
        } }
}
