function __ngrok_shuffle__ {
  local input="$1"
  local confd=/etc/httpd/conf.d
  local skip_confd=/etc/httpd/conf.d/skip_include

  # Move all files to the skip directory
  sudo find $confd -maxdepth 1 -type f -exec mv {} $skip_confd \;

  # Set which files are required by the input we chose.
  case "$input" in
    hpbxgui)
      local reqfiles=(00-passenger.conf 20-hpbxgui.conf)
      ;;
    *)
      local reqfiles=all
      ;;
  esac

  # Move the necessary files
  if [[ "$reqfiles" == "all" ]]; then
    sudo mv ${skip_confd}/* $confd
  else
    for fname in ${reqfiles[@]}; do
      sudo mv ${skip_confd}/${fname} $confd
    done
  fi

  # Restart Apache
  sudo systemctl restart httpd
}

function __echo_dev_name__ {
  local input="$1"
  echo -ne "\033[0;33m" && figlet -w 100 $input && echo -ne "\033[0;0m"
}

declare -A activate_webapp_apache_config_mapping
activate_webapp_apache_config_mapping[eqpt_gui]=10-eqpt-gui.conf
activate_webapp_apache_config_mapping[hpbxgui]=20-hpbxgui.conf
activate_webapp_apache_config_mapping[mtt_crm]=30-mtt_crm.conf
activate_webapp_apache_config_mapping[rma]=40-rma.conf
activate_webapp_apache_config_mapping[tickets]=50-tickets.conf

declare -A activate_webapp_env_mapping
activate_webapp_env_mapping[eqpt_gui]=JCARSON_APP_EQPT_GUI
activate_webapp_env_mapping[hpbxgui]=JCARSON_APP_HPBXGUI
#activate_webapp_apache_config_mapping[mtt_crm]=30-mtt_crm.conf
#activate_webapp_apache_config_mapping[rma]=40-rma.conf
activate_webapp_env_mapping[tickets]=JCARSON_APP_TICKETS

webapp_directory=/etc/httpd/conf.d
webapp_skip_directory=${webapp_directory}/skip_include
webapp_env_file=/home/jcarson/.systemd-env/httpd.service
function __activate_webapp__ {
  local input="$1"
  local config_name="${activate_webapp_apache_config_mapping[$input]}"
  local env_name="${activate_webapp_env_mapping[$input]}"

  __echo_proc_step__ "\033[0;35mlooking\033[0;0m up configuration for \033[0;33m${input}\033[0;0m"
  if [[ -z "$config_name" ]]; then
    __echo_fail__
    __echo_error__ "could not apache config for \033[0;33m${input}\033[0;0m"
    return 1
  fi

  if [[ -z "$env_name" ]]; then
    __echo_fail__
    __echo_error__ "could not find environment for \033[0;33m${input}\033[0;0m"
    return 1
  fi
  __echo_ok__

  # Move all non-essential files to skip_include.
  __echo_proc_step__ "\033[0;35mmoving\033[0;0m all non-essential files out of \033[0;33m$webapp_directory\033[0;0m"
  sudo find $webapp_directory -maxdepth 1 -type f -not -name '00-passenger.conf' -exec mv {} ${webapp_directory}/skip_include \;
  __echo_ok__

  # Find the config file in skip_include.
  local potential_file_to_be_promoted="${webapp_skip_directory}/${config_name}"
  __echo_proc_step__ "\033[0;35mpromoting\033[0;0m \033[0;33m${potential_file_to_be_promoted}\033[0;0m"

  if [[ ! -e $potential_file_to_be_promoted ]]; then
    # Nothing found: Can't do nothing here.
    __echo_fail__
    __echo_error__ "Could not find config file \033[0;33m${potential_file_to_be_promoted}\033[0;0m"
    return
  fi

  # File found: Bring it to conf.d.
  __echo_ok__
  sudo mv $potential_file_to_be_promoted $webapp_directory

  __echo_proc_step__ "\033[0;35mchanging\033[0;0m \033[0;33m${webapp_env_file}\033[0;0m to \033[0;33m${env_name}\033[0;0m"
  sed -E -i "s/^(APACHE_APP_DEFINE=)(.*)$/\1${env_name}/g" $webapp_env_file
  __echo_ok__

  __echo_proc_step__ "restarting httpd.service"
  sudo systemctl restart httpd.service
  __echo_ok__
}
