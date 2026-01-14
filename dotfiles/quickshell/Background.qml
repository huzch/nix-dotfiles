import QtQuick
import Quickshell
import Quickshell.Io
import "./components"

Item {
    id: root
    anchors.fill: parent

    // Interactive Area (Gestures)
    TapHandler {
        onDoubleTapped: {
            // Double click wallpaper to open terminal
            var proc = createProcess.createObject(root);
            proc.command = ["hyprctl", "dispatch", "exec", "foot"];
            proc.running = true;
        }
        onLongPressed: {
            // Long press wallpaper to open power menu
            var proc = createProcess.createObject(root);
            proc.command = ["wlogout", "-b", "5"];
            proc.running = true;
        }
    }

    Component {
        id: createProcess
        Process {}
    }

    // Base Wallpaper
    Image {
        anchors.fill: parent
        source: "./assets/wallpaper.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Single source of truth for audio data texture
    Canvas {
        id: dataTexture
        width: 50
        height: 1
        visible: false
        renderTarget: Canvas.Image
        property var audioValues: []
        
        onPaint: {
            var ctx = getContext("2d");
            for (var i = 0; i < audioValues.length; i++) {
                ctx.fillStyle = Qt.rgba(audioValues[i], 0, 0, 1);
                ctx.fillRect(i, 0, 1, 1);
            }
        }
        
        layer.enabled: true
        layer.smooth: true
    }

    // Visualizer 1 (Outer - Behind Ring)
    Visualizer {
        id: visualizer1
        anchors.centerIn: parent
        width: 700
        height: 700
        audioData: dataTexture
        out: true
        blurRadius: 10
        opacity: 0.15 
    }

    // Layer 2: Ring
    Image {
        anchors.fill: parent
        source: "./assets/wallpaper-planet-ring.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Visualizer 2 (Inner - Glow)
    Visualizer {
        id: visualizer2
        anchors.centerIn: parent
        width: 350
        height: 350
        audioData: dataTexture
        out: false
        blurRadius: 90
        opacity: 0.8
    }

    // Layer 3: Ring Top
    Image {
        anchors.fill: parent
        source: "./assets/wallpaper-planet-ring-top.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Layer 4: Top Elements
    Image {
        anchors.fill: parent
        source: "./assets/wallpaper-top.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Cava Process for Audio Data
    Process {
        id: cava
        running: true
        command: ["sh", "-c", "cava -p <(echo \"[general]\nbars = 50\nautosens = 1\n[output]\nmethod = raw\nraw_target = /dev/stdout\ndata_format = ascii\nascii_max_range = 100\")"]
        
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let values = data.split(';').map(v => parseInt(v) / 100.0).filter(v => !isNaN(v));
                if (values.length >= 50) {
                    dataTexture.audioValues = values.slice(0, 50);
                    dataTexture.requestPaint();
                }
            }
        }
    }
}
