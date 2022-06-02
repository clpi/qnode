from PySide6.QtCore import QObject, Slot, Signal
from PySide6.QtQml import QQmlFile, QmlElement, QQmlComponent
from pathlib import Path

QML_IMPORT_NAME = "io.qt.textproperties"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class MainView(QObject):

    path: Path = Path(__file__).parent.parent.parent / "qml" / "Splash.qml" 

    @Slot(str, result=str)
    def getColor(self, s):
        if s.lower() == "red":
            return "#ef9a9a"
        elif s.lower() == "green":
            return "#a5d6a7"
        elif s.lower() == "blue":
            return "#90caf9"
        else:
            return "white"

    @Slot(float, result=int)
    def getSize(self, s):
        size = int(s * 34)
        if size <= 0:
            return 1
        else:
            return size

    @Slot(str, result=bool)
    def getItalic(self, s):
        return s.lower() == "italic"

    @Slot(str, result=bool)
    def getBold(self, s):
        return s.lower() == "bold"

    @Slot(result=str)
    def currentWorkspace(self) -> str:
        return "default"
        


