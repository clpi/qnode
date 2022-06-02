import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

TextArea {
    id: editor
    hoverEnabled: true
    Layout.alignment: Qt.AlignCenter
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 3
    background: Rectangle {
        border.color: multiline.focus ? "#21be2b" : "lightgray"
        color: multiline.focus ? "lightgray" : "transparent"
    }
}
