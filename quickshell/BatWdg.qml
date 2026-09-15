import Quickshell
import QtQuick 
import Quickshell.Services.UPower

DataSec {
	property var battery: UPower.displayDevice
	property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging
	property string capacity : Math.round((battery.percentage ?? 0) * 100)

	icon : {
		if (charging) return String.fromCodePoint(0xf0084)
		if (capacity < 10) return String.fromCodePoint(0xf007a)
		if (capacity >= 100) return String.fromCodePoint(0xf0079)
		let tier = Math.floor (capacity / 10)
		return String.fromCodePoint(0xf0079 + tier)
	}

	iconColor : {
		let col = icon == String.fromCodePoint("0xf007a") ? '#d70000'
				: icon == String.fromCodePoint("0xf007b") ? '#d74800'
				: icon == String.fromCodePoint("0xf007c") ? '#d76f00'
				: icon == String.fromCodePoint("0xf007d") ? '#d79600'
				: icon == String.fromCodePoint("0xf007e") ? '#d7be00'
				: icon == String.fromCodePoint("0xf007f") ? '#c1d700'
				: icon == String.fromCodePoint("0xf0080") ? '#b3d700'
				: icon == String.fromCodePoint("0xf0081") ? '#a8d700'
				: icon == String.fromCodePoint("0xf0082") ? '#81d700'
				: '#00ff00'
		return col
	}

	value: capacity + "%"
}
