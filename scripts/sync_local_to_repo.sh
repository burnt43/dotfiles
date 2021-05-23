#!/bin/bash

hostname=$(hostname)
user=$(whoami)
home_dir_for_sed="\/home\/$user\/"

function echo_msg {
  echo -e "[\033[0;34mINFO\033[0;0m] - $1"
}

for repo_filename in $(find ./$hostname ./shared -mindepth 1 -type f); do
  system_filename=$(echo "$repo_filename" | sed -r "s/^\.\/($hostname|shared)\//$home_dir_for_sed/")

  if [ -e "$system_filename" ]; then
    echo_msg "copying $system_filename to repo"

    cp $system_filename $repo_filename
  fi
done
