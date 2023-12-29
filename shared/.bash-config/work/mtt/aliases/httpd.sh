function __httpd_ruby__ {
  local httpd_service_file=/usr/lib/systemd/system/httpd.service
  local ruby_major_version="$1"
  local systemctl_bin=/usr/bin/systemctl
  local sed_bin=/usr/bin/sed
  local httpd_service_name=httpd.service

  case "$ruby_major_version" in
    2)
      sudo $systemctl_bin stop $httpd_service_name && sudo $sed_bin -i 's/-DRuby3/-DRuby2/g' $httpd_service_file && sudo sed -i 's/^# Environment/Environment/g' $httpd_service_file && sudo $systemctl_bin daemon-reload && sudo $systemctl_bin start $httpd_service_name
      ;;
    3)
      sudo $systemctl_bin stop $httpd_service_name && sudo $sed_bin -i 's/-DRuby2/-DRuby3/g' $httpd_service_file && sudo sed -i 's/^Environment/# Environment/g' $httpd_service_file && sudo $systemctl_bin daemon-reload && sudo $systemctl_bin start $httpd_service_name
      ;;
  esac
}
# NOTE: If pacman overwrites the httpd systemd file. This is what is
#   should look like to support httpd_ruby alias:
#     [Unit]
#     Description=Apache Web Server
#     After=network.target remote-fs.target nss-lookup.target

#     [Service]
#     Type=simple
#     ExecStart=/usr/bin/httpd -k start -DFOREGROUND -DRuby3
#     ExecStop=/usr/bin/httpd -k graceful-stop
#     ExecReload=/usr/bin/httpd -k graceful
#     PrivateTmp=true
#     LimitNOFILE=infinity
#     KillMode=mixed
#     # Environment=LD_LIBRARY_PATH=/usr/local/ImageMagick/6.9.12-34/lib

#     [Install]
#     WantedBy=multi-user.target
alias httpd_ruby="__httpd_ruby__"
