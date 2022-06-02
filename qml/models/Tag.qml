import QtQuick
import QtQuick.Controls
import QtQuick.LocalStorage as Sql

Text{
    text: ""
    Component.onCompleted: {
        getTags()
    }
    function getTags() {
        var db = Sql.openDatabaseSync("idp.db", "1.0", "ipb db", 100000);
        db.transaction(function(tx) {
            var tags = tx.executeSql("SELECT * FROM Tag");
            var out = ""
            for (var i = 0; i < tags.length; i++) {
                var tag = tags.rows.item(i);
                out += tag.tag + ", " tag.info + "\n";
            }
            text = out;

    }
    function addTag(tag, info) {
        var db = Sql.openDatabaseSync("idp.db", "1.0", "ipb db", 100000);
        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS Tag(tag TEXT, info TEXT)");
            tx.executeSql("INSERT INTO Tag VALUES(?, ?)", [tag, info]);
        })
        
    }

}
