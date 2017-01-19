import QtQuick 2.0

ListModel {
    id: root

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    property variant jsonData: ({})

    function reload() {
        root.clear();
        var req = new XMLHttpRequest;
        req.open("GET", "http://127.0.0.1:4000/api/challenges");
        req.onreadystatechange = function() {
            status = req.readyState;
            if (req.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(req.responseText);
                if (jsonResponse.error !== undefined) {
                    console.log("error: " + jsonResponse.error);
                    return;
                }
                if (wasLoading == true) root.isLoaded();
                jsonData = jsonResponse.challenges;
                for (var i = 0, len = jsonResponse.challenges.length; i < len; i++) {
                    var challenge = jsonResponse.challenges[i];
                    root.append(challenge);
                }
            }
            wasLoading = (req.readyState === XMLHttpRequest.LOADING);
        }
        req.send();
    }

    Component.onCompleted: {
        reload();
    }
}
