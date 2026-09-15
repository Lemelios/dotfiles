import Quickshell
import QtQuick
import QtQuick.Layouts
import "./Colors.js" as Col

PanelWindow {
	id: root
	exclusionMode : ExclusionMode.Ignore
	implicitWidth : 550
	implicitHeight : width 
	property string secName
	property model currentModel

    
	GridLayout {
		id : grid 
		anchors.fill : parent
	}
}
