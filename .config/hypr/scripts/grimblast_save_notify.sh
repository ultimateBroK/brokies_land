#!/bin/bash

# Danh sách chế độ chụp
OPTIONS="📺 screen
🖥 output
🔲 active
📐 area"

# Giao diện menu với tất cả các tùy chọn hiển thị
CHOSEN=$(echo -e "$OPTIONS" | wofi --dmenu --insensitive --width 400 --height 200 --prompt="Select a screenshot option:" --lines=4)

# Kiểm tra nếu người dùng không chọn gì
[ -z "$CHOSEN" ] && exit

# Chờ wofi tắt hẳn trước khi chụp (rất quan trọng!)
sleep 0.3

# Trích xuất mode từ biểu tượng
case "$CHOSEN" in
    *screen*) MODE="screen" ;;
    *output*) MODE="output" ;;
    *active*) MODE="active" ;;
    *area*) MODE="area" ;;
    *) exit ;;
esac

# Thư mục lưu ảnh
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Tên file theo thời gian
FILENAME="Screenshot_${MODE}_$(date +%Y-%m-%d_%H-%M-%S).png"
FULLPATH="$DIR/$FILENAME"

# Chụp ảnh bằng grimblast
grimblast save "$MODE" "$FULLPATH"

# Copy ảnh vào clipboard
wl-copy < "$FULLPATH"

# Gửi thông báo có ảnh preview
dunstify -i "$FULLPATH" "📸 Screenshot ($MODE)" "$FILENAME copied to clipboard"