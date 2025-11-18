#       _       _ _            
#      (_)     (_) |           
# __  ___ _ __  _| |_ _ __ ___ 
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__ 
# /_/\_\_|_| |_|_|\__|_|  \___|

# load background image
~/.fehbg

# set keyboard repeat
xset r rate 350 55

# keyboard maps
xmodmap ~/.Xmodmap

# load my X options
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# start i3 window manager
case "$(hostname)" in
  burnt43)
    xrandr --output DP-1 --mode 2560x1440 --rate 59.95
    # Temp Bad 2nd Monitor
    xrandr --output DVI-D-1 --mode 1920x1200 --rate 59.95 --rotate left --left-of DP-1
    # Good 2nd Monitor
    # xrandr --output HDMI-1 --mode 2560x1440 --rate 59.95 --rotate left --left-of DP-1
    exec i3
    ;;
  fakebiz0)
    exec dbus-launch --exit-with-session i3
    ;;
  jco2)
    exec dbus-launch --exit-with-session i3
    ;;
esac
