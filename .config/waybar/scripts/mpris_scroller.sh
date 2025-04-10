#!/bin/bash

# Lấy danh sách các player đang phát
players=$(playerctl -l 2>/dev/null)
[ -z "$players" ] && exit 0

# Lưu trạng thái và timestamp của từng player
declare -A player_statuses
declare -A player_timestamps

for p in $players; do
  status=$(playerctl -p "$p" status 2>/dev/null)
  if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    player_statuses["$p"]="$status"

    metadata=$(playerctl -p "$p" metadata --format "{{title}}_{{artist}}" 2>/dev/null)
    if [[ -n "$metadata" ]]; then
      hash=$(echo "$metadata" | md5sum | awk '{print $1}')
      ts_file="/tmp/player_${p// /_}_$hash.ts"
      if [ ! -f "$ts_file" ]; then
        date +%s > "$ts_file"
      fi
      ts=$(cat "$ts_file")
      player_timestamps["$p"]=$ts
    fi
  fi
done

# Chọn player mới nhất ưu tiên Playing
selected_player=""
latest_ts=0

for p in "${!player_statuses[@]}"; do
  if [[ "${player_statuses[$p]}" == "Playing" ]]; then
    ts=${player_timestamps[$p]:-0}
    if (( ts > latest_ts )); then
      latest_ts=$ts
      selected_player="$p"
    fi
  fi
done

# Nếu không có player đang phát, chọn Paused gần nhất
if [ -z "$selected_player" ]; then
  for p in "${!player_statuses[@]}"; do
    if [[ "${player_statuses[$p]}" == "Paused" ]]; then
      ts=${player_timestamps[$p]:-0}
      if (( ts > latest_ts )); then
        latest_ts=$ts
        selected_player="$p"
      fi
    fi
  done
fi

[ -z "$selected_player" ] && exit 0

# Lấy thông tin metadata
artist=$(playerctl -p "$selected_player" metadata artist 2>/dev/null)
title=$(playerctl -p "$selected_player" metadata title 2>/dev/null)
status=$(playerctl -p "$selected_player" status 2>/dev/null)

# Lấy tên cửa sổ đang phát (nếu là trình duyệt)
pid=$(playerctl -p "$selected_player" metadata mpris:pid 2>/dev/null)
window_title=$(hyprctl clients | awk -v pid="$pid" '
  $1 == "pid:" && $2 == pid {found=1}
  found && $1 == "title:" {print substr($0, index($0,$2)); exit}
')

# Escape HTML entities
escape_amp() {
  echo "$1" | sed 's/&/\&amp;/g'
}

artist=$(escape_amp "$artist")
title=$(escape_amp "$title")

# Cập nhật timestamp nếu bài hát thay đổi
song_id="${title}_${artist}"
hash=$(echo "$song_id" | md5sum | awk '{print $1}')
ts_file="/tmp/player_${selected_player// /_}_$hash.ts"
if [ ! -f "$ts_file" ]; then
  date +%s > "$ts_file"
fi

# Detect icon
icon=""
case "$selected_player" in
  *spotify*) icon="<span color='#a6e3a1' font_size='large'>󰓇</span>" ;;
  *mpv*) icon="<span color='#f9e2af' font_size='large'>󰎆</span>" ;;
  *vlc*) icon="<span color='#f9e2af' font_size='large'>󰕼</span>" ;;
  *firefox*) icon="<span color='#89b4fa' font_size='large'>󰈹</span>" ;;
  *chrome*|*chromium*)
    if [[ "$window_title" == *"YouTube Music"* ]]; then
      icon="<span color='#ff6ac1' font_size='large'>󰗃</span>"
    else
      icon="<span color='#f38ba8' font_size='large'>󰊯</span>"
    fi
    ;;
  *) icon="<span color='#f9e2af'>▶</span>" ;;
esac

# Scrolling logic
MAX_LENGTH=40
SCROLL_STATE_FILE="/tmp/mpris_scroll_${selected_player// /_}"
SONG_ID_FILE="/tmp/mpris_song_${selected_player// /_}"
combined_text="$title - $artist"
current_song_id="${title}_${artist}"

if [ -f "$SONG_ID_FILE" ]; then
  prev_song_id=$(cat "$SONG_ID_FILE")
  if [ "$prev_song_id" != "$current_song_id" ]; then
    echo "0" > "$SCROLL_STATE_FILE"
    echo "$current_song_id" > "$SONG_ID_FILE"
  fi
else
  echo "0" > "$SCROLL_STATE_FILE"
  echo "$current_song_id" > "$SONG_ID_FILE"
fi

scroll_text() {
  local text="$1"
  local max_len="$2"
  local pos=0
  [ -f "$SCROLL_STATE_FILE" ] && pos=$(cat "$SCROLL_STATE_FILE")
  local padded_text="${text}     ${text}"
  local total_length=${#text}
  local visible_text="${padded_text:$pos:$max_len}"
  pos=$((pos + 1))
  [ $pos -ge $((total_length + 5)) ] && pos=0
  echo "$pos" > "$SCROLL_STATE_FILE"
  echo "$visible_text"
}

# Hiển thị
if [[ "$status" == "Playing" ]]; then
  if [ ${#combined_text} -gt $MAX_LENGTH ]; then
    scrolled_text=$(scroll_text "$combined_text" $MAX_LENGTH)
    echo "$icon <span foreground='#cdd6f4'>$scrolled_text</span>"
  else
    echo "$icon <span foreground='#f5c2e7' font_weight='bold'> $title</span> - <span foreground='#cdd6f4'>$artist </span>"
  fi
else
  echo "$icon <span foreground='#bac2de' font_style='italic'> $title - $artist </span>"
fi

