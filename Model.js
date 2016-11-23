.pragma library

function RecorderModel() {
    var startDate = new Date();
    var archive = [];
    var recorded = [];
    var activeStroke = null;
    var activeRecord = null;

    function createRecord(text) {
        activeRecord = {
            strokes: [],
            description: text,
            client: "Qt Recorder"
        };
        recorded = activeRecord.strokes
    }

    function theActiveStroke() {
        if (null === activeStroke) {
            activeStroke = [];
            recorded.push(activeStroke);
        }
        return activeStroke;
    }

    function finishRecord() {
        if (null === activeRecord) return;
        if (0 === recorded.length || 0 === recorded[0].length) return;
        archive.push(activeRecord);
        activeRecord = null;
        recorded = null;
        activeStroke = null;
    }


    return {
        sendArchive: function () {
           // TODO
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
           //console.log(JSON.stringify(recorded));
        },
        recordStrokeDone: function () {
           activeStroke = null;
        },
        paint: function (ctx, canvas) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            if (null === recorded) return;
            recorded.forEach(function(stroke) {
               if (stroke.length === 0)
                   return;
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


















