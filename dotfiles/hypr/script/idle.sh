#!/usr/bin/env bash

swayidle -w \
    timeout 300 '~/.config/hypr/script/lock.sh' \
    timeout 600 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on' \
    before-sleep '~/.config/hypr/script/lock.sh'
