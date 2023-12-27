# Use bind -P to list everything that is and isn't bound.

# remove default 'accept-line' binding
bind -r "\C-j"

# use vi mode
set -o vi

# remove default vi-movement-mode binding
bind -r "\e"

# set ctrl+j to vi-movement-mode
bind "\C-j":vi-movement-mode

# set ctrl+a to beginning-of-line
bind "\C-a":beginning-of-line
# set ctrl+e to end-of-line
bind "\C-e":end-of-line

bind "\C-l":clear-display
