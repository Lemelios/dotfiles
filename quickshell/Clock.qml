import Quickshell
import QtQuick

DataSec {
	id : parentWindow
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
	Behavior on implicitWidth {
		NumberAnimation { duration : 250 ; easing.type : Easing.OutCubic}
	}

	PopupWindow{
		anchor {
			rect {
				x: parentWindow.width / 2 - width / 2
				y : parentWindow.height
			}
			window: parentWindow
			adjustment : PopupAdjustment.Slide
		}
		implicitWidth: 500
		implicitHeight: 500
		visible: true
	}
}
