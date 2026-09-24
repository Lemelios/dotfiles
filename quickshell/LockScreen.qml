import Quickshell
import Quickshell.Wayland 
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

WlSessionLock {
    id: lock 
    locked : LockScreenState.locked

    onLockedChanged: {
        if (LockScreenState.locked !== locked){
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
                color : Colors.eludedDPurple
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
                        easing.overshoot : 1.2
                    }
                }
                Behavior on y { NumberAnimation { duration : 350; easing.type : Easing.OutCubic } }
                
                SequentialAnimation {
                    id : shakeAnim 
                    loops : 1 

                    NumberAnimation {target : card ; property : animOffsetX; to : -12 ; duration : 50 ; easing.type : Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 12  ; duration : 50 ; easing.type : Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : -8  ; duration : 50 ; easing.type : Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 8   ; duration : 50 ; easing.type : Easing.OutQuad ;}
                    NumberAnimation {target : card ; property : animOffsetX; to : 0   ; duration : 50 ; easing.type : Easing.OutQuad ;}
                }

                Column {
                    id:contentColumn
                    width : parent.width
                    spacing : 4
                    visible : wallpaper.status === Image.Ready 

                    Text {
                        id: clockText
                        anchors.horizontalCenter : parent.horizontalCenter
                        text : Qt.formatDateTime(clock.date, "hh:mm")
                        font {
                            pixelSize : 80
                            weight : Font.Thin 
                        }
                        color: Colors.darkGreen
                    }
                    Text {
                        anchors.horizontalCenter : parent.horizontalCenter
                        text : Qt.formatDateTime(clock.date, "dddd d MMMM yyyy")
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
                                         : (pwField.activeFocus ? Colors.basePurple : Colors.inactiveGrey)
                        }
                        Behavior on border.color { ColorAnimation { duration : 200 } }
                        Behavior on border.width { NumberAnimation { duration : 150 } }
                        
                        RowLayout {
                            anchors {
                                fill : parent 
                                rightMargin : 16
                                leftMargin : 16
                            }
                            spacing : 10

                            TextField {
                                id : pwField
                                Layout.fillWidth : true 

                                echoMode : TextInput.Password 
                                enabled : !LockScreenState.authenticating 

                                placeholderText : LockScreenState.authenticating ? "Checking password ... " : "Password ..."
                                placeholderTextColor : Colors.inactiveGrey

                                color : '#afc6c6c6'
                                background : null
                                font.pixelSize : 15 
                                verticalAlignment : TextInput.AlignVCenter

                                onAccepted: {
                                    if (text.length > 0) 
                                        LockScreenState.authenticate(text)
                                }
                            }
                            BusyIndicator {
                                visible : LockScreenState.authenticating
                                running : LockScreenState.authenticating
                                implicitWidth : 18 
                                implicitHeight : 18
                            }
                        }

                    }
                    Text {
                        anchors.horizontalCenter : parent.horizontalCenter
                        text : "Incorrect password"
                        color : Colors.failRed
                        font {
                            weight : Font.Medium
                            pixelSize : 18
                        }
                        opacity : LockScreenState.authFailed ? 1 : 0
                        Behavior on opacity {
                            NumberAnimation { duration : 200 ; easing.type : Easing.InOutSine}
                        }
                    }
                }

                Connections {
                    target : LockScreenState
                    function onAuthFailedChanged() {
                        if (LockScreenState.authFailed){
                            shakeAnim.start()
                            pwField.text = ""
                            pwField.forceActiveFocus()
                        }
                    }
                    function onLockedChanged() {
                        if (!LockScreenState.locked) {
                            pwField.text = ""
                        }
                        else {
                            pwField.forceActiveFocus()
                        }
                    }
                }

                Component.onCompleted : pwField.forceActiveFocus()

                SystemClock {
                    id:clock 
                    precision : SystemClock.Minutes 
                }
            }
        }
    }
}