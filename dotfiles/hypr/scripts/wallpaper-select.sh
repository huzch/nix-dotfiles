#!/usr/bin/env bash

# 壁纸目录
WALLPAPER_DIR="$HOME/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper_index"
TYPE_FILE="$HOME/.cache/current_wallpaper_type"

# 检查壁纸目录是否存在
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "壁纸切换" "目录 $WALLPAPER_DIR 不存在"
    exit 1
fi

# 获取所有图片和视频文件
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)

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

# 根据文件类型选择不同的壁纸工具
if [ -n "$SELECTED_PATH" ]; then
    # 随机过渡效果
    TRANSITIONS=("simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer")
    RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    
    # 读取上一次的壁纸类型
    PREV_TYPE=""
    [ -f "$TYPE_FILE" ] && PREV_TYPE=$(cat "$TYPE_FILE")
    
    # 检测当前壁纸类型
    if [[ "$SELECTED_PATH" == *.mp4 ]]; then
        CURRENT_TYPE="video"
    elif [[ "$SELECTED_PATH" == *.gif ]]; then
        CURRENT_TYPE="gif"
    else
        CURRENT_TYPE="static"
    fi
    
    # 只在类型切换时杀进程
    if [ "$PREV_TYPE" != "$CURRENT_TYPE" ]; then
        # 从视频切换到其他类型，需要停止 mpvpaper
        if [ "$PREV_TYPE" = "video" ]; then
            MONITOR=$(hyprctl monitors | grep -A 1 "^Monitor" | head -n 1 | awk '{print $2}')
            [ -n "$MONITOR" ] && pkill -f "mpvpaper.*$MONITOR" 2>/dev/null
        fi
    fi
    
    # 根据类型应用壁纸
    if [ "$CURRENT_TYPE" = "video" ]; then
        # 自动检测显示器（仅视频需要）
        MONITOR=$(hyprctl monitors | grep -A 1 "^Monitor" | head -n 1 | awk '{print $2}')
        if [ -z "$MONITOR" ]; then
            notify-send "壁纸切换" "无法检测到显示器"
            exit 1
        fi
        # 使用 mpvpaper 播放 mp4 视频
        mpvpaper -o "no-audio --hwdec=no --vo=gpu" "$MONITOR" "$SELECTED_PATH" &
        EFFECT_MSG="视频循环播放"
    elif [ "$CURRENT_TYPE" = "gif" ]; then
        # gif 动图禁用过渡效果以保持动画播放
        swww img "$SELECTED_PATH" \
            --transition-type none \
            --transition-fps 60
        EFFECT_MSG="动画播放"
    else
        # 静态图片使用随机过渡效果
        swww img "$SELECTED_PATH" \
            --transition-type "$RANDOM_TRANSITION" \
            --transition-fps 60
        EFFECT_MSG="效果: $RANDOM_TRANSITION"
    fi
    
    # 保存当前索引和类型
    echo "$SELECTED_INDEX" > "$STATE_FILE"
    echo "$CURRENT_TYPE" > "$TYPE_FILE"
    
    # 发送通知
    WALLPAPER_NAME=$(basename "$SELECTED_PATH")
    notify-send -a "壁纸切换" "壁纸已切换" "$WALLPAPER_NAME ($EFFECT_MSG)" -t 3000
fi
