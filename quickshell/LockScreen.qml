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
        if (LockScreenState.locked === locked){
            LockScreenState = locked 
        }

    }
    WlSessionLockSurface {
        id : surface 

        Rectangle {
            id: mainContainer
            anchors.fill : parent
            color : "#000000"

            opacity : LockScreenState.locked ? 1 : 0 

            Behavior on opacity {
                NumberAnimation {
                    duration : 350 
                    easing.type : Easing.OutCubic
                }
            }
            Image {
                id : wallpaper 
                anchors.fill : parent 
                source : "/home/balthazar/dotfiles/Images/Wallpapers/Kath.png"
                fillMode : Image.PreserveAspectCrop
                smooth : true 
                asynchronous : true 
                cache : true 

                sourceSize.width  : surface.width 
                sourceSize.height : surface.height 

                visible : false 
            }
            MultiEffect {
                id : blurredWallpaper
                anchors.fill : parent
                source : wallpaper
                blurEnabled : true 
                blur : 0.8
                blurMax : 32

                visible : wallpaper.status === Image.Ready 
            }
            Rectangle {
                anchors.fill : parent 
                color : "#000000"
                opacity : 0.45
            }

            Item {
                id : card 
                width : 320
                height : contentColumn.height 
                anchors.centerIn : parent 

                property real baseX: (parents.width - width)/2
                property real animOffsetX: 0

                transform : Translate { x : card.animOffsetX }

                opacity : LockScreenState.locked ? 1 : 0 
                scale : LockScreenState.locked ? 1.0 : 0.92
                y : LockScreenState.locked ? (parent.height -height) / 2 : (parent.height - height) / 2 

                Behavior on opacity { NumberAnimation { duration: 300; easing.type : Easing.OutCubic } }
                Behavior on scale {
                    NumberAnimation {
                        duration : 350 
                        easing.type : OutBack
                        easing.overshot : 1.2
                    }
                }
                Behavior on y { NumberAnimation { duration : 350; easing.type : Easing.OutCubic } }
                
            }
        }
    }
}