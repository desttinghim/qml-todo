import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "Database.js" as DB

Page {
    clip: true
    id: listThingy

    property date date
    property ListModel todoList

    Component.onCompleted: {
        console.log("Date in TodoList " + date.toString())
        var results = DB.readAllDate(date)
        for (var i in results) {
            todoList.append(results[i])
        }
        title = "Todos on " + date.toDateString()
    }


    ListModel { id: todoList }

    ListView {
        id: todoListView
        model: todoList
        delegate: TodoDelegate {}

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.fill: parent
        spacing: 5
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 30
        anchors.bottom: parent.bottom

        TextField {
            id: newTodoText
            placeholderText: qsTr("What do you need to do?")
            // TODO: Figure out how to make run something when enter is pressed
            // TODO: Make this span the bottom of the screen
        }

        Button {
            id: newTodoBtn
            text: qsTr("New Todo")
            onClicked: {
                console.log(date.toString())
                var newItem = DB.newTodo(newTodoText.text, date.toString())
                todoList.append(newItem)
                newTodoText.text = ""
            }
        }
    }
}
