import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "Model.js" as Model

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Touch Recorder")

    ModelSignals {
        id: sig
        onStrokeAdded: strokeView.paintTo(p);
        onStrokeEnded: strokeView.endStroke();
        onGlyphCleared: strokeView.clear();
    }

    property var model: Model.RecorderModel(sig);

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Done"
                onClicked: {
                    model.done();
                    textInput.text = "";
                    textInput.focus = true;
                }
            }
            TextInput {
                Layout.fillWidth: true
                id: textInput
                focus: true

                onTextChanged: model.setText(text)
            }
            Button {
                text: "Upload"
                onClicked: model.sendArchive();
            }
        }

        MultiPointTouchArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: touchArea

            onTouchUpdated: {
                if (touchPoints.length === 0) model.recordStrokeDone();
                else model.recordPoint(touchPoints[0]);
            }

            StrokeView {
                anchors.fill: parent
                id: strokeView
            }
        }
    }
}
