# load background image
~/.fehbg
# set keyboard repeat
xset r rate 350 50
# keyboard maps
xmodmap ~/.Xmodmap
# load my X options
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
# start i3 window manager
exec i3
