#!/bin/bash

set +e

# night light
wlsunset -T 3501 -t 3500 &

# wallpaper
swaybg -i ~/wallpapers/forrest.png &

# top bar
waybar &

# ime input
fcitx5 --replace -d &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
wl-paste --type text --watch cliphist store &

# bluetooth 
blueman-applet &

# network
nm-applet &
