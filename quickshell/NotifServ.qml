import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
	id: root
	NotificationServer {
		id: server
		property bool centerOpen: false

		//ListModel { id: history }
		actionsSupported: true
		bodySupported: true
		imageSupported: true

		onNotification: n => {
			n.tracked = true
			history.insert(0, {
				summary: n.summary,
				body: n.body,
				appName: n.appName,
				urgency: n.urgency,
				time: Qt.formatDateTime(new Date(), "HH:mm")
			})
		}
	}
	
	IpcHandler {
		target: "notification"
		function toogle(): void { root.centerOpen = ! root.centerOpen}
		function show(): void { root.centerOpen = true}
		function hide(): void { root.centerOpen = false}
	}

	PanelWindow {
		anchors { top : true ; right : true}
		margins { top: 12; right : 12}

		implicitWidth: 380
		implicitHeight: Math.max(1, column.implicitHeight)
		color: "transparent"

		exclusionMode: ExclusionMode.Ignore
		
		ColumnLayout {
			id: column 
			width: parent.width 
			spacing: 5

			Repeater {
				model: server.trackedNotifications

				delegate: Rectangle {
					id: noteCard
					required property var modelData

					Layout.fillWidth: true 
//					Layout.preferredHeight: layout.implicitHeight + 20 
					Layout.preferredHeight: 60
					radius: 10
					border.width: 2
					border.color: modelData.urgency === NotificationUrgency.Critical ? "purple" : "green"

					Timer {
						id: autodismiss
						interval: 5000
						running: noteCard.modelData.urgency !== NotificationUrgency.Critical
						onTriggered: noteCard.modelData.dismiss()
					}
					RowLayout {
						id: body
						anchors.fill: parent
						anchors.margins: 10
						spacing: 10

						Image {
							Layout.preferredWidth: 36
							Layout.preferredHeight: 36
							Layout.alignment: Qt.AlignTop
							
							fillMode: Image.PreserveAspectFit
							visible: source.toString() !== ""
							source: noteCard.modelData.image || noteCard.modelData.appIcon || ""
						}
						ColumnLayout {
							Layout.fillWidth: true
							spacing: 5
							Text {
								id: head
								Layout.fillWidth: true
								text: noteCard.modelData.summary
								elide: Text.ElideRight
							}
							Text {
								Layout.fillWidth: true
								text: noteCard.modelData.body
								visible: text !== ""
								wrapMode: Text.WordWrap
								font.pixelSize: head.font.pixelSize - 1
							}
						}	
					}
					MouseArea {
						anchors.fill: parent
						onClicked: noteCard.modelData.dismiss()
					} 

				}
			}
		}
	}
} 
