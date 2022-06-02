from PySide6.QtSql import QSqlDatabase, QSql, QSqlRelationalTableModel
from pathlib import Path
from PySide6.QtCore import QObject, QDir, QStandardPaths, QFile

def db() -> QSqlDatabase:
    db = QSqlDatabase().database()
    if not db.isValid():
        db = QSqlDatabase.addDatabase("QSQLITE")
    writedir: QDir = QDir(QStandardPaths.writableLocation(QStandardPaths.AppDataLocation))
    if not writedir.mkpath("."):
        print("Failed to make dir at " + str(writedir.absolutePath()))
    path: Path = Path(writedir.absolutePath()) / "idp.sqlite3"
    db.setDatabaseName(str(path))
    if not db.open():
        print("Could not open db: " + db.lastError().text())
        QFile.remove(fileName=path)
    return db
