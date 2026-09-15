import Quickshell
import Quickshell.Services.Mpris
import QtQuick

DataSec {
    id : root
    readonly property var player: Mpris.players.values.find(p => p.isPlaying) ?? Mpris.players.values[0] ?? null
    property bool showTrack : false
    icon: String.fromCodePoint(player ? player.isPlaying ? "0xf28b" : "0xf144" : "0xf038a")
    maxLabelWidth: showTrack || mouseAr.containsMouse ? 300 : 0
    value: player ? `${player.trackArtist || "Inconnu"} — ${player.trackTitle || ""}` : ""

    MouseArea {
        id : mouseAr
        anchors.fill: parent
        onClicked : root.player.togglePlaying()
        hoverEnabled: true
    }
    Behavior on maxLabelWidth {
        PropertyAnimation { duration: 350 ; easing {type : Easing.InOutQuad ; }}
    }
    Timer {
        id : displayer
        interval : 3000
        running : false
        repeat : false
        onTriggered : {
            root.showTrack = false
        }
    }
    
    Connections {
        target: player
        function onTrackChanged (){
            root.showTrack = true 
            displayer.running = true 
        }
    }
    
}
