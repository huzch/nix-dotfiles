#!/usr/bin/env bash

# 壁纸目录
WALLPAPER_DIR="$HOME/wallpapers"
# 状态文件，记录当前壁纸索引
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# 获取所有图片文件（支持常见图片格式）
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

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

# 使用 swww 设置壁纸，使用随机过渡效果
swww img "$NEXT_WALLPAPER" --transition-type "$RANDOM_TRANSITION" --transition-fps 60

# 保存新的索引
echo "$NEXT_INDEX" > "$STATE_FILE"

# 发送通知
WALLPAPER_NAME=$(basename "$NEXT_WALLPAPER")
notify-send -a "壁纸切换" "壁纸已切换" "$WALLPAPER_NAME (效果: $RANDOM_TRANSITION)" -t 3000