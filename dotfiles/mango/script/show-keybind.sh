#!/usr/bin/env bash

keybinds=$(cat <<EOF
Alt + Return               打开终端
Alt + Q                    关闭窗口
Alt + Space                应用启动器
Alt + \                    窗口浮动
Alt + F                    最大化
Alt + Shift + F            全屏
Alt + H                    左
Alt + J                    下
Alt + K                    上
Alt + L                    右
Alt + Shift + H            向左交换窗口
Alt + Shift + J            向下交换窗口
Alt + Shift + K            向上交换窗口
Alt + Shift + L            向右交换窗口
Alt + 1-0                  切换工作区
Alt + Shift + 1-0          移动窗口
Alt + Tab                  展示所有窗口
Alt + M                    关机菜单
Alt + N                    通知中心
Alt + V                    剪贴板历史
Alt + W                    壁纸循环
Alt + Shift + W            选择壁纸
Alt + /                    显示快捷键
Super + N                  切换布局
EOF
)

echo -e "$keybinds" | rofi -dmenu -i -matching fuzzy -markup-rows -p "keybinds" \
  -theme-str 'window {width: 600px;}'