#!/usr/bin/env bash

swayidle -w \
    timeout 300 '~/.config/mango/script/lock.sh' \
    timeout 600 'wlopm --off \*' \
    resume 'wlopm --on \*' \
    before-sleep '~/.config/mango/script/lock.sh'
