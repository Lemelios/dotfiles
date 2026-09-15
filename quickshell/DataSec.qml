import Quickshell
import QtQuick
import QtQuick.Layouts
import "./Colors.js" as Col 

Rectangle {
	id: root 

	property string icon 
	property string value 
	property var iconColor: Col.basePurple
	property int maxLabelWidth : 400

	implicitWidth: row.implicitWidth + 22
	implicitHeight: 33

	radius: height / 2;
	color: Col.baseGreen;

	RowLayout {
		id : row 
		anchors.centerIn: parent
		spacing: 10 

		Text {
			id : iconSec 
			text: root.icon 
				color: root.iconColor 
			font {
				family: "Terminess Nerd Font Proto"
				pixelSize: 18
			}
		}
		Text {
			id: dataSec
			text: root.value
			color: Col.basePurple
			font {
				family: "Terminess Nerd Font Proto"
				pixelSize: 14
			}
			elide: Text.ElideRight 
			Layout.maximumWidth: root.maxLabelWidth 
			visible: root.value !== "" && maxLabelWidth !== 0
		}
	}

}


