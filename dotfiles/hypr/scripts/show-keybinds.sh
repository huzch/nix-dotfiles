#!/usr/bin/env bash

keybinds=$(cat <<EOF
<b>窗口管理</b>
Alt + Return       打开终端
Alt + Q            关闭窗口
Alt + Space        应用启动器
Alt + F            最大化
Alt + Shift + F    全屏

<b>窗口焦点</b>
Alt + H            左
Alt + J            下
Alt + K            上
Alt + L            右

<b>工作区</b>
Alt + 1-0          切换工作区
Alt + Tab          上个工作区
Alt + Shift + 1-0  移动窗口

<b>系统</b>
Alt + Shift + L    锁屏
Alt + Shift + N    通知中心
Alt + W            壁纸循环
Alt + Shift + W    选择壁纸
Alt + /            显示快捷键
Print              截图窗口
Shift + Print      截图区域
EOF
)

echo -e "$keybinds" | rofi -dmenu -i -markup-rows -p "Keybinds" \
  -theme-str 'window {width: 600px;}' 
