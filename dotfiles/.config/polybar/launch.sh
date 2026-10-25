#!/usr/bin/env bash

pkill -x polybar || true

while pgrep -x polybar >/dev/null; do
    sleep 0.2
done

polybar -c "$HOME/.config/polybar/config.ini" gntech \
    >> "$HOME/.cache/polybar.log" 2>&1 &
