import QtQuick 2.0
import QtQuick.Controls 2.0

Component {
    id: root

    Rectangle {
        // TODO: add archive button
        // TODO(?): add delete button
        width: parent.width
        height: 40

        CheckBox {
            id: checkbox
            checked: done
            onClicked: {
                done = checked
                DB.setTodoState(done, rowId)
            }
        }
        Text {
            id: textitem
            text: todoText
            anchors.left: checkbox.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
