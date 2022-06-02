import QtQuick
import Qt.labs.platform as Native


Native.MenuBar {
    id: menuBarView
    Native.Menu {
        title: qsTr("&File")
        Native.MenuItem {
            text: qsTr("&New")
            icon.name: "document-new"
            onTriggered: mainView.newDocument()
        }
        Native.MenuSeparator {}
        Native.MenuItem {
            text: qsTr("&Open...")
            icon.name: "document-open"
            onTriggered: fileOpenDialog.open()
        }
        Native.MenuItem {
            text: qsTr("&Save")
            icon.name: "document-save"
            onTriggered: saveDocument()
        }
        Native.MenuItem {
            text: qsTr("Save &As...")
            icon.name: "document-save-as"
            onTriggered: saveAsDocument()
        }
    }
    Native.Menu {
        title: qsTr("&Help")
        Native.MenuItem {
            text: qsTr("&About")
            onTriggered: aboutDialog.open()
        }

    }
    Native.FileDialog {
        id: saveAsDialog
        title: "Save As"
        folder: Native.StandardPaths.writableLocation(Native.StandardPaths.DocumentsLocation)
        onAccepted: {
            root.fileName = saveAsDialog.file
            saveDocument();
        }
        onRejected: {
            root.tryingToClose = false;
        }
    }
}

