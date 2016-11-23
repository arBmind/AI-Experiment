.pragma library

function RecorderModel() {
    var startDate = new Date();
    var archive = [];
    var activeRecord = null;
    var activeStrokes = [];
    var activeStroke = null;

    function createRecord(text) {
        activeRecord = {
            strokes: [],
            description: text,
            client: "Qt Recorder"
        };
        startDate = new Date();
        activeStrokes = activeRecord.strokes;
    }

    function theActiveStroke() {
        if (null === activeStroke) {
            activeStroke = [];
            activeStrokes.push(activeStroke);
        }
        return activeStroke;
    }

    function finishRecord() {
        if (null === activeRecord) return;
        if (0 !== activeStrokes.length && 0 !== activeStrokes[0].length) {
            archive.push(activeRecord);
        }
        activeRecord = null;
        activeStrokes = [];
        activeStroke = null;
    }

    return {
        sendArchive: function () {
            if (0 === archive.length) return;
            var load = JSON.stringify(archive);
            // TODO
            archive = [];
        },
        done: finishRecord,
        resetInput: function (text) {
            finishRecord();
            createRecord(text);
        },
        recordPoint: function (point) {
            var date = new Date();
            var item = {
                t: date - startDate,
                x: point.x,
                y: point.y,
                p: point.pressure
            };
            theActiveStroke().push(item);
        },
        recordStrokeDone: function () {
            activeStroke = null;
        },
        paint: function (ctx, canvas) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            activeStrokes.forEach(function(stroke) {
                if (stroke.length === 0) return;
                ctx.beginPath();
                ctx.moveTo(stroke[0].x, stroke[0].y);
                for (var i = 1; i < stroke.length; ++i) {
                    ctx.lineTo(stroke[i].x, stroke[i].y);
                }
                ctx.stroke();
            });
        }
    };
}
