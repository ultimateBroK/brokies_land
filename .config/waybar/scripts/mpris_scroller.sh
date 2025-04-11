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

# Lấy tiêu đề cửa sổ theo PID
pid=$(playerctl -p "$selected_player" metadata mpris:pid 2>/dev/null)
window_title=$(hyprctl clients | awk -v pid="$pid" '
  $1 == "pid:" && $2 == pid {found=1}
  found && $1 == "title:" {print substr($0, index($0,$2)); exit}
')

# Escape dấu &
escape_amp() {
  echo "$1" | sed 's/&/\&amp;/g'
}
artist=$(escape_amp "$artist")
title=$(escape_amp "$title")

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
      icon="<span color='#ff6ac1' font_size='large'>󰗃</span>"
    else
      icon="<span color='#f38ba8' font_size='large'>󰊯</span>"
    fi
    ;;
  *)
    icon="<span color='#f9e2af'>▶</span>"
    ;;
esac

# Max length và chia phần
MAX_LENGTH=40
TITLE_MAX=$((MAX_LENGTH * 2 / 3))   # 2/3 cho title
ARTIST_MAX=$((MAX_LENGTH - TITLE_MAX)) # phần còn lại cho artist

# File lưu trạng thái scroll
title_scroll_file="/tmp/mpris_title_scroll_${selected_player// /_}"
artist_scroll_file="/tmp/mpris_artist_scroll_${selected_player// /_}"
song_id_file="/tmp/mpris_song_${selected_player// /_}"

# Kiểm tra nếu bài hát thay đổi thì reset scroll
current_song_id="${title}_${artist}"
if [ -f "$song_id_file" ]; then
  prev_song_id=$(cat "$song_id_file")
  if [ "$prev_song_id" != "$current_song_id" ]; then
    echo "0" > "$title_scroll_file"
    echo "0" > "$artist_scroll_file"
    echo "$current_song_id" > "$song_id_file"
  fi
else
  echo "0" > "$title_scroll_file"
  echo "0" > "$artist_scroll_file"
  echo "$current_song_id" > "$song_id_file"
fi

# Hàm scroll
scroll_text() {
  local text="$1"
  local max_len="$2"
  local state_file="$3"

  if [ ${#text} -le $max_len ]; then
    echo "$text"
    return
  fi

  local pos=0
  [ -f "$state_file" ] && pos=$(cat "$state_file")

  local padded_text="${text}          ${text}"
  local total_length=${#text}

  local visible_text="${padded_text:$pos:$max_len}"

  pos=$((pos + 1))
  if [ $pos -ge $((total_length + 10)) ]; then
    pos=0
  fi

  echo "$pos" > "$state_file"
  echo "$visible_text"
}

# Hiển thị chính
if [[ "$status" == "Playing" ]]; then
  if [ $(( ${#title} + ${#artist} + 3 )) -gt $MAX_LENGTH ]; then
    scrolled_title=$(scroll_text "$title" $TITLE_MAX "$title_scroll_file")
    scrolled_artist=$(scroll_text "$artist" $ARTIST_MAX "$artist_scroll_file")
    echo "$icon <span foreground='#f5c2e7' font_weight='bold'>$scrolled_title</span> - <span foreground='#cdd6f4'>$scrolled_artist</span>"
  else
    echo "$icon <span foreground='#f5c2e7' font_weight='bold'> $title</span> - <span foreground='#cdd6f4'>$artist</span>"
  fi
else
  echo "$icon <span foreground='#bac2de' font_style='italic'> $title - $artist </span>"
fi
