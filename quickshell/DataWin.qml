import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// Popup générique attachée à un élément de la barre (typiquement une DataSec).
//
// Utilisation :
//   DataSec {
//       id: root
//       onClicked: win.toggle()
//       DataWindow {
//           id: win
//           target: root            // l'item sous lequel la popup s'affiche
//           title: "Titre"
//           content: ColumnLayout { Text { text: "Mon contenu" } }
//       }
//   }
PopupWindow {
    id: root

    // ---- API publique ------------------------------------------------------
    // Item auquel la popup s'accroche. Obligatoire : c'est lui qui permet à
    // Quickshell de savoir dans QUELLE fenêtre et À QUEL endroit placer la popup.
    required property Item target

    property string title: ""
    property int padding: 12
    property int gap: 8          // espace vertical entre la barre et la popup
    property int minWidth: 260

    // Le contenu est un Component : il n'est instancié que quand la popup est
    // visible (donc un scan Wi-Fi, par ex., ne tourne pas tant qu'elle est fermée).
    // On n'en fait PAS la "default property" : sinon les éléments internes
    // déclarés plus bas (card, Loader…) y seraient rangés à la place.
    property Component content: null

    function open()  { anchor.updateAnchor(); visible = true }
    function close() { visible = false; _closedAt = Date.now() }
    function toggle() {
        if (visible) close()
        // Anti-rebond : un clic sur la DataSec alors que la popup est ouverte
        // fait d'abord retomber le grab (=> close), PUIS déclenche le toggle.
        // Sans ce garde-fou, la popup se refermerait puis se rouvrirait aussitôt.
        else if (Date.now() - _closedAt > 200) open()
    }

    // ---- Interne -----------------------------------------------------------
    property double _closedAt: 0

    // La popup est une fenêtre à part entière : sa taille doit être fournie
    // (une PopupWindow de taille 0x0 n'apparaît jamais). On la déduit du contenu.
    implicitWidth: Math.max(minWidth, layout.implicitWidth + padding * 2)
    implicitHeight: layout.implicitHeight + padding * 2 + gap

    // Fond transparent : seul le Rectangle "card" est visible, ce qui permet
    // de ménager le "gap" au-dessus sans bande colorée.
    color: "transparent"

    // ---- Positionnement ----------------------------------------------------
    anchor {
        item: root.target                       // accroche à la DataSec
        edges: Edges.Bottom | Edges.Left        // point d'ancrage : coin bas-gauche de l'item
        gravity: Edges.Bottom | Edges.Right     // la popup s'étend vers le bas et la droite
        adjustment: PopupAdjustment.Slide       // glisse pour rester dans l'écran
    }

    // ---- Fermeture au clic extérieur (spécifique à Hyprland) ---------------
    HyprlandFocusGrab {
        windows: [root]
        active: root.visible
        onCleared: root.close()   // émis quand on clique hors de la popup
    }

    // ---- Apparence ---------------------------------------------------------
    Rectangle {
        id: card
        anchors {
            fill: parent
            topMargin: root.gap     // laisse l'espace transparent au-dessus
        }
        radius: 10
        color: Colors.baseGreen
        border.width: 2
        border.color: Colors.basePurple

        ColumnLayout {
            id: layout
            anchors {
                fill: parent
                margins: root.padding
            }
            spacing: 10

            Text {
                Layout.fillWidth: true
                visible: root.title !== ""
                text: root.title
                color: Colors.darkGreen
                font {
                    family: "Terminess Nerd Font Proto"
                    pixelSize: 14
                    bold: true
                }
            }

            // Charge le contenu fourni par l'utilisateur, uniquement si visible.
            Loader {
                Layout.fillWidth: true
                active: root.visible
                sourceComponent: root.content
            }
        }
    }
}
