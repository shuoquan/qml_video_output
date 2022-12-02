import QtQuick 2.0

Canvas {
    id: canvasId
    property color triangleColor: "#A6A6A6"
    width: parent.height / 3; height: parent.height / 3
    contextType: "2d"

    onPaint: {
        context.lineWidth = 0
        context.strokeStyle = "#00000000"
        context.fillStyle = triangleColor
        context.beginPath();
        context.moveTo(0, 0)
        context.lineTo(canvasId.width, 0);
        context.lineTo(canvasId.width / 2, canvasId.height);
        context.closePath();
        context.fill()
        context.stroke();
    }
}

