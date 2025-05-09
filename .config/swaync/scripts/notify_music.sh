#!/bin/bash

title=$(playerctl metadata title)
artist=$(playerctl metadata artist)
albumArt=$(playerctl metadata mpris:artUrl | sed 's|file://||')

if [[ -z "$title" ]]; then exit 0; fi

notify-send -a "Now Playing" \
  -u low \
  -h string:image-path:"$albumArt" \
  -h string:x-canonical-private-synchronous:nowplaying \
  "$title" "$artist"
