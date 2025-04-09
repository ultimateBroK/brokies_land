#!/bin/bash
if pgrep -x "waybar" > /dev/null; then
    killall waybar
    killall mpris_scroller.sh
else
    waybar &
    $HOME/.config/waybar/scripts/mpris_scroller.sh &
fi
