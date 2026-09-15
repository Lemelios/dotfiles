import Quickshell 
import Quickshell.Bluetooth 
import QtQuick

DataSec {
    id : root 
    readonly property var blDev : Bluetooth.devices.values.find(n => n.connected)
    readonly property string batteryIcon : {
        if (blDev?.battery < 10) return String.fromCodePoint("0xf093e")
        if (blDev?.battery >= 100) return String.fromCodePoint("0xf0948")

        let level = Math.floor(blDev?.battery / 10 - 1)
        return String.fromCodePoint(0xf093f + level)
    }


    icon : String.fromCodePoint (Bluetooth.defaultAdapter.enabled ? "0xf00af" : "0xf00b2")
    value : blDev ? blDev.name + (mArea.containsMouse ? " " + batteryIcon + blDev?.battery + "%" : "") : ""

    MouseArea {
        id: mArea
        hoverEnabled : true 
    }
}