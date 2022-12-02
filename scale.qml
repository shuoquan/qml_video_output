import QtQuick 2.0

Rectangle {
    id: wind
    //	visible: true
    width: 640
    height: 480

    Image {
        id: back
        x: 0; y: 0
        source: "./images/camera.png"
    }

    MouseArea {
        id: msArea
        anchors.fill: parent
        drag.target: back

        Component.onCompleted: {
            drag.minimumX = (back.width > wind.width) ? (wind.width - back.width) : 0
            drag.minimumY = (back.height > wind.height) ? (wind.height - back.height) : 0
            drag.maximumX = (back.width > wind.width) ? 0 : (wind.width - back.width)
            drag.maximumY = (back.height > wind.height) ? 0 : (wind.height - back.height)
        }

        onWheel: {
            var datla = wheel.angleDelta.y / 120
            if (datla > 0)
                back.scale = back.scale / 0.9
            else
                back.scale = back.scale * 0.9

            /*
                缩放计算规则：val对应的是back.width和back.height
                缩小：(即back.scale < 1)
                    min:初始值+val*(1-back.scale) / 2
                    max:初始值-val*(1-back.scale) / 2
                放大：(即back.scale > 1)
                    min:初始值-val*(back.scale-1) / 2
                    max:初始值+val*(back.scale-1) / 2
                */
            drag.minimumX = (back.width * back.scale > wind.width) ? (wind.width - back.width - back.width * (back.scale - 1) / 2) : back.width * (back.scale - 1) / 2
            drag.minimumY = (back.height * back.scale > wind.height) ? (wind.height - back.height - back.height * (back.scale - 1) / 2) : back.height * (back.scale - 1) / 2
            drag.maximumX = (back.width * back.scale > wind.width) ? back.width * (back.scale - 1) / 2 : (wind.width - back.width * back.scale) + back.width * (back.scale - 1) / 2
            drag.maximumY = (back.height * back.scale > wind.height) ? back.height * (back.scale - 1) / 2 : (wind.height - back.height * back.scale) + back.height * (back.scale - 1) / 2
        }
    }
}
