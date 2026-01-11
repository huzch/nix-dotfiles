import QtQuick
import Quickshell
import Quickshell.Wayland

// Floating OSD for Volume
PanelWindow {
    id: osd
    
    property real volume: 0.5
    property bool shown: false
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-osd"
    
    // Make the window full width at the bottom to allow centering the handle
    anchors {
        bottom: true
        left: true
        right: true
    }
    
    implicitHeight: 160 // Use implicitHeight to avoid deprecation warning
    implicitWidth: 100 // Minimal placeholder, anchors will override
    color: "transparent"
    
    visible: shown || content.opacity > 0

    Rectangle {
        id: content
        width: 200
        height: 60
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#AA000000"
        radius: 10
        border.color: "#44FFFFFF"
        border.width: 1

        opacity: osd.shown ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Row {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "󰕾" // Volume Icon
                color: "white"
                font.pixelSize: 24
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                width: 100
                height: 6
                color: "#44FFFFFF"
                radius: 3
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width * osd.volume
                    height: parent.height
                    color: "#448AFF" // blueAccent
                    radius: 3
                }
            }
            
            Text {
                text: Math.round(osd.volume * 100) + "%"
                color: "white"
                font.pixelSize: 14
                font.bold: true
                width: 30
            }
        }
    }
    
    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: osd.shown = false
    }
    
    function show(val) {
        volume = val;
        shown = true;
        hideTimer.restart();
    }
}
