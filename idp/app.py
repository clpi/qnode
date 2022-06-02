import sys
import platform
from idp.data.db import db
from idp.ui.window import MainView
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent, QQmlContext, qmlRegisterType
from PySide6.QtCore import QObject, Signal, Slot, Property, ClassInfo, Qt
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQuick import QQuickView, QQuickWindow
import random

from PySide6.QtCore import QObject, Signal, Slot

class NumberGenerator(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.__number = 42
        self.__max_number = 99
    
    nextNumber = Signal(int, arguments=['number'])
    numberChanged = Signal(int)
    
    def __set_number(self, val):
        if self.__number != val:
            self.__number = val
            self.numberChanged.emit(self.__number)

    @Slot()
    def updateNumber(self):
        self.__set_number(random.randint(0, self.__max_number))   

    def get_number(self):
        return self.__number
    
    number = Property(int, get_number, notify=numberChanged)

    @Slot()
    def giveNumber(self):
        self.nextNumber.emit(random.randint(0, 99))

    def set_max_number(self, val):
        if val < 0:
            val = 0
        
        if self.__max_number != val:
            self.__max_number = val
            
        if self.__number > self.__max_number:
            self.__set_number(self.__max_number)
    
    def get_max_number(self):
        return self.__max_number
    
    def get_number(self):
        return self.__number

def app():

    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("app.ico"))
    app.setAttribute(Qt.AA_EnableHighDpiScaling)
    # app.setAttribute(Qt.AA_TranslucentBackground)
    app.setAttribute(Qt.ApplicationAttribute.AA_UseHighDpiPixmaps)
    appdb = db()
    eng = QQmlApplicationEngine()
    # ctx = QQmlContext(eng.rootContext())
    numgen = NumberGenerator()
    eng.rootContext().setContextProperty("numberGenerator", numgen)
    QQuickStyle("material")
    qml = str(MainView.path)
    eng.load(qml)
    if not eng.rootObjects():
        sys.exit(-1);
    sys.exit(app.exec())
