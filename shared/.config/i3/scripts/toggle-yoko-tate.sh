#!/usr/bin/env bash
# Moves the focused window between the yoko and tate halves of its current
# project pair: workspace "N:Name" <-> "Nb:Name". No-op if the focused
# window isn't on a project-pair workspace (e.g. an orphaned raw-numbered one).

current_ws=$(i3-msg -t get_workspaces | python3 -c "
import json, sys
for w in json.load(sys.stdin):
    if w['focused']:
        print(w['name'])
        break
")

if [[ "$current_ws" =~ ^([0-9]+)b:(.*)$ ]]; then
  # currently on tate -> move to yoko
  target="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
elif [[ "$current_ws" =~ ^([0-9]+):(.*)$ ]]; then
  # currently on yoko -> move to tate
  target="${BASH_REMATCH[1]}b:${BASH_REMATCH[2]}"
else
  exit 0
fi

i3-msg "move container to workspace \"$target\""
