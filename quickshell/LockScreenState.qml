pragma Singleton 
import Quickshell
import Quickshell.Io 
import Quickshell.Services.Pam 
import QtQuick 

Singleton {
    id: root 
    property bool sysUp : false
    property bool locked: !sysUp
    property bool authenticating: pam.active  
    property bool authFailed: false

    PamContext {
        id: pam 
        config : "login"

        onCompleted: (result) => {
            if (result === PamResult.Success) {
                root.unlock() 
            }
            else {
                root.authFailed = true 
            }
        }

        onError: (error) => {
            root.authFailed = true 
        } 

        onPamMessage: {
            if (pam.responseRequired) {
                pam.respond(root.pendingPassword)
                root.pendingPassword = ""
            }
        }
    }

    property string pendingPassword : ""

    function lock() {
        if (root.locked) return 
        authFailed = false 
        root.locked = true 
    }
    function unlock() {
        authFailed = false 
        root.locked = false 
    }
    function authenticate(password){
        if (pam.active) return 
        authFailed = false 
        root.pendingPassword = password

        pam.start()
    }

    IpcHandler {
        target:"lockscreen"

        function lock(): void { root.lock() }
        function isLocked(): bool {return root.locked}
        function unlock(): void { root.unlock()}
    }

    Process {
        id: uptime
        command : ["sh", "-c", "w | head -1 | cut -d ' ' -f 4"]
        stdout : StdioCollector {
            onStreamFinished : root.sysUp = this.text.trim() >= 1   
        }
        running: true
    }
    Timer {
        id: oneMin 
        running : true 
        repeat : false 
        interval : 60000
        onTriggered : uptime.running = true 
    }
}