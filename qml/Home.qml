import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import "comp"
import "models"

Page {
    title: qsTr("Home")
    header: TabBar {
        id: bar
        width: parent.width
        position: TabBar.Header
        TabButton {
            text: qsTr("Home")
        }
        TabButton {
            text: qsTr("Discover")
        }
        TabButton {
            text: qsTr("Activity")
        }
    }

    Label {
        anchors.centerIn: parent
        text: qsTr("Home Screen")
    }
    ColumnLayout {
        Editor {
            placeholderText: qsTr("Enter text")
        }
        Button {
            text: qsTr("Give me a number!")
            onClicked: numberGenerator.giveNumber()
            hoverEnabled: true

            ToolTip.delay: 100
            ToolTip.timeout: 500
            ToolTip.visible: hovered
            ToolTip.text: qsTr("This is a tooltip")
        }
        Label {
            id: numberLabel
            text: qsTr("no number")
        }
        RadioButton {
            id: italic
            Layout.alignment: Qt.AlignLeft
            text: "Italic"
            onToggled: {
                leftlabel.font.italic = bridge.getItalic(italic.text)
                leftlabel.font.bold = bridge.getBold(italic.text)
                leftlabel.font.underline = bridge.getUnderline(italic.text)

            }
        }

        GroupBox {
            label: CheckBox {
                checked: true
                text: qsTr("Sync")
            }
            Text {
                id: topLabel
                Layout.alignment: Qt.AlignHCenter
                color: "white"
                font.pointSize: 16
                text: "Qt for Python"
                Material.accent: Material.Green
            }
            Text {
                text: "Hello QML"
                anchors.centerIn: mainView
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Edit");
                onClicked: stackView.push("EditProfile.qml")
            }

        }

    }
    Connections {
        target: numberGenerator
        function onNextNumber(number) {
            numberLabel.text = number
        }
    }

}
