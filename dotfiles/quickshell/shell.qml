import QtQuick
import Quickshell
import Quickshell.Wayland

import "osd"
import "wallpaper"

Item {
  // OSD 模块
  VolumeOsd {}

  // 壁纸交互层
  WallpaperInteraction {}
}
