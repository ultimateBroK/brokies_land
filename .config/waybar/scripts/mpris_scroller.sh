#!/bin/bash

# Lấy danh sách các player đang phát
players=$(playerctl -l 2>/dev/null)
if [ -z "$players" ]; then
  exit 0
fi

# Duyệt qua các player và chọn player đang phát đầu tiên
selected_player=""
for p in $players; do
  status=$(playerctl -p "$p" status 2>/dev/null)
  if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    selected_player="$p"
    break
  fi
done

[ -z "$selected_player" ] && exit 0

# Lấy thông tin metadata
artist=$(playerctl -p "$selected_player" metadata artist 2>/dev/null)
title=$(playerctl -p "$selected_player" metadata title 2>/dev/null)
status=$(playerctl -p "$selected_player" status 2>/dev/null)

# Kiểm tra tên của cửa sổ (chỉ thực hiện khi player là chrome hoặc chromium)
window_title=""
if [[ "$selected_player" == *"chrome"* || "$selected_player" == *"chromium"* ]]; then
  window_title=$(hyprctl clients | grep -oP '(?<=title: ).*')
fi

# Escape dấu & thành &amp; trong title và artist
artist=$(echo "$artist" | sed 's/&/\&amp;/g')
title=$(echo "$title" | sed 's/&/\&amp;/g')

# Detect app icon theo player name
icon=""
case "$selected_player" in
  *spotify*)
    icon="<span color='#a6e3a1' font_size='large'>󰓇</span>"
    ;;
  *mpv*)
    icon="<span color='#f9e2af' font_size='large'>󰎆</span>"
    ;;
  *vlc*)
    icon="<span color='#f9e2af' font_size='large'>󰕼</span>"
    ;;
  *firefox*)
    icon="<span color='#89b4fa' font_size='large'>󰈹</span>"
    ;;
  *chrome*|*chromium*)
    if [[ "$window_title" == *"YouTube Music"* ]]; then
      icon="<span color='#ff6ac1' font_size='large'>󰗃</span>" # YouTube Music
    else
      icon="<span color='#f38ba8' font_size='large'>󰊯</span>" # Chrome hoặc Chromium khác
    fi
    ;;
  *)
    icon="<span color='#f9e2af'>▶</span>" # Mặc định
    ;;
esac

# Scroll text if combined artist and title is too long
MAX_LENGTH=40  # Maximum combined length before scrolling
SCROLL_STATE_FILE="/tmp/mpris_scroll_${selected_player// /_}"
SONG_ID_FILE="/tmp/mpris_song_${selected_player// /_}"

# Get combined text
combined_text="$artist - $title"
current_song_id="${artist}_${title}"

# Check if song has changed
if [ -f "$SONG_ID_FILE" ]; then
  prev_song_id=$(cat "$SONG_ID_FILE")
  if [ "$prev_song_id" != "$current_song_id" ]; then
    # Song changed, reset position
    echo "0" > "$SCROLL_STATE_FILE"
    echo "$current_song_id" > "$SONG_ID_FILE"
  fi
else
  # First run
  echo "0" > "$SCROLL_STATE_FILE"
  echo "$current_song_id" > "$SONG_ID_FILE"
fi

# Simple scrolling function
scroll_text() {
  local text="$1"
  local max_len="$2"
  
  # If text is short enough, no need to scroll
  if [ ${#text} -le $max_len ]; then
    echo "$text"
    return
  fi
  
  # Read current position
  local pos=0
  [ -f "$SCROLL_STATE_FILE" ] && pos=$(cat "$SCROLL_STATE_FILE")
  
  # Create a scrolling text by duplicating the content for smooth looping
  local padded_text="${text}          ${text}"
  local total_length=${#text}
  
  # Extract the visible portion
  local visible_text="${padded_text:$pos:$max_len}"
  
  # Move position for next time
  pos=$((pos + 1))
  if [ $pos -ge $((total_length + 10)) ]; then
    pos=0
  fi
  
  # Save new position
  echo "$pos" > "$SCROLL_STATE_FILE"
  
  echo "$visible_text"
}

# Main display logic
if [[ "$status" == "Playing" ]]; then
  if [ ${#combined_text} -gt $MAX_LENGTH ]; then
    # Text is too long, scroll it
    scrolled_text=$(scroll_text "$combined_text" $MAX_LENGTH)
    echo "$icon <span foreground='#cdd6f4'>$scrolled_text</span>"
  else
    # No scrolling needed
    echo "$icon <span foreground='#cdd6f4' font_weight='bold'> $artist</span> - <span foreground='#f5c2e7'>$title </span>"
  fi
else
  # Paused state
  echo "$icon <span foreground='#bac2de' font_style='italic'> $artist - $title </span>"
fi
