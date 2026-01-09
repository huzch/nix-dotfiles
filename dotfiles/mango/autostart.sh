#!/bin/bash

waybar & swaync & swww-daemon &
fcitx5 --replace -d &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &