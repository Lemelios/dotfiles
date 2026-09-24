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
                
                SequentialAnimation {
                    id : shakeAnim 
                    loops : 1 

                    NumberAnimation {target : card ; property : animOffsetX; to : -12 ; duration : 50 ; easing.type = Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 12  ; duration : 50 ; easing.type = Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : -8  ; duration : 50 ; easing.type = Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 8   ; duration : 50 ; easing.type = Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 0   ; duration : 50 ; easing.type = Easing.OutQuad ;}
                }

                Column {
                    anchors.horizontalCenter : parent.horizontalCenter
                    spacing : 4

                    Text {
                        id: clockText
                        anchors.horizontalCenter : parent.horizontalCenter
                        text : Qt.formatDateTime(clock.time, "hh:mm")
                        font {
                            pixelSize : 80
                            weight : Font.Thin 
                        }
                        color: Colors.darkGreen
                    }
                    Text {
                        anchors.horizontalCenter : parent.horizontalCenter
                        text : Qt.formatDateTime(clock.time, "dddd d MMMM yyyy")
                        font {
                            pixelSize : 16
                            weight : Font.Medium 
                        }
                        color : Colors.darkGreen
                    }
                    Item {height : 12 ; width :1}
                    Rectangle {
                        id : fieldWrap
                        width : parent.width 
                        height : 50
                        radius : 14 
                        color : Colors.eludedFGreen
                        border {
                            width : pxField.activeFocus ? 2 : (LockScreenState.authFailed ? 2: 1)
                            color : LockScreenState.authFailed ? Colors.failRed 
                                         : pwField.activeFocus ? Colors.basePurple
                                         : Colors.inactiveGrey
                        }
                    }

                }
                SystemClock {
                    id:clock 
                    precision : SystemClock.Minutes 
                }
            }
        }
    }
}