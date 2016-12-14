import QtQuick 2.7

Canvas {
    id: root
    property var toPaint: [[]]
    property bool toClear: false

    function paintTo(p) {
        toPaint[toPaint.length-1].push(p);
        root.requestPaint();
    }
    function endStroke() {
        if (toPaint.length !== 0) toPaint.push([]);
    }
    function clear() {
        toClear = true;
        toPaint = [[]];
        root.requestPaint();
    }

    renderStrategy: Canvas.Threaded
    //renderTarget: Canvas.FramebufferObject

    onPaint: {
        var ctx = getContext("2d");
        if (toClear) {
            toClear = false;
            ctx.clearRect(0, 0, width, height);
        }
        toPaint.forEach(function(stroke) {
            if (stroke.length < 2) return;
            ctx.beginPath();
            ctx.moveTo(stroke[0].x, stroke[0].y);
            for (var i = 1; i < stroke.length; ++i) {
                ctx.lineTo(stroke[i].x, stroke[i].y);
            }
            ctx.stroke();
        });
        if (toPaint.length > 0 && toPaint[toPaint.length - 1].length > 0)
            toPaint = [[toPaint[toPaint.length - 1][toPaint[toPaint.length - 1].length - 1]]];
        else
            toPaint = [[]];
    }

}
