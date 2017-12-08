function dbInit() {
    // TODO: add date and archived fields
    var db = LocalStorage.openDatabaseSync("TodoAppDB", "1.0", "Todo List", 100000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS todos (todo TEXT, done BOOL)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("TodoAppDB", "1.0", "Todo List", 100000);
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function readAll() {
    var db = dbGetHandle()
    try {
        db.transaction(function (tx) {
            var results = tx.executeSql('SELECT rowid,todo,done FROM todos ORDER BY rowid desc')
            for (var i = 0; i < results.rows.length; i++) {
                var item = results.rows.item(i)
                todoList.append({
                                    rowId: item.rowid,
                                    done: item.done === 0 ? false : true,
                                    todoText: item.todo
                                })
            }
        })
    } catch (err) {
        console.log("Error reading database: " + err)
    };
}

function setTodoState(done, rowId) {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('update todos set done=? where rowid=?', [done, rowId])
    })
}

function newTodo(text) {
    var db = dbGetHandle();
    var rowId = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO todos VALUES(?, ?)',
                      [text, false]);
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowId = result.insertId;
    });
    todoList.append({todoText: text,
                        done: false,
                        rowId: rowId});
    newTodoText.text = "";
}
