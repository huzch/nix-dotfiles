import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
  id: osdWindow
  
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  margins.bottom: 100
  
  height: 60
  color: "transparent"
  
  WlrLayershell.layer: WlrLayer.Overlay
  
  // 实际上你应该监听系统音量变化来触发显示
  visible: true 
  
  Rectangle {
    width: 200
    height: 50
    anchors.centerIn: parent
    color: "#CC282828" // Gruvbox dark
    radius: 12
    border.color: "#ebdbb2"
    border.width: 1
    
    Text {
      anchors.centerIn: parent
      text: "Volume OSD Placeholder"
      color: "#ebdbb2"
      font.pixelSize: 16
    }
  }
}
