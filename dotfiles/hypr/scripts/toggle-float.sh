#!/usr/bin/env bash

# 切换当前窗口的浮动状态，并在浮动时设置为50%大小

# 获取当前活动窗口信息
WINDOW=$(hyprctl activewindow -j)
IS_FLOATING=$(echo "$WINDOW" | jq -r '.floating')

if [ "$IS_FLOATING" == "true" ]; then
    # 当前是浮动，切换回平铺
    hyprctl dispatch settiled
else
    # 当前是平铺，切换为浮动
    hyprctl dispatch setfloating
    # 等待一小段时间让窗口状态更新
    sleep 0.05
    # 调整为50%大小并居中
    hyprctl dispatch resizeactive exact 50% 50%
    hyprctl dispatch centerwindow
fi
