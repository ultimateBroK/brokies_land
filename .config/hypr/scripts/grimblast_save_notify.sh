#!/bin/bash

# Kiểm tra kiểu chụp (screen/output/active/area)
MODE="$1"
[ -z "$MODE" ] && MODE="screen"

# Thư mục lưu ảnh
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Tên file theo thời gian
FILENAME="Screenshot_${MODE}_$(date +%Y-%m-%d_%H-%M-%S).png"
# FILENAME="${MODE^}_$(date +%b-%d_%H-%M).png"
FULLPATH="$DIR/$FILENAME"

# Chụp ảnh bằng grimblast
grimblast save "$MODE" "$FULLPATH"

# Copy ảnh vào clipboard
wl-copy < "$FULLPATH"

# Gửi thông báo có ảnh preview
dunstify -i "$FULLPATH" "📸 Screenshot ($MODE)" "$FILENAME copied to clipboard"

