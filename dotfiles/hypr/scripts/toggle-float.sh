#!/usr/bin/env bash

# 切换当前窗口的浮动状态，并在浮动时设置为50%大小

# 当前是平铺，切换为浮动
hyprctl dispatch togglefloating
# 等待一小段时间让窗口状态更新
sleep 0.1
# 调整为50%大小并居中
hyprctl dispatch resizeactive exact 50% 50%
hyprctl dispatch centerwindow
