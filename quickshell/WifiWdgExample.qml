import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

// EXEMPLE : adapte-le à ton WifiWdg actuel (garde ton `value`, ton `icon`, etc.).
// DataSec doit avoir le signal `clicked` (voir les modifs de DataSec.qml).
DataSec {
    id: root
	property var active : networks.values.find(n => n.connected)
	icon: String.fromCodePoint(0xf08d8 + (active ? 0 : 1))
	value: active ? active.name : "" 

    MouseArea {
        anchors.fill : parent
        onClicked: wifiWin.toggle()
    }

    ScriptModel { 
        id: networks
        values : Networking.devices.values.find(n => n.type === DeviceType.Wifi)?.networks.values
    }


    DataWin {
        id: wifiWin
        target: root
        title: "Réseaux Wi-Fi"
        minWidth: 280

        content: ColumnLayout {
            spacing: 4

            Repeater {
                model: networks

                delegate: Rectangle {
                    id: row

                    Layout.fillWidth: true
                    implicitHeight: 30
                    radius: 8
                    color: modelData.connected ? Colors.eludedFGreen : (hover.containsMouse ? Colors.eludedDGreen : "transparent")

                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        spacing: 8

                        Text {
                            Layout.fillWidth: true
                            text: modelData.name
                            elide: Text.ElideRight
                            color: Colors.basePurple
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 14; bold: row.active }
                        }
                        Text {
                            visible: modelData.securityType !== WifiSecurityType.Open
                            text: "\uf023"   // cadenas (Nerd Font)
                            color: Colors.darkPurple
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 12 }
                        }
                        Text {
                            text: modelData.signalStrength*100 + "%"
                            color: Colors.darkGreen
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 12 }
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            modelData.connect()
                        }
                    }
                }
            }
        }
    }
}
