#       _       _ _            
#      (_)     (_) |           
# __  ___ _ __  _| |_ _ __ ___ 
# \ \/ / | '_ \| | __| '__/ __|
#  >  <| | | | | | |_| | | (__ 
# /_/\_\_|_| |_|_|\__|_|  \___|

# load background image
~/.fehbg
# set keyboard repeat
xset r rate 350 50
# keyboard maps
xmodmap ~/.Xmodmap
# load my X options
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
# start i3 window manager
exec dbus-launch --exit-with-session i3
