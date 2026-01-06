#!/usr/bin/env bash

# 壁纸目录
WALLPAPER_DIR="$HOME/wallpapers"
# 状态文件，记录当前壁纸索引
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# 自动检测当前显示器
MONITOR=$(hyprctl monitors | grep -A 1 "^Monitor" | head -n 1 | awk '{print $2}')
if [ -z "$MONITOR" ]; then
    notify-send "壁纸切换" "无法检测到显示器"
    exit 1
fi

# 获取所有图片和视频文件
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)

# 检查是否有壁纸
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "壁纸切换" "在 $WALLPAPER_DIR 中没有找到图片文件"
    exit 1
fi

# 读取当前索引，如果不存在则从 0 开始
if [ -f "$STATE_FILE" ]; then
    CURRENT_INDEX=$(cat "$STATE_FILE")
else
    CURRENT_INDEX=0
fi

# 计算下一个索引（循环）
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# 获取下一张壁纸路径
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# 定义可用的过渡效果
TRANSITIONS=("simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer")

# 随机选择一个过渡效果
RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

# 根据文件类型选择不同的壁纸工具
if [[ "$NEXT_WALLPAPER" == *.mp4 ]]; then
    # 停止之前的 mpvpaper 进程
    pkill -f "mpvpaper.*$MONITOR" 2>/dev/null
    # 使用 mpvpaper 播放 mp4 视频（使用软件渲染避免 GPU 驱动问题）
    mpvpaper -o "no-audio --hwdec=no --vo=gpu" "$MONITOR" "$NEXT_WALLPAPER" &
    EFFECT_MSG="视频循环播放"
elif [[ "$NEXT_WALLPAPER" == *.gif ]]; then
    # 停止 mpvpaper（如果在运行）
    pkill -f "mpvpaper.*$MONITOR" 2>/dev/null
    # gif 动图需要禁用过渡效果以保持动画播放
    swww img "$NEXT_WALLPAPER" --transition-type none --transition-fps 60
    EFFECT_MSG="动画播放"
else
    # 停止 mpvpaper（如果在运行）
    pkill -f "mpvpaper.*$MONITOR" 2>/dev/null
    # 静态图片使用随机过渡效果
    swww img "$NEXT_WALLPAPER" --transition-type "$RANDOM_TRANSITION" --transition-fps 60
    EFFECT_MSG="效果: $RANDOM_TRANSITION"
fi

# 保存新的索引
echo "$NEXT_INDEX" > "$STATE_FILE"

# 发送通知
WALLPAPER_NAME=$(basename "$NEXT_WALLPAPER")
notify-send -a "壁纸切换" "壁纸已切换" "$WALLPAPER_NAME ($EFFECT_MSG)" -t 3000