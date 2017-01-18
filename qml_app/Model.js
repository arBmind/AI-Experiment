.pragma library

function RecorderModel(sig) {
    function noop() {}

    var archive = [];

    var createItem = noop;
    var finishRecord = noop;
    var finishStroke = noop;
    var addStrokePoint = noop;

    function startRecordFor(text) {
        var startDate = new Date();
        var strokes = [];
        sig.glyphCleared();

        createItem = function(point) {
            return {
                t: (new Date()) - startDate,
                x: point.x,
                y: point.y,
                p: point.pressure
            };
        }

        finishRecord = function() {
            if (text.length !== 0 && strokes.length !== 0) {
                var record = {
                    strokes: strokes,
                    description: text,
                    client: "Qt Recorder"
                };
                archive.push(record);
            }
            startRecordFor("");
        }

        function __addStrokePoint(p) {
            var item = createItem(p);
            var stroke = [item];
            sig.strokeAdded(item);
            addStrokePoint = function(p) {
                var item = createItem(p);
                stroke.push(item);
                sig.strokeAdded(item);
            }
            finishStroke = function() {
                if (stroke.length >= 2) strokes.push(stroke);
                finishStroke = noop;
                addStrokePoint = __addStrokePoint;
                sig.strokeEnded();
            }
        }
        finishStroke = noop;
        addStrokePoint = __addStrokePoint;
    }
    startRecordFor("");

    return {
        sendArchive: function () {
            if (0 === archive.length) return;
            var sendData = {
                archive: archive,
                challenge_id: 0,
                author: "me",
            };

            var load = JSON.stringify({submission: sendData});
            //console.log(load);

            var req = new XMLHttpRequest();
            req.open("POST", "http://127.0.0.1:4000/api/submissions", false);
            req.setRequestHeader("Content-Type", "application/json");
            req.send(load);
            if (req.status === 0) console.log(req.responseText);
            else {
                console.log("success");
                console.log(req.responseText);
            }

            archive = [];
        },
        done: function () { finishRecord(); },
        setText: function (text) {
            startRecordFor(text);
        },
        recordPoint: function (point) { addStrokePoint(point); },
        recordStrokeDone: function () { finishStroke(); },
    };
}
