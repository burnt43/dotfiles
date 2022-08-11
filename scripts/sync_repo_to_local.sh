#!/bin/bash

declare -A config_to_binary
config_to_binary[.bashrc]=bash
config_to_binary[.config/compton.conf]=compton
config_to_binary[.config/i3/*]=i3
config_to_binary[.config/i3status/*]=i3status
config_to_binary[.config/neofetch/*]=neofetch
config_to_binary[.config/ranger/*]=ranger
config_to_binary[.fehbg]=feh
config_to_binary[.irbrc]=irb
config_to_binary[.npmrc]=npm
config_to_binary[.oh-my-zsh*]=zsh
config_to_binary[.vim/*]=vim
config_to_binary[.vimrc]=vim
config_to_binary[.xinitrc]=xinit
config_to_binary[.Xmodmap]=xmodmap
config_to_binary[.Xresources]=urxvt
config_to_binary[.zsh-jcarson-config*]=zsh
config_to_binary[.zshrc]=zsh

hostname=$(hostname)
user=$(whoami)
home_dir="/home/$user"
ignore_file=".ignore-$hostname"

overwrite_msg="Do you want to overwrite? (Y/n): "

function echo_msg {
  echo -e "[\033[0;34mINFO\033[0;0m] - $1"
}

function echo_warning {
  echo -e "[\033[0;33mWARNING\033[0;0m] - $1"
}

#
# check_config_to_binary
#   $1: filename
#
#   Take in a filename and then check the 'config_to_binary' map to see
#   if there exists a mapping for that filename to a binary on the system.
#   Return 0 if we have the binary, which means that this config file is
#   relevant for this system. If not, then return 1, because we don't want
#   to copy a config file for a program we don't even have.
function check_config_to_binary {
  local filename="$1"
  local lookup="${config_to_binary[$filename]}"
  local binary=""
  local result=""

  if [[ -z "$lookup" ]]; then
    # We could not find a binary simply. We have to go through our map
    # and check if any of them are wildcards (end in *). If so, then we'll
    # see if the input file matches the wildcard. Then whatever the wildcard
    # is mapped to is the binary we're looking for.
    for possible_wildcard in "${!config_to_binary[@]}"; do
      # Look at last character.
      if [[ "${possible_wildcard:0-1}" == "*" ]]; then
        # See if the filename begins with the wildcard. Strip off the last
        # character which is a '*'.
        echo "$filename" | grep -q "^${possible_wildcard::-1}.*"

        if [[ "$?" == "0" ]]; then
          binary="${config_to_binary[$possible_wildcard]}"
          break
        fi
      fi
    done
  else
    # We have found the filename directly, no wildcards needed. The binary
    # we are looking for is simply the value the filename was mapped to.
    binary="$lookup"
  fi

  if [[ -z "$binary" ]]; then
    # No binary was found. Let the user know, so you can possibly install the
    # missing binary.
    echo_warning "Could not find a binary associatied with '$filename'. You may need to edit the associative array in this script to fix this."
    return 1
  else
    # Return the result of 'which' to see if we have the binary.
    which "$binary" 1>/dev/null 2>/dev/null
    result="$?" 

    if [[ "$result" == "0" ]]; then
      return 0
    else
      echo_warning "skipping '$filename'. binary '$binary' not found on system."
      return 1
    fi
  fi
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
for filename in $(find "./$hostname" "./shared" -mindepth 1 -type f 2>/dev/null); do
  # Get the filename without the hostname/shared prefix.
  filename_rel_to_home=$(echo "$filename" | sed -r "s/^\.\/($hostname|shared)\///")

  check_config_to_binary "$filename_rel_to_home"
  [[ "$?" != "0" ]] && continue

  # Check the ignore file for what files we don't want to copy to
  # local system.
  if [ -e "$ignore_file" ]; then
    grep --silent --fixed-strings "$filename_rel_to_home" $ignore_file
    ret="$?"

    if [ "$ret" = 0 ]; then
      echo_msg "ignoring $filename_rel_to_home"
      continue
    fi
  fi

  # The full filename on this system (in home dir)
  filename_local="$home_dir/$filename_rel_to_home"

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
