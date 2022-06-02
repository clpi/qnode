import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Window {
    id: prefsWindow    

    property string currentView: "prefsWindowGeneral"

    header: ToolBar {
        ToolButton {
            text: qsTr("Back")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.StackView.view.pop()
        }

        Label {
            id: prefsWindowHeaderLabel
            text: qsTr("Preferences: " + prefsWindow.currentView)
            font.pixelSize: 20
            anchors.centerIn: parent
        }
}
