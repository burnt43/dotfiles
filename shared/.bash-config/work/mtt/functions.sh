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
