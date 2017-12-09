import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import Qt.labs.calendar 1.0
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
            // TODO: Come up with a better way to change the breadcrumbs thingamajig
            //text: view.itemAt(view.currentIndex).date.toDateString()
            font.pointSize: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    StackView {
        id: stackView
        anchors.top: nav.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        initialItem: MonthGrid {
            id: control
            month: new Date().getMonth()
            year: new Date().getFullYear()
            locale: Qt.locale("en_US")

            onClicked: {
                console.log(date) // date is automatically passed in. date == date clicked on
                stackView.push("TodoListViews.qml", {})
            }
        }
    }
}
