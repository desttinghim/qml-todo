function dbInit() {
    // TODO: add date and archived fields
    var db = LocalStorage.openDatabaseSync("TodoAppDB", "", "Todo List", 100000)
    try {
        if (db.version === "1.0") {
            db.changeVersion("1.0", "1.2", function(tx) {
                tx.executeSql("DROP TABLE todos")
            })
        }
        if (db.version === "1.1") {
            db.changeVersion("1.1", "1.2", function(tx) {
                tx.executeSql("DROP TABLE todos")
            })
        }
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS todos (todo TEXT, done BOOL, date INT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS dates (id INTEGER PRIMARY KEY AUTOINCREMENT, date DATE)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("TodoAppDB", "1.2", "Todo List", 100000);
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function readAllDate(date) {
    var db = dbGetHandle()
    var todos = []
    try {
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT todos.rowid, todos.todo, todos.done '
                                        + 'FROM todos JOIN dates ON todos.date=dates.id '
                                        + 'WHERE dates.date=? ORDER BY todos.rowid desc',
                                        [date])
            for (var i = 0; i < results.rows.length; i++) {
                var item = results.rows.item(i)
                todos.push({
                               rowId: item.rowid,
                               done: item.done === 0 ? false : true,
                               todoText: item.todo
                           })
            }
        })
    } catch (err) {
        console.log("Error reading database: " + err)
    };
    return todos;
}

function getDates() {
    var db = dbGetHandle()
    var dates = []
    try {
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT id,date FROM dates')
            for (var i = 0; i < results.rows.length; i++) {
                var item = results.rows.item(i)
                dates.push({
                               id: item.id,
                               date: new Date(item.date)
                           })
            }
        })
    } catch (err) {
        console.log("Error reading database: " + err)
    };
    return dates;
}

function readAll() {
    var db = dbGetHandle()
    var todos = []
    try {
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT rowid,todo,done FROM todos JOIN dates ON todos.date==dates.id ORDER BY rowid desc')
            for (var i = 0; i < results.rows.length; i++) {
                var item = results.rows.item(i)
                todos.push({
                               rowId: item.rowid,
                               done: item.done === 0 ? false : true,
                                                       todoText: item.todo
                           })
            }
        })
    } catch (err) {
        console.log("Error reading database: " + err)
    };
    return todos;
}

function setTodoState(done, rowId) {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('update todos set done=? where rowid=?', [done, rowId])
    })
}

function newTodo(text, date) {
    var db = dbGetHandle();
    var rowId = "";
    db.transaction(function (tx) {
        var dateResults = tx.executeSql('SELECT * FROM dates WHERE date=?', [date])
        if (dateResults.rows.length === 0) {
            tx.executeSql('INSERT INTO dates (date) VALUES (?)', [date])
            dateResults = tx.executeSql('SELECT * FROM dates WHERE date=?', [date])
        }

        tx.executeSql('INSERT INTO todos VALUES(?, ?, ?)',
                      [text, false, dateResults.rows.item(0).id]);

        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowId = result.insertId;
    });
    return {todoText: text,
                done: false,
               rowId: rowId};
}
