import Quickshell
import QtQuick

DataSec {
    icon: String.fromCodePoint(0xf313)
    value: Qt.formatDateTime(clock.date, mArea.containsMouse ? "hh:mm:ss — dd/MM/yy" : "hh:mm")

	MouseArea {
		id: mArea
		anchors.fill : parent
		hoverEnabled : true 
	}

	SystemClock {
        id: clock
        precision: mArea.containsMouse ? SystemClock.Seconds : SystemClock.Minutes
    }
}
