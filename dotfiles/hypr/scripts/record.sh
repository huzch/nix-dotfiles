#!/usr/bin/env bash

# 录制保存目录
DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"

# 时间戳文件名
NAME="record_$(date +'%Y%m%d_%H%M%S').mp4"
FILE="$DIR/$NAME"

# 检查是否正在录制
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT wf-recorder
    notify-send "录制停止" "录制已保存" -i video-x-generic
    exit 0
fi

# 根据参数执行全屏或区域录制
if [ "$1" == "full" ]; then
    notify-send "录制开始" "正在全屏录制..." -i video-x-generic
    wf-recorder -f "$FILE"
elif [ "$1" == "area" ]; then
    GEOM=$(slurp)
    if [ -z "$GEOM" ]; then
        exit 1
    fi
    notify-send "录制开始" "正在区域录制..." -i video-x-generic
    wf-recorder -g "$GEOM" -f "$FILE"
else
    echo "Usage: $0 [full|area]"
    exit 1
fi
