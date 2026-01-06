#!/usr/bin/env bash

# 壁纸目录
WALLPAPER_DIR="$HOME/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# 检查壁纸目录是否存在
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "壁纸切换" "目录 $WALLPAPER_DIR 不存在"
    exit 1
fi

# 获取所有图片文件
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sort)

# 检查是否有壁纸
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "壁纸切换" "在 $WALLPAPER_DIR 中没有找到图片文件"
    exit 1
fi

# 创建 rofi 选项列表（仅文件名）
OPTIONS=""
for wallpaper in "${WALLPAPERS[@]}"; do
    filename=$(basename "$wallpaper")
    OPTIONS="${OPTIONS}${filename}\n"
done

# 使用 rofi 显示选择器
SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -matching fuzzy -p "wallpapers" \
    -theme-str 'window {width: 800px;}' \
    -theme-str 'listview {lines: 10;}')

# 如果没有选择，退出
if [ -z "$SELECTED" ]; then
    exit 0
fi

# 查找选中壁纸的完整路径
for i in "${!WALLPAPERS[@]}"; do
    if [ "$(basename "${WALLPAPERS[$i]}")" = "$SELECTED" ]; then
        SELECTED_PATH="${WALLPAPERS[$i]}"
        SELECTED_INDEX=$i
        break
    fi
done

# 使用 swww 切换壁纸
if [ -n "$SELECTED_PATH" ]; then
    # 随机过渡效果
    TRANSITIONS=("simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer")
    RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    
    # 检查是否为 gif 格式
    if [[ "$SELECTED_PATH" == *.gif ]]; then
        # gif 动图需要禁用过渡效果以保持动画播放
        swww img "$SELECTED_PATH" \
            --transition-type none \
            --transition-fps 60
        EFFECT_MSG="动画播放"
    else
        swww img "$SELECTED_PATH" \
            --transition-type "$RANDOM_TRANSITION" \
            --transition-fps 60
        EFFECT_MSG="效果: $RANDOM_TRANSITION"
    fi
    
    # 保存当前索引
    echo "$SELECTED_INDEX" > "$STATE_FILE"
    
    # 发送通知
    WALLPAPER_NAME=$(basename "$SELECTED_PATH")
    notify-send -a "壁纸切换" "壁纸已切换" "$WALLPAPER_NAME ($EFFECT_MSG)" -t 3000
fi
