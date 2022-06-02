DocumentHandler {
    id: document
    document: textArea.textDocument
    cursorPosition: textArea.cursorPosition
    selectionStart: textArea.selectionStart
    selectionEnd: textArea.selectionEnd
    textColor: colorDialog.color

    property alias family: document.font.family
    property alias bold: document.font.bold
    property alias italic: document.font.italic
    property alias underline: document.font.underline
    property alias strikeout: document.font.strikeout
    property alias size: document.font.pointSize

    Component.onCompleted: {
        if (Qt.application.arguments.length === 2)
            document.load("file:" + Qt.application.arguments[1]);
        else
            document.load("qrc:/texteditor.html")
    }
    onLoaded: function (text, format) {
        textArea.textFormat = format
        textArea.text = text
    }
    onError: function (message) {
        errorDialog.text = message
        errorDialog.visible = true
    }
}
