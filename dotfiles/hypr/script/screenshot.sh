#!/usr/bin/env bash

# 截图保存目录
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# 时间戳文件名
NAME="screenshot_$(date +'%Y%m%d_%H%M%S').png"
FILE="$DIR/$NAME"

# 根据参数执行全屏或区域截图
if [ "$1" == "full" ]; then
    grim "$FILE"
elif [ "$1" == "area" ]; then
    grim -g "$(slurp)" "$FILE"
else
    echo "Usage: $0 [full|area]"
    exit 1
fi

# 如果截图成功，则发送通知并复制到剪切板
if [ -f "$FILE" ]; then
    wl-copy < "$FILE"
    notify-send "截图成功" "已保存至 $NAME 并复制到剪切板" -i "$FILE"
fi
