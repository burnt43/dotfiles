#       _       _ _            
#      (_)     (_) |           
# __  ___ _ __  _| |_ _ __ ___ 
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__ 
# /_/\_\_|_| |_|_|\__|_|  \___|

# set keyboard repeat
xset r rate 350 55

# keyboard maps
xmodmap ~/.Xmodmap

# load my X options
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# start i3 window manager
case "$(hostname)" in
  burnt43)
    xrandr --output DP-1 --primary --mode 2560x1440 --rate 59.95

    # Temp Bad 2nd Monitor
    xrandr --output DVI-D-1 --mode 1920x1200 --rate 59.95 --rotate left --left-of DP-1

    # Good 2nd Monitor
    # xrandr --output HDMI-1 --mode 2560x1440 --rate 59.95 --rotate left --left-of DP-1

    feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/oPniCBlk4VU.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg

    exec i3
    ;;
  fakebiz0)
    ~/.fehbg

    exec dbus-launch --exit-with-session i3
    ;;
  jco2)
    ~/.fehbg

    exec dbus-launch --exit-with-session i3
    ;;
esac
