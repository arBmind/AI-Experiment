import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "Model.js" as Model

ApplicationWindow {
    visible: true
    width: 480
    height: 800
    title: qsTr("Touch Recorder")

    StackView {
        id: stack
        initialItem: welcomeView
        anchors.fill: parent
    }

    ChallengeModel { id: challenges }

    Component {
        id: welcomeView

        Page {
            header: ToolBar {
                Label {
                    padding: 10
                    text: qsTr("Challenges")
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ListView {
                id: listView
                anchors.fill: parent
                spacing: 0
                model: challenges
                delegate: ItemDelegate {
                    text: name
                    font.pixelSize: 16
                    height: 50
                    bottomPadding: 30
                    width: listView.width - listView.leftMargin - listView.rightMargin
                    onClicked: startRecorder(index);

                    Text {
                        anchors.fill: parent
                        anchors.topMargin: 30
                        anchors.leftMargin: 30
                        anchors.rightMargin: 30

                        text: details
                        clip: true
                        font.pixelSize: 12
                    }
                }

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }

    property variant activeChallenge
    property int activeIndex: 0

    function startRecorder(index) {
        activeChallenge = challenges.jsonData[index];
        activeIndex = 0;
        stack.push(recordView);
    }

    Component {
        id: recordView

        Page {
            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    ToolButton {
                        text: "\uD83D\uDD19"
                        font.pixelSize: 30
                        onClicked: stack.pop()
                    }
                    Label {
                        Layout.fillWidth: true
                        padding: 10
                        text: activeChallenge.name + " " + (activeIndex+1) + "/" + (activeChallenge.description_set.length)
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            ModelSignals {
                id: sig
                onStrokeAdded: strokeView.paintTo(p);
                onStrokeEnded: strokeView.endStroke();
                onGlyphCleared: strokeView.clear();
            }
            property var recorderModel: Model.RecorderModel(sig);


            function recordNext() {
                recorderModel.done();
                if (activeIndex + 1 === activeChallenge.description_set.length) {
                    recorderModel.sendArchive(activeChallenge.id, cppHostName);
                    stack.pop();
                    return;
                }
                activeIndex++;
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 16
                        padding: 10

                        text: "Draw: " + activeChallenge.description_set[activeIndex]
                        onTextChanged: recorderModel.setText(text)
                    }
                    Button {
                        font.pixelSize: 16
                        text: (activeIndex + 1 === activeChallenge.description_set.length) ? "Submit" : "Next"
                        onClicked: recordNext();
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: "black"
                }

                MultiPointTouchArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: touchArea

                    onTouchUpdated: {
                        if (touchPoints.length === 0) recorderModel.recordStrokeDone();
                        else recorderModel.recordPoint(touchPoints[0]);
                    }

                    StrokeView {
                        anchors.fill: parent
                        id: strokeView
                    }
                }
            }
        }
    }

}
