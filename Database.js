function dbInit() {
    // TODO: add date and archived fields
    var db = LocalStorage.openDatabaseSync("TodoAppDB", "", "Todo List", 100000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS todos (todo TEXT, done BOOL, date DATE)')
        })
        if (db.version === "1.0") {
            db.changeVersion("1.0", "1.1", function(tx) {
                tx.executeSql("ALTER TABLE todos ADD date DATE")
            })
        }
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("TodoAppDB", "1.1", "Todo List", 100000);
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
            var results = tx.executeSql('SELECT rowid,todo,done FROM todos WHERE date=? ORDER BY rowid desc',
                                        [date.toDateString()])
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

function readAll() {
    var db = dbGetHandle()
    var todos = []
    try {
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT rowid,todo,done FROM todos ORDER BY rowid desc')
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
    var rowId = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO todos VALUES(?, ?, ?)',
                      [text, false, date]);
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowId = result.insertId;
    });
    return {todoText: text,
                done: false,
               rowId: rowId};
}
