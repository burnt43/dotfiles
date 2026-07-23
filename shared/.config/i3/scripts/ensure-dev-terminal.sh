#!/usr/bin/env bash
# usage: ensure-dev-terminal.sh <workspace-name> <command...>
# Launches a terminal running <command...> only if <workspace-name> has no
# windows on it yet, so repeated presses don't spawn duplicate terminals.

ws_name="$1"
shift

window_count=$(~/.config/i3/scripts/workspace-window-count.py "$ws_name")

if [ "$window_count" -eq 0 ]; then
  urxvt -e bash -ic "$*; exec bash" &
fi
