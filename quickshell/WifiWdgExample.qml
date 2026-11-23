import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

DataSec {
    id: root

    // ---- Données réactives (API native Quickshell.Networking) ---------------
    // Premier périphérique Wi-Fi. Se réévalue seul si Networking.devices change
    // (carte branchée/débranchée) ; `?? null` évite `undefined` s'il n'y en a pas.
    readonly property var device: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null

    // Réseau actuellement connecté (ou null). `?.` : device peut être null.
    readonly property var active: device?.networks.values.find(n => n.connected) ?? null

    icon: String.fromCodePoint(0xf08d8 + (active ? 0 : 1))
    value: active ? active.name : ""

    MouseArea {
        anchors.fill: parent
        onClicked: wifiWin.toggle()
    }

    // ---- LA CORRECTION -------------------------------------------------------
    // Tant que le scanner est désactivé, le périphérique ne liste que le réseau
    // connecté. On l'active uniquement quand la popup est visible :
    // `value` est réévalué à chaque changement de wifiWin.visible, et Binding
    // remet la propriété à sa valeur d'origine quand `when` devient faux.
    Binding {
        target: root.device
        property: "scannerEnabled"
        value: wifiWin.visible
        when: root.device !== null
    }

    // Modèle trié : réseau connecté d'abord, puis par puissance décroissante.
    // ScriptModel recalcule `values` quand une dépendance change (liste des
    // réseaux, connected, signalStrength) et ne met à jour la vue que par diff.
    ScriptModel {
        id: networks
        values: root.device
            ? root.device.networks.values.slice().sort((a, b) =>
                  (b.connected - a.connected) || (b.signalStrength - a.signalStrength))
            : []
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
                    // Chaque élément du ScriptModel est un objet WifiNetwork
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: 30
                    radius: 8
                    color: modelData.connected ? Colors.eludedFGreen
                         : (hover.containsMouse ? Colors.eludedDGreen : "transparent")

                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        spacing: 8

                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.name
                            elide: Text.ElideRight
                            color: Colors.basePurple
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 14; bold: row.modelData.connected }
                        }
                        Text {
                            // La propriété s'appelle `security` dans la doc (pas `securityType`)
                            visible: row.modelData.security !== WifiSecurityType.Open
                            text: "\uf023"   // cadenas (Nerd Font)
                            color: Colors.darkPurple
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 12 }
                        }
                        Text {
                            // signalStrength va de 0.0 à 1.0 ; on arrondit pour éviter "73.00000001%"
                            text: Math.round(row.modelData.signalStrength * 100) + "%"
                            color: Colors.darkGreen
                            font { family: "Terminess Nerd Font Proto"; pixelSize: 12 }
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: if (!row.modelData.connected) row.modelData.connect()
                    }
                }
            }
        }
    }
}
