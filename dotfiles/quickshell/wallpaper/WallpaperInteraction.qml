import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
  id: wallpaperOverlay
  
  // 填满整个屏幕
  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true
  
  WlrLayershell.layer: WlrLayer.Background
  
  // 设置为透明，这样它就能在不遮挡壁纸的情况下捕获点击
  color: "transparent"

  MouseArea {
    anchors.fill: parent
    
    // 双击空白区域打开终端
    onDoubleClicked: {
      Quickshell.run(["foot"]);
    }
    
    // 长按触发注销菜单
    onPressAndHold: {
      Quickshell.run(["wlogout"]);
    }
  }
}
