import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "./Colors.js" as Col

Rectangle {
    id: root
    implicitWidth : row.implicitWidth + 22
    implicitHeight : 33
    radius : height / 2
	color: Col.baseGreen

    RowLayout {
        id: row
        anchors.centerIn : parent
        spacing : 8

        Repeater {
            model : ScriptModel {
                values : Hyprland.workspaces.values.filter(n => n.id > 0)
            }   

            Rectangle {
                implicitWidth : modelData.active ? 11 : 8
                implicitHeight : implicitWidth
                radius : width / 2
                color : modelData.active ? "transparent" : Col.workPurple
                border.width : modelData.active ? 2 : 0  
                border.color : Col.workPurple

                Behavior on implicitWidth {
                    NumberAnimation { duration : 150 ; easing.type : Easing.OutCubic}
                }
            }
        }
    }
}
