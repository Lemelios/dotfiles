import Quickshell 
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts

Scope {
  	Variants {
    model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen: modelData
			implicitHeight: 33
			color: "transparent"
      		anchors {
			  	top: true
				right: true 
				left: true 
			}
			margins.top : 10

			RowLayout {
				id: left
				anchors {
					left : parent.left 
					verticalCenter : parent.verticalCenter
					leftMargin : 15
				}
				spacing: 15
				
				BatWdg {}
				AudioWdg {}
				WifiWdg {}
				Bluetooth {}
			}

			RowLayout {
				id: middle
				anchors.centerIn : parent
				spacing: 15
				Clock{}
				Workspaces {}
			}
			RowLayout {
				id: right 
				anchors {
					right : parent.right 
					verticalCenter : parent.verticalCenter
					rightMargin : 15
				}
				spacing: 15
				Player {}
			}
		}	
	}
}

