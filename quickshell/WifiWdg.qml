import QtQuick
import Quickshell
import Quickshell.Networking

DataSec {
	property var wifiDevice : Networking.devices.values.find(n => n.type === DeviceType.Wifi)
	property var active :wifiDevice?.networks.values.find(n => n.connected)
	icon: String.fromCodePoint(0xf08d8 + (active ? 0 : 1))
	value: active ? active.name : "" 
}
