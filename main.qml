import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "Database.js" as DB
import "DateUtil.js" as DateUtil

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Todo")

    Component.onCompleted: {
        DB.dbInit()
    }

    Rectangle {
        id: nav
        width: parent.width
        height: 50
        anchors.top: parent.top
        color: "steelblue"
        Text {
            text: view.itemAt(view.currentIndex).date.toDateString()
            font.pointSize: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Rectangle {
        anchors.top: nav.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        SwipeView {
            id: view
            anchors.fill: parent
            TodoList {
                id: today
                date: new Date(Date())
            }
            TodoList {
                date: DateUtil.addDays(new Date(Date()), 1)
            }
        }
    }
}
