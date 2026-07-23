#!/usr/bin/env python3
import json
import subprocess
import sys

target = sys.argv[1]
tree = json.loads(subprocess.check_output(["i3-msg", "-t", "get_tree"]))


def find_ws(node):
    if node.get("type") == "workspace" and node.get("name") == target:
        return node
    for c in node.get("nodes", []) + node.get("floating_nodes", []):
        r = find_ws(c)
        if r:
            return r
    return None


def count_windows(node):
    count = 1 if node.get("window") else 0
    for c in node.get("nodes", []) + node.get("floating_nodes", []):
        count += count_windows(c)
    return count


ws = find_ws(tree)
print(count_windows(ws) if ws else 0)
