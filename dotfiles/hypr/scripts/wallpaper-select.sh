#!/usr/bin/env bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Selector" "Directory $WALLPAPER_DIR not found"
    exit 1
fi

# Get all image files
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

# Check if there are any wallpapers
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Wallpaper Selector" "No images found in $WALLPAPER_DIR"
    exit 1
fi

# Create a list for rofi with just filenames
OPTIONS=""
for wallpaper in "${WALLPAPERS[@]}"; do
    filename=$(basename "$wallpaper")
    OPTIONS="${OPTIONS}${filename}\n"
done

# Show rofi with image preview using icon-theme
SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Wallpapers" \
    -theme-str 'window {width: 800px;}' \
    -theme-str 'listview {lines: 10;}')

# If nothing selected, exit
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Find the full path of selected wallpaper
for i in "${!WALLPAPERS[@]}"; do
    if [ "$(basename "${WALLPAPERS[$i]}")" = "$SELECTED" ]; then
        SELECTED_PATH="${WALLPAPERS[$i]}"
        SELECTED_INDEX=$i
        break
    fi
done

# Switch wallpaper using swww
if [ -n "$SELECTED_PATH" ]; then
    # Random transition effect
    TRANSITIONS=("fade" "wipe" "grow" "wave" "outer")
    RANDOM_TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    
    swww img "$SELECTED_PATH" \
        --transition-type "$RANDOM_TRANSITION" \
        --transition-duration 1.5 \
        --transition-fps 60
    
    # Save current index
    echo "$SELECTED_INDEX" > "$STATE_FILE"
    
    notify-send "Wallpaper Changed" "$(basename "$SELECTED_PATH")"
fi
