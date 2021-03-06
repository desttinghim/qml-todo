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

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stackView.pop()
            }
            Label {
                text: stackView.currentItem.title !== undefined ? stackView.currentItem.title : "Todos"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("⋮")
                // I don't know what this will do some I am commenting it out for now
                //onClicked: menu.open()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: MonthGrid {
            id: control
            title: "Todo Lists in " + DateUtil.getMonthName(new Date().getMonth())
            month: new Date().getMonth()
            year: new Date().getFullYear()
            locale: Qt.locale("en_US")

            onClicked: {
                // date is automatically passed in. date == date clicked on
                console.log("Date in main is " + date.toString())
                stackView.push("TodoList.qml", {"date": date})
            }
        }
    }
}
