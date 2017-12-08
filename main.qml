import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "Database.js" as DB

ApplicationWindow {
   visible: true
   width: 640
   height: 480
   title: qsTr("Hello World")

   Component.onCompleted: {
       DB.dbInit()
       DB.readAll()
   }


   Page {
       // TODO: todo lists sorted by day
       anchors.fill: parent

       ListModel { id: todoList }

       ListView {
           id: todoListView
           model: todoList
           delegate: TodoDelegate {}

           anchors.horizontalCenter: parent.horizontalCenter
           anchors.fill: parent
           width: parent.width
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
               onClicked: DB.newTodo(newTodoText.text)
           }
       }
   }
}
