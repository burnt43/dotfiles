#!/bin/bash

usage_string="usage: compare.sh DIR1 DIR2"

dir_a=$1
dir_b=$2

function echo_err {
  echo -e "[\033[0;31mERROR\033[0;0m] - $1"
}

function recursive_file_diff {
  local parent_dir="$1"

  for filename in $(ls -a "$parent_dir"); do
    if [ "$filename" = '.' -o "$filename" = '..' ]; then
      continue
    fi

    local fullname="$parent_dir/$filename"
    
    if [ -f "$fullname" ]; then
      local other_fullname=$(echo "$fullname" | sed "s/^$dir_a/$dir_b/")

      if [ -e "$other_fullname" ]; then
        echo "-------------------$fullname-------------------"
        diff --color=auto "$fullname" "$other_fullname"
      fi
    elif [ -d "$fullname" ]; then
      recursive_file_diff "$fullname"
    fi
  done
}

if [ -z "$dir_a" ]; then
  echo_err "no DIR1 given. $usage_string"
  exit 1
fi

if [ -z "$dir_b" ]; then
  echo_err "no DIR2 given. $usage_string"
  exit 1
fi

recursive_file_diff "$dir_a"
