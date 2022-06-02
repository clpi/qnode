import QtQuick 2.0
import "pages"
import "comp"
import "models"
import QtQuick.LocalStorage
import QtQuick.Layouts 1.11
import QtQuick.Controls
import QtQuick.Window 2.1
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import QtQuick.Timeline 1.0
import QtQuick.Controls.Material 2.1
import Qt.labs.platform as Native

import io.qt.textproperties 1.0



ApplicationWindow {
    id: mainView
    title: qsTr("IDP")
    width: 800
    height: 500
    visible: true
    // flags: Qt.Window | Qt.FramelessWindowHint

    Material.theme: Material.Light
    Material.accent: Material.Red

    property bool hasChanges: false
    property bool tryingToClose: false
    property string fileName

    // Component.onCreated: {
    //     console.log("Created main")
    // }

    header: ToolBar {
        Material.background: Material.Blue
        contentHeight: toolButton.implicitHeight
        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
            font.pixelSize: 20
            elide: Label.ElideRight
        }
        Flow {
            anchors.fill: parent
            // ToolButton {
            //     id: menuButton
            //     anchors.left: parent.right
            //     anchors.verticalCenter: parent.verticalCenter
            //     icon.source: "images/baseline-menu-24px.svg"
            //     text: qsTr("<<")
            //     onClicked: drawer.open()
            // }
            ToolButton {
                id: toolButton
                text: stackView.depth > 1 ? "\u25C0" : "\u2630"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                    } else {
                        drawer.open()
                    }
                }
            }
            ToolButton {
                text: qsTr("New")
                icon.name: "document-new"
                onClicked: drawer.open()
            }
            ToolButton {
                text: qsTr("Save")
                icon.name: "document-save"
                onClicked: fileOpenDialog.open()
            }
            ToolButton {
                text: qsTr("Open")
                icon.name: "document-open"
                onClicked: fileOpenDialog.open()
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: menu.open()
            }
        }
    }

    footer: ToolBar {
        Material.background: Material.Blue
        contentHeight: 20
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stack.pop()
            }
            Label {
                text: "Title"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: menu.open()
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&New")
                icon.name: "document-new"
                onTriggered: mainView.newDocument()
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("&Open...")
                icon.name: "document-open"
                onTriggered: fileOpenDialog.open()
            }
            MenuItem {
                text: qsTr("&Save")
                icon.name: "document-save"
                onTriggered: saveDocument()
            }
            MenuItem {
                text: qsTr("Save &As...")
                icon.name: "document-save-as"
                onTriggered: saveAsDocument()
            }
        }
        Menu {
            title: qsTr("&Help")
            MenuItem {
                text: qsTr("&About")
                onTriggered: aboutDialog.open()
            }

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

    onClosing: {
        if (root.isDirty) {
            closeWarningDialog.open();
            close.accepted = false;
        }
    }
    Native.MessageDialog {
        id: closeWarningDialog
        title: "Closing document"
        text: "You have unsaved changed. Do you want to save your changes?"
        buttons: Native.MessageDialog.Yes | Native.MessageDialog.No | Native.MessageDialog.Cancel
        onYesClicked: {
            root.tryingToClose = true;
            root.saveDocument();
        }
        onNoClicked: {
            root.isDirty = false;
            root.close()
        }
        onRejected: {
        }
    }
    FileDialog {
        id: fileOpenDialog
        title: "Select a file"
        // folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: [
            "Image files (*.png *.jpeg *.jpg)",
        ]
        onAccepted: {
            var window = root.createNewDocument();
            window.fileName = openDialog.file;
            window.show();
        }
    }
    
    Flow {
        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Home {}
            pushEnter: Transition {
            id: pushEnter
            ParallelAnimation {
                PropertyAction { property: "x"; value: pushEnter.ViewTransition.item.pos }
                NumberAnimation { properties: "y"; from: pushEnter.ViewTransition.item.pos + stackView.offset; to: pushEnter.ViewTransition.item.pos; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
            popExit: Transition {
                id: popExit
                ParallelAnimation {
                    PropertyAction { property: "x"; value: popExit.ViewTransition.item.pos }
                    NumberAnimation { properties: "y"; from: popExit.ViewTransition.item.pos; to: popExit.ViewTransition.item.pos + stackView.offset; duration: 400; easing.type: Easing.OutCubic }
                    NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
                }
            }
            pushExit: Transition {
                id: pushExit
                PropertyAction { property: "x"; value: pushExit.ViewTransition.item.pos }
                PropertyAction { property: "y"; value: pushExit.ViewTransition.item.pos }
            }
            popEnter: Transition {
                id: popEnter
                PropertyAction { property: "x"; value: popEnter.ViewTransition.item.pos }
                PropertyAction { property: "y"; value: popEnter.ViewTransition.item.pos }
            }
        }
    }
    FileDialog {
        id: openDialog
        fileMode: FileDialog.OpenFile
        selectedNameFilter.index: 1
        nameFilters: ["Text files (*.txt)", "HTML files (*.html *.htm)", "Markdown files (*.md *.markdown)"]
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: document.load(file)
    }

    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        defaultSuffix: document.fileType
        nameFilters: openDialog.nameFilters
        selectedNameFilter.index: document.fileType === "txt" ? 0 : 1
        currentFolder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: document.saveAs(file)
    }
    Dialog {
        id: aboutDialog
        title: qsTr("About")
        Label {
            anchors.fill: parent
            text: qsTr("QML Image Viewer\nA part of the QmlBook\nhttp://qmlbook.org")
            horizontalAlignment: Text.AlignHCenter
        }

        standardButtons: StandardButton.Ok
    }


    Drawer {
        id: drawer

        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            focus: true
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.text
                highlighted: ListView.isCurrentItem
                onClicked: {
                    drawer.close()
                    model.triggered()
                }
            }

            model: ListModel {
                ListElement {
                    text: qsTr("Open...")
                    triggered: function() { fileOpenDialog.open(); }
                }
                ListElement {
                    text: qsTr("About...")
                    triggered: function() { aboutDialog.open(); }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
    function createNewDocument() {
        var component = Qt.createComponent("Buffer.qml");
        var window = component.createObject();
        return window;
    }
    function newDocument() {
        var window = createNewDocument();
        window.show();
    }
     function saveAsDocument() {
        saveAsDialog.open();
    }

    function saveDocument() {
        if (fileName.length === 0) {
            mainView.saveAsDocument();
        } else {
            console.log("Saving document")
            mainView.isDirty = false;
            if (mainView.tryingToClose)
                mainView.close();
        }
    }

}
