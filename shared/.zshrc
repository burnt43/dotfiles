#          _
#         | |
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|
#

# Default/Fallback Config, if no config exists on this host.
default_config_dir="/home/$(whoami)/.zsh-jcarson-config/default"

# Specific config for this host.
local_config_dir="/home/$(whoami)/.zsh-jcarson-config/$(hostname)"

# Order for including config files for.
config_files=(set_zsh_vars zsh_options zsh_plugins define_personal_variables set_distro define_distro_things define_exports define_aliases global_exports global_aliases cache_and_source unset_options key_binds print_info)

for config_filename in "${config_files[@]}"; do
  if [[ -e "${local_config_dir}/${config_filename}" ]]; then
    # A local version of this config exists so use it.
    . ${local_config_dir}/${config_filename}
  else
    # There is no local config, fallback to the default.
    . ${default_config_dir}/${config_filename}
  fi
done

# use : to have the last command return 0 so when I source this file I can
# get a successful return code.
:
