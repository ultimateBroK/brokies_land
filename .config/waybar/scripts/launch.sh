#!/bin/bash
killall waybar
killall mpris_scroller.sh

waybar &
~/.config/waybar/scripts/mpris_scroller.sh &
