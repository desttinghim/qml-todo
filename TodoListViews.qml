import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "Database.js" as DB

SwipeView {
    id: view
    anchors.fill: parent

    property date currentDate

    Component.onCompleted: {
        var dates = DB.getDates()
        var todoList = Qt.createComponent("TodoList.qml")
        var currentDateFound = false
        for (var i in dates) {
            var newTodo = todoList.createObject(view, {"date": dates[i].date})
            if (dates[i] == currentDate) {
                currentIndex = newTodo.index
                currentDateFound = true
            }
        }
        if (currentDateFound == false) {
            todoList.createObject(view, {"date": currentDate})
        }

    }
}
