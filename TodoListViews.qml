import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "Database.js" as DB

SwipeView {
    id: view

    property date currentDate

    Component.onCompleted: {
        var dates = DB.getDates()
        var currentDateFound = false
        var todoList = Qt.createComponent("TodoList.qml") // move this into createTodoList()

        for (var i in dates) {
            // Need properly formatted date strings
            // This means using toString and not toDateString
            var dateObj = new Date(dates[i].date)
            if (dates[i].date === "Invalid Date" || dateObj.toString() === "Invalid Date") {
                console.log("Invalid Date found at " + i + ": " + dates[i].id)
                continue;
            }
            console.log("Date in TodoListViews is " + dateObj.toString())

            var newTodo = createTodoList(todoList, dates[i].date)
            if (dateObj.toString() == currentDate.toString()) {
                currentIndex = i
                currentDateFound = true
            }
        }
        if (currentDateFound == false) {
            createTodoList(todoList, currentDate)
            console.log("Date does not currently exist, creating it...")
            currentIndex = dates.length
        }
    }

    function createTodoList(todoList, date) {
        var newTodo = todoList.createObject(view, {"dates": date})

        if (newTodo === null) console.log("Error in TodoListViews creating TodoList")

        return newTodo;
    }
}
