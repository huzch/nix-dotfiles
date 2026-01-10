#!/bin/bash

waybar & swaync & swww-daemon & quickshell &
fcitx5 --replace -d &
~/.config/mango/script/idle.sh &
wl-clip-persist --clipboard regular --reconnect-tries 0 &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &