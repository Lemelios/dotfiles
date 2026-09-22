import Quickshell
import Quickshell.Wayland 
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

WlSessionLock {
    id: lock 
    locked : LockScreenState.locked

    onLockedChange: {
        
    }
}