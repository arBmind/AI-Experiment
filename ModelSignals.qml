import QtQuick 2.7
import "Model.js" as Model

QtObject {
    id: root

    signal strokeAdded(var p)
    signal strokeEnded()
    signal glyphCleared()
}
