#!/usr/bin/env bash

cliphist list | rofi -dmenu -i -matching fuzzy -p "clipboard" | cliphist decode | wl-copy