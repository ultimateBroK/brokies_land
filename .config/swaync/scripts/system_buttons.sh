#!/bin/bash

notify-send -u normal -t 3000 "⚙ System" "💾 Logout\n🔁 Reboot\n⏻ Poweroff" -A "Logout" "hyprctl dispatch exit" -A "Reboot" "systemctl reboot" -A "Poweroff" "systemctl poweroff"
