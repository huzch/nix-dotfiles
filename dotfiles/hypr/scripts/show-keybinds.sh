#!/usr/bin/env bash

# Hyprland Keybindings

keybinds=$(cat <<EOF
<b>Window Management</b>
Alt + Return       Open Terminal
Alt + Q            Close Window
Alt + Space        App Launcher
Alt + F            Maximize
Alt + Shift + F    Fullscreen

<b>Window Focus</b>
Alt + H            Focus Left
Alt + J            Focus Down
Alt + K            Focus Up
Alt + L            Focus Right

<b>Workspaces</b>
Alt + 1-0          Switch Workspace
Alt + Tab          Previous Workspace
Alt + Shift + 1-0  Move Window to Workspace

<b>System</b>
Alt + Shift + L    Lock Screen
Alt + Shift + N    Notification Center
Alt + W            Cycle Wallpaper
Alt + Shift + W    Select Wallpaper
Alt + /            Show Keybindings
Print              Screenshot Window
Shift + Print      Screenshot Region
EOF
)

# Display with rofi (-i for case-insensitive search)
echo -e "$keybinds" | rofi -dmenu -i -markup-rows -p "Keybindings" \
  -theme-str 'window {width: 600px;}' 
