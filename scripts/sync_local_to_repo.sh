#!/bin/bash

hostname=$(hostname)
user=$(whoami)
home_dir_for_sed="\/home\/$user\/"

function echo_msg {
  echo -e "[\033[0;34mINFO\033[0;0m] - $1"
}

# Go through the directory for this host and the shared directory.
for repo_filename in $(find ./$hostname ./shared -mindepth 1 -type f); do
  # Convert the repo_filename to the filename where this file resides
  # on this system.
  system_filename=$(echo "$repo_filename" | sed -r "s/^\.\/($hostname|shared)\//$home_dir_for_sed/")

  # Check if the file exists locally.
  if [ -e "$system_filename" ]; then
    echo_msg "copying $system_filename to repo"

    # Copy the file from the system to this repo.
    cp $system_filename $repo_filename
  fi
done
