#!/usr/bin/env bash 

#festival --tts $HOME/.config/qtile/welcome_msg &
run lxsession &
#picom &
#/usr/bin/emacs --daemon &
#conky -c $HOME/.config/conky/doomone-qtile.conkyrc
run volumeicon &
run nm-applet &

### UNCOMMENT ONLY ONE OF THE FOLLOWING THREE OPTIONS! ###
# 1. Uncomment to restore last saved wallpaper
#xargs xwallpaper --stretch < ~/.xwallpaper &
# 2. Uncomment to set a random wallpaper on login
# find /usr/share/backgrounds/dtos-backgrounds/ -type f | shuf -n 1 | xargs xwallpaper --stretch &
# 3. Uncomment to set wallpaper with nitrogen
run nitrogen --restore &
run picom -b --config ~/.config/picom.conf