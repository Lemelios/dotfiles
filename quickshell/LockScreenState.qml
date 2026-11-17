pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import QtQuick

// État global de l'écran de verrouillage.
//
// Principe : au lieu de deviner "est-ce que je me suis déjà connecté ?" à partir
// de l'uptime, on le MÉMORISE dans un petit fichier situé dans $XDG_RUNTIME_DIR
// (/run/user/<uid>/, un tmpfs).
//   - Ce dossier est vidé au reboot et à la fermeture de la dernière session,
//     donc "pas de fichier" == "nouvelle session" == il faut verrouiller.
//   - Il survit aux rechargements/crashs de quickshell, donc "fichier = unlocked"
//     == "déjà connecté" == on ne reverrouille pas.
// Le fichier contient soit "locked", soit "unlocked".
Singleton {
    id: root

    // true quand le fichier témoin a été lu (ou a échoué à se lire).
    // Tant que c'est false, LockScreen ne doit ni verrouiller ni déverrouiller.
    property bool ready: false

    // État réel du verrou. Volontairement SANS binding : il n'est modifié que par
    // lock() / unlock() / la lecture initiale, jamais par un calcul implicite.
    property bool locked: false

    property bool authenticating: pam.active
    property bool authFailed: false
    property string pendingPassword: ""

    // Chemin du fichier témoin (XDG_RUNTIME_DIR est défini par logind/systemd)
    readonly property string statePath: Quickshell.env("XDG_RUNTIME_DIR") + "/quickshell-lockstate"

    FileView {
        id: stateFile
        path: root.statePath

        // Le fichier existe : on ne verrouille que s'il dit autre chose que "unlocked"
        // (ex. "locked" si quickshell a rechargé pendant un verrouillage manuel)
        onLoaded: {
            root.locked = (text().trim() !== "unlocked")
            root.ready = true
        }

        // Le fichier n'existe pas (ou illisible) : session toute neuve -> on verrouille
        onLoadFailed: error => {
            root.locked = true
            root.ready = true
        }

        onSaveFailed: error => console.warn("LockScreenState: écriture du témoin impossible :", error)
    }

    PamContext {
        id: pam
        config: "login"

        onCompleted: result => {
            if (result === PamResult.Success)
                root.unlock()
            else
                root.authFailed = true
        }

        onError: error => {
            root.authFailed = true
        }

        // PAM demande le mot de passe : on répond avec celui saisi dans l'UI
        onPamMessage: {
            if (pam.responseRequired) {
                pam.respond(root.pendingPassword)
                root.pendingPassword = ""
            }
        }
    }

    function lock() {
        if (root.locked) return
        authFailed = false
        root.locked = true
        // On écrit "locked" : si quickshell recharge pendant le verrouillage,
        // il ne faut PAS déverrouiller tout seul.
        stateFile.setText("locked")
    }

    function unlock() {
        authFailed = false
        root.locked = false
        stateFile.setText("unlocked")
    }

    function authenticate(password) {
        if (pam.active) return
        authFailed = false
        root.pendingPassword = password
        pam.start()
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void { root.lock() }
        function isLocked(): bool { return root.locked }
        function unlock(): void { root.unlock() }
    }
}
