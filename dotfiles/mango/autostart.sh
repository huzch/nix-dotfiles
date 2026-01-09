#!/bin/bash

waybar & swaync & swww-daemon &
fcitx5 --replace -d &
~/.config/mango/script/idle.sh &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &