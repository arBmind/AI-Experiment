import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "Model.js" as Model

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Touch Recorder")

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Done"
                onClicked: {
                    touchArea.xxxx.done();
                    canvas.requestPaint();
                    textInput.text = "";
                }
            }
            TextInput {
                Layout.fillWidth: true
                id: textInput

                onTextChanged: {
                    if (text !== "") {
                        touchArea.xxxx.resetInput(text);
                        canvas.requestPaint();
                    }
                }
            }
            Button {
                text: "Upload"
                onClicked: {
                    touchArea.xxxx.sendArchive();
                }
            }
        }

        MultiPointTouchArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: touchArea

            property var xxxx: Model.RecorderModel();

            ListModel {
                id: recorded
            }

            onTouchUpdated: {
                if (touchPoints.length === 0) {
                    xxxx.recordStrokeDone();
                    return;
                }
                xxxx.recordPoint(touchPoints[0]);
                canvas.requestPaint();
            }

            Canvas {
                anchors.fill: parent
                id: canvas

                onPaint: {
                    var ctx = getContext("2d");
                    touchArea.xxxx.paint(ctx, canvas);
                }

            }
        }

    }
}
