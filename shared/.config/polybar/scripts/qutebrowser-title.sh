#!/usr/bin/env python3
import json
import subprocess

MAX_LEN = 50


def walk(node, out):
    if node.get("window"):
        out.append((node.get("window_properties", {}).get("class"), node.get("name")))
    for c in node.get("nodes", []) + node.get("floating_nodes", []):
        walk(c, out)


tree = json.loads(subprocess.check_output(["i3-msg", "-t", "get_tree"]))
windows = []
walk(tree, windows)

title = None
for cls, name in windows:
    if cls and cls.lower() == "qutebrowser" and name and "YouTube Music" in name:
        title = name
        break

if not title:
    print("")
else:
    before_pipe = title.split("|", 1)[0].strip()
    if len(before_pipe) > MAX_LEN:
        before_pipe = before_pipe[:MAX_LEN].rstrip() + "..."
    print(before_pipe)
