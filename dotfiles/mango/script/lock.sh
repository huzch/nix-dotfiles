#!/usr/bin/env bash

# 设置缓存文件路径
WALLPAPER="$HOME/.cache/current_wallpaper"

# 如果缓存文件不存在，则尝试从索引恢复
if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER_DIR="$HOME/wallpapers"
    STATE_FILE="$HOME/.cache/current_wallpaper_index"
    if [ -f "$STATE_FILE" ]; then
        INDEX=$(cat "$STATE_FILE")
        IMG=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort | sed -n "$((INDEX + 1))p")
        [ -n "$IMG" ] && cp "$IMG" "$WALLPAPER"
    fi
fi

# 灰色色调配置组 (Aesthetic Gray Tone)
args=(
    --clock
    --indicator
    --indicator-radius 220
    --indicator-thickness 20
    --effect-blur 7x5
    --effect-greyscale
    --effect-vignette 0.5:0.5
    --ring-color ffffff
    --key-hl-color dddddd
    --text-color ffffff
    --ring-ver-color ffffff
    --inside-ver-color 00000066
    --ring-wrong-color ff5555
    --timestr "%H:%M"
    --datestr "%Y-%m-%d"
    --line-color 00000000
    --inside-color 00000066
    --separator-color 00000000
    --grace 2
    --fade-in 0.3
)

# 优先使用壁纸文件，否则回退到屏幕截图
if [ -f "$WALLPAPER" ]; then
    swaylock -i "$WALLPAPER" "${args[@]}"
else
    swaylock --screenshots "${args[@]}"
fi
