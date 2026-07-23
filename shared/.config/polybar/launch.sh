#!/usr/bin/env bash

killall -q polybar

while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 0.5
done

# yoko (DP-1, landscape): bar on top
MONITOR=DP-1 polybar --reload mainbar &
# tate (HDMI-1, portrait): bar on bottom
MONITOR=HDMI-1 polybar --reload mainbar-tate &
