#!/bin/bash

hostname=$(hostname)
user=$(whoami)

overwrite_msg="Do you want to overwrite? (Y/n): "

function echo_msg {
  echo -e "[\033[0;34mINFO\033[0;0m] - $1"
}

function cp_to_local {
  local src_file="$1"
  local dst_file="$2"
  local parent_dir=$(dirname $dst_file)

  echo_msg "cp $src_file $dst_file"

  # Ensure the parent directory exists before we copy the file to it.
  mkdir -p $parent_dir

  # Copy the file from the repo to local filesystem.
  cp $src_file $dst_file
}

# Go through the directory for this host and the shared directory.
for filename in $(find "./$hostname" "./shared" -mindepth 1 -type f); do
  # Get the filename without the hostname/shared prefix.
  filename_rel_to_home=$(echo "$filename" | sed -r "s/^(\.\/$hostname\/|\.\/shared\/)//")

  # The full filename on this system (in home dir)
  filename_local="/home/$user/$filename_rel_to_home"

  if [ -e "$filename_local" ]; then
    # A local file already exists so we need to do a diff to see if is
    # actually different.
    diff -q $filename_local $filename >/dev/null
    ret="$?"

    if [ "$ret" != 0 ]; then
      # The file is different.

      # Show the user how the file differs.
      echo "----------$filename_local----------"
      diff --color=auto $filename_local $filename

      # Prompt the user if they want to copy the file to the local system. 
      echo -n "$overwrite_msg"
      read user_input

      if [ "$user_input" = "Y" ]; then
        # User has accepted, so copy it!
        cp_to_local $filename $filename_local
      fi
    fi
  else
    # There is no local version of this file, so we can just copy it, because
    # it won't be overwriting anything.
    cp_to_local $filename $filename_local
  fi
done
