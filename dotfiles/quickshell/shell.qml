import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "./components"

Item {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

        function onVolumesChanged() {
            if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                volumeOSD.show(Pipewire.defaultAudioSink.audio.volume);
            }
        }

        function onMutedChanged() {
            if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio) {
                volumeOSD.show(Pipewire.defaultAudioSink.audio.volume);
            }
        }
    }

    // Background Layer
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            property var screen: modelData
            
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell-background"
            
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Background {}
        }
    }

    // Volume OSD (Top level overlay)
    VolumeOSD {
        id: volumeOSD
    }
}
