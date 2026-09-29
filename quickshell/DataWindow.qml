import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
	id: root
	exclusionMode : ExclusionMode.Ignore
	anchors {
		horizontalCenter : parent.horizontalCenter
		top : parent.top
	}
	implicitWidth : 500
	implicitHeight : 400
	property string secName
	property var currentModel
	color : Colors.eludedDGreen


    
	GridLayout {
		id : grid 
		anchors.fill : parent
	}
}
