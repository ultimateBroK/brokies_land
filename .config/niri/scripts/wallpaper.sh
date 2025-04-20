#!/bin/bash

# Cấu hình
WALLPAPER_DIR="$HOME/Pictures/Another_Wallpaper"
WALLPAPER_CACHE="$HOME/wallpapers/pywallpaper.jpg"
CACHE_DIR="$HOME/.cache/wallpaper-previews"
PREVIEW_SIZE="200x150"
MAX_PARALLEL_PROCESSES=4  # Giới hạn số lượng tiến trình song song

# Đảm bảo thư mục cache tồn tại
mkdir -p "$CACHE_DIR"

# Kiểm tra các lệnh cần thiết
check_dependencies() {
    local missing_deps=()
    for cmd in magick find wofi swww wal; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Thiếu các lệnh cần thiết: ${missing_deps[*]}" >&2
        echo "Vui lòng cài đặt chúng trước khi chạy script." >&2
        return 1
    fi
    
    return 0
}

# Tạo và cập nhật cache danh sách hình ảnh 
update_wallpaper_list() {
    local cache_file="$CACHE_DIR/wallpaper_list.txt"
    
    # Nếu file cache không tồn tại hoặc đã cũ (>1 ngày), tạo lại
    if [[ ! -f "$cache_file" || $(find "$cache_file" -mtime +1) ]]; then
        find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort > "$cache_file"
    fi
    
    cat "$cache_file"
}

# Tạo previews hiệu quả
generate_previews() {
    local wallpapers=($(update_wallpaper_list))
    local count=${#wallpapers[@]}
    
    if [[ $count -eq 0 ]]; then
        echo "Không tìm thấy hình ảnh nào trong $WALLPAPER_DIR" >&2
        return 1
    fi
    
    # Xóa cache cũ (>30 ngày)
    find "$CACHE_DIR" -name "*.png" -type f -mtime +30 -delete 2>/dev/null

    # Tạo danh sách hình ảnh cần tạo preview
    local previews_needed=()
    for img in "${wallpapers[@]}"; do
        img_hash=$(echo "$img" | md5sum | cut -d' ' -f1)
        preview_file="$CACHE_DIR/$img_hash.png"
        
        if [[ ! -f "$preview_file" || "$img" -nt "$preview_file" ]]; then
            previews_needed+=("$img")
        fi
    done
    
    local preview_count=${#previews_needed[@]}
    
    # Tạo previews nếu cần
    if [[ $preview_count -gt 0 ]]; then
        echo "Đang tạo $preview_count previews mới..." >&2
        
        # Xử lý từng batch để tránh quá tải hệ thống
        for ((i=0; i<preview_count; i+=$MAX_PARALLEL_PROCESSES)); do
            end=$((i + MAX_PARALLEL_PROCESSES))
            if [[ $end -gt $preview_count ]]; then
                end=$preview_count
            fi
            
            # Xử lý một batch
            for ((j=i; j<end; j++)); do
                img="${previews_needed[$j]}"
                img_hash=$(echo "$img" | md5sum | cut -d' ' -f1)
                preview_file="$CACHE_DIR/$img_hash.png"
                
                # Sử dụng magick thay vì convert
                magick "$img" -resize "$PREVIEW_SIZE" -quality 80 "$preview_file" &
            done
            
            # Đợi batch hiện tại hoàn thành
            wait
        done
    fi
    
    # Output danh sách hình ảnh có preview
    for img in "${wallpapers[@]}"; do
        img_hash=$(echo "$img" | md5sum | cut -d' ' -f1)
        preview_file="$CACHE_DIR/$img_hash.png"
        echo "img:$preview_file:$img"
    done
}

# Áp dụng hình nền
apply_wallpaper() {
    local selected_wallpaper="$1"
    
    # Kiểm tra file
    if [[ ! -f "$selected_wallpaper" ]]; then
        notify-send "Lỗi" "Không tìm thấy file: $selected_wallpaper"
        return 1
    fi
    
    # Thông báo ngắn để người dùng biết đang xử lý
    notify-send -t 2000 "Đang áp dụng hình nền" "$(basename "$selected_wallpaper")"
    
    # Đặt hình nền 
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    
    # Tạo bảng màu từ hình nền (phần quan trọng nhất về hiệu năng)
    wal -i "$selected_wallpaper" -n --cols16
    
    # Lưu hình nền hiện tại ngay lập tức
    cp "$selected_wallpaper" "$WALLPAPER_CACHE"
    
    # Chạy các tác vụ không quan trọng trong nền
    {
        # Cập nhật theme Kitty
        cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
        
        # Cập nhật cava một cách an toàn
        update_cava
        
        # Cập nhật CSS cho notification center
        swaync-client --reload-css
    } &
    
    return 0
}

# Cập nhật cava một cách an toàn
update_cava() {
    cava_config="$HOME/.config/cava/config"
    
    # Kiểm tra file cấu hình cava tồn tại
    [[ ! -f "$cava_config" ]] && return
    
    # Lấy màu từ pywal
    if [[ -f ~/.cache/wal/colors.sh ]]; then
        color1=$(grep 'color2=' ~/.cache/wal/colors.sh | cut -d "'" -f 2)
        color2=$(grep 'color3=' ~/.cache/wal/colors.sh | cut -d "'" -f 2)
        
        if [[ -n "$color1" && -n "$color2" ]]; then
            # Sử dụng tmp file thay vì trực tiếp sed để tránh lỗi
            temp_config=$(mktemp)
            cat "$cava_config" > "$temp_config"
            
            sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$temp_config"
            sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$temp_config"
            
            # Chỉ cập nhật khi thay đổi thành công
            if [[ $? -eq 0 ]]; then
                mv "$temp_config" "$cava_config"
                # Tải lại cava nếu đang chạy
                pkill -USR2 cava 2>/dev/null
            else
                rm "$temp_config"
            fi
        fi
    fi
}

# Hàm chính với xử lý lỗi tốt hơn
main() {
    # Kiểm tra các phụ thuộc
    if ! check_dependencies; then
        exit 1
    fi
    
    # Tạo menu tạm thời để hiển thị khi đang tạo previews
    echo "Đang tải danh sách hình nền..." | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Vui lòng chờ..." &
    loading_pid=$!
    
    # Tạo previews
    previews=$(generate_previews)
    preview_status=$?
    
    # Dừng wofi tạm thời
    kill $loading_pid 2>/dev/null
    
    # Kiểm tra nếu không có previews
    if [[ $preview_status -ne 0 || -z "$previews" ]]; then
        notify-send "Lỗi" "Không thể tạo danh sách hình nền."
        exit 1
    fi
    
    # Hiển thị menu lựa chọn
    choice=$(echo "$previews" | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Chọn Hình Nền:" -n)
    
    # Thoát nếu không có lựa chọn
    [[ -z "$choice" ]] && exit 0
    
    # Trích xuất đường dẫn hình ảnh gốc từ lựa chọn
    selected_wallpaper=$(echo "$choice" | awk -F':' '{print $3}')
    
    # Áp dụng hình nền
    apply_wallpaper "$selected_wallpaper"
}

# Thực thi chương trình với xử lý lỗi
{
    main
} || {
    notify-send "Lỗi" "Chương trình đã bị lỗi. Vui lòng kiểm tra lại."
}
