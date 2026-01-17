#!/usr/bin/env bash

# 配置
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache"
STATE_FILE="$CACHE_DIR/current_wallpaper_index"
TYPE_FILE="$CACHE_DIR/current_wallpaper_type"
CACHE_IMG="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

# 获取壁纸列表
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "壁纸切换" "在 $WALLPAPER_DIR 中没有找到支持的文件"
    exit 1
fi

# 应用壁纸的函数
apply_wallpaper() {
    local wp_path="$1"
    local wp_index="$2"
    local trans_type="${3:-random}"
    
    # 检测类型
    local current_type="static"
    [[ "$wp_path" == *.mp4 ]] && current_type="video"
    [[ "$wp_path" == *.gif ]] && current_type="gif"
    
    # 随机过渡效果
    local transitions=("simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "outer")
    [[ "$trans_type" == "random" ]] && trans_type=${transitions[$RANDOM % ${#transitions[@]}]}
    
    # 处理类型切换逻辑
    local prev_type=""
    [ -f "$TYPE_FILE" ] && prev_type=$(cat "$TYPE_FILE")
    
    if [ "$prev_type" = "video" ] && [ "$current_type" != "video" ]; then
        pkill -f "mpvpaper" 2>/dev/null
    fi
    
    local effect_msg=""
    case "$current_type" in
        "video")
            local monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name' 2>/dev/null)
            [ -z "$monitor" ] && monitor="*"

            swww clear 000000
            mpvpaper -o "no-audio --loop-file=inf --panscan=1.0 --hwdec=auto" "$monitor" "$wp_path" &
            effect_msg="视频播放"
            ;;
        "gif")
            swww img "$wp_path" --transition-type none --transition-fps 60
            effect_msg="动画展示"
            ;;
        *)
            swww img "$wp_path" --transition-type "$trans_type" --transition-fps 60
            effect_msg="效果: $trans_type"
            ;;
    esac
    
    # 更新缓存和状态
    [[ "$current_type" != "video" ]] && cp "$wp_path" "$CACHE_IMG"
    echo "$wp_index" > "$STATE_FILE"
    echo "$current_type" > "$TYPE_FILE"
    
    notify-send "壁纸切换" "$(basename "$wp_path") ($effect_msg)" -t 3000
}

case "$1" in
    "next")
        current_index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
        next_index=$(( (current_index + 1) % ${#WALLPAPERS[@]} ))
        apply_wallpaper "${WALLPAPERS[$next_index]}" "$next_index"
        ;;
    "select")
        options=""
        for wp in "${WALLPAPERS[@]}"; do
            options+="$(basename "$wp")\n"
        done
        selected=$(echo -e "$options" | rofi -dmenu -i -matching fuzzy -p "wallpapers" -theme-str 'window {width: 600px;} listview {lines: 10;}')
        
        if [ -n "$selected" ]; then
            for i in "${!WALLPAPERS[@]}"; do
                if [ "$(basename "${WALLPAPERS[$i]}")" = "$selected" ]; then
                    apply_wallpaper "${WALLPAPERS[$i]}" "$i"
                    break
                fi
            done
        fi
        ;;
    *)
        echo "用法: $0 {next|select}"
        exit 1
        ;;
esac
