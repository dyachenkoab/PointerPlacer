import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0
import QtLocation 5.6
import QtPositioning 5.6

Window {
    id: mainWindow
    width: 512
    height: 512
    visible: true

    property string tempCoord

    Connections {
        target:FileReader
        function onSendString(lst) {
            tempCoord = lst
        }
    }

        MapModule {
            id: rButton
            anchors.fill: parent
        }

        Button {
            id: jsonButton
            text: "SAVE"
            opacity: 0.7
            anchors.left: rButton.left
            onPressed: { saveDialog.visible = true }
        }

        Button {
            id: readButton
            text: "READ"
            opacity: 0.7
            x: 0
            y: 50
            onPressed: { openDialog.visible = true }
        }

        Button {
            id: setButton
            text: "SET"
            opacity: 0.7
            property var pointed
            x: 0
            y: 100
            onPressed: {
                var length = FileReader.coordinates.length
                for (var i = 0; i < length ; i+=2) {
                    pointed = QtPositioning.coordinate(FileReader.coordinates[i], FileReader.coordinates[i+1])
                    rButton.addMark(pointed)
                }
            }
        }

        Button {
            id: sendButton
            text: "SEND"
            opacity: 0.7
            x: 0
            y: 150
            onPressed: {
                FileReader.send()
                rButton.place(tempCoord)
            }
        }

        FileDialog {
                id: openDialog
                visible: false
                title: "open"
                folder: "file:/home/"
                nameFilters: ["All files (*)"]
                onAccepted: { FileReader.readFile(fileUrl) }
        }

        FileDialog {
                id: saveDialog
                visible: false
                title: "save"
                selectFolder: true
                folder: "file:/home/"
                nameFilters: ["All files (*)"]
                onAccepted: { FileReader.saveToJson(folder) }
        }
    }
