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
    # xrandr --output DVI-D-1 --mode 1920x1200 --rate 59.95 --rotate left --left-of DP-1

    # Good 2nd Monitor
    xrandr --output HDMI-1 --mode 2560x1440 --rate 59.95 --rotate left --left-of DP-1

    feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/oPniCBlk4VU.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/D3U_HehgEmU.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/cryochamber/temple_of_cthulhu.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/9wk28F6v_PQ.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/9wk28F6v_PQ.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/ha9WpE2rLrA.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/6Q3QQ_Rryog.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/ha9WpE2rLrA.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/iNnPSHw8A20.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/keIMfmXcH6w.jpg
    # feh --bg-fill --no-fehbg /home/jcarson/git_clones/wallpapers/youtube-tmp/x8qwFwbsom8.jpg /home/jcarson/git_clones/wallpapers/youtube-tmp/eh2bA1lcIds.jpg

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
