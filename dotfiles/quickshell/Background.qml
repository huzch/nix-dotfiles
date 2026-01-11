import QtQuick
import Quickshell
import Quickshell.Io
import "./components"

Item {
    id: root
    anchors.fill: parent

    // Base Wallpaper
    Image {
        anchors.fill: parent
        source: "./assets/wallpaper.png"
        fillMode: Image.PreserveAspectCrop
    }

    // Visualizer 1 (Outer - Behind Ring)
    Visualizer {
        id: visualizer1
        anchors.centerIn: parent
        width: 830
        height: 830
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
        width: 400
        height: 400
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
                    let cleanValues = values.slice(0, 50);
                    visualizer1.values = cleanValues;
                    visualizer2.values = cleanValues;
                }
            }
        }
    }
}
