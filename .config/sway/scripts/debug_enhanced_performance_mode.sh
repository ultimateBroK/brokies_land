#!/bin/bash
# enhanced_performance_mode.sh - Quản lý hiệu suất Hyprland

# Thiết lập timeout cho toàn bộ script để tránh treo vô hạn
# Nếu script chạy quá 60 giây, nó sẽ tự kết thúc
TIMEOUT_SECONDS=60
SCRIPT_START_TIME=$(date +%s)

# Hàm kiểm tra thời gian chạy
check_timeout() {
    current_time=$(date +%s)
    elapsed=$((current_time - SCRIPT_START_TIME))
    if [ $elapsed -gt $TIMEOUT_SECONDS ]; then
        echo "ERROR: Script timeout after ${TIMEOUT_SECONDS}s" >> "$HOME/.config/hypr/performance_mode.log"
        exit 1
    fi
}

# Thiết lập trap để bắt các tín hiệu và làm sạch tài nguyên
trap 'echo "Script interrupted" >> "$HOME/.config/hypr/performance_mode.log"; exit 1' INT TERM

# --- Cấu hình và biến môi trường ---
HYPR_CONFIG="$HOME/.config/hypr"
CURRENT_MODE_FILE="$HYPR_CONFIG/.current_mode"
NOTIFICATION_TIMEOUT=3000 # Thời gian hiển thị thông báo (ms)
LOG_FILE="$HYPR_CONFIG/performance_mode.log"
DEBUG_MODE=true # Đặt thành true để bật chế độ debug

# --- Icon paths ---
ICON_DIR="$HYPR_CONFIG/icons"
ICON_NORMAL="$ICON_DIR/normal.png"
ICON_BALANCED="$ICON_DIR/balanced.png"
ICON_PERFORMANCE="$ICON_DIR/performance.png"
ICON_GAMING="$ICON_DIR/gaming.png"
ICON_BATTERY="$ICON_DIR/battery.png"
ICON_PRESENTATION="$ICON_DIR/presentation.png"
ICON_INFO="$ICON_DIR/info.png"

# Tìm đường dẫn tuyệt đối của các lệnh
HYPRCTL=$(which hyprctl 2>/dev/null || echo "/usr/bin/hyprctl")
NOTIFY_SEND=$(which notify-send 2>/dev/null || echo "/usr/bin/notify-send")
TOFI=$(which tofi 2>/dev/null || echo "/usr/bin/tofi")
WOFI=$(which wofi 2>/dev/null || echo "/usr/bin/wofi")
ROFI=$(which rofi 2>/dev/null || echo "/usr/bin/rofi")

# --- Khởi tạo và kiểm tra ---
# Tạo thư mục và file log nếu chưa tồn tại
mkdir -p "$HYPR_CONFIG" "$ICON_DIR"
touch "$LOG_FILE"

# Hàm ghi log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    if [ "$DEBUG_MODE" = true ]; then
        echo "[LOG] $1"
    fi
}

# Hàm debug
debug() {
    if [ "$DEBUG_MODE" = true ]; then
        echo "[DEBUG] $1" >> "$LOG_FILE"
        echo "[DEBUG] $1"
    fi
}

# Hàm kiểm tra lỗi và ghi log
check_error() {
    if [ $? -ne 0 ]; then
        log "ERROR: $1"
        $NOTIFY_SEND -t 3000 -i "dialog-error" "Performance Mode Error" "$1"
        return 1
    fi
    return 0
}

# Kiểm tra đường dẫn các lệnh
check_paths() {
    debug "Checking critical paths..."
    
    for cmd_name in HYPRCTL NOTIFY_SEND TOFI WOFI ROFI; do
        cmd_path=${!cmd_name}
        if [ -x "$cmd_path" ]; then
            debug "Found $cmd_name at $cmd_path"
        else
            debug "WARNING: $cmd_name not found at $cmd_path"
        fi
    done
    
    debug "HOME=$HOME"
    debug "HYPR_CONFIG=$HYPR_CONFIG"
    debug "Current directory: $(pwd)"
    debug "PATH=$PATH"
    debug "USER=$(whoami)"
    debug "SHELL=$SHELL"
}

# Hàm thực thi hyprctl một cách an toàn
execute_hyprctl() {
    local cmd="$1"
    local value="$2"
    
    debug "Executing: hyprctl $cmd $value"
    $HYPRCTL "$cmd" "$value" 2>/dev/null || {
        log "WARNING: Failed to execute 'hyprctl $cmd $value'"
        return 1
    }
    return 0
}

# Hiển thị thông báo với biểu tượng
show_notification() {
    check_timeout
    
    local mode="$1"
    local title="$2"
    local message="$3"
    local icon=""
    
    case "$mode" in
        normal)
            icon="$ICON_NORMAL"
            [ ! -f "$icon" ] && icon="preferences-system"
            ;;
        balanced)
            icon="$ICON_BALANCED"
            [ ! -f "$icon" ] && icon="preferences-system-performance"
            ;;
        performance)
            icon="$ICON_PERFORMANCE"
            [ ! -f "$icon" ] && icon="system-run"
            ;;
        gaming)
            icon="$ICON_GAMING"
            [ ! -f "$icon" ] && icon="applications-games"
            ;;
        battery)
            icon="$ICON_BATTERY"
            [ ! -f "$icon" ] && icon="battery-good"
            ;;
        presentation)
            icon="$ICON_PRESENTATION"
            [ ! -f "$icon" ] && icon="video-display"
            ;;
        info)
            icon="$ICON_INFO"
            [ ! -f "$icon" ] && icon="dialog-information"
            ;;
        error)
            icon="dialog-error"
            ;;
    esac
    
    # Hiển thị thanh tiến trình trong thông báo
    progress=""
    if [ "$mode" != "info" ] && [ "$mode" != "error" ]; then
        case "$mode" in
            normal)
                progress="<i>Visual: ███████ Performance: ██░░░</i>"
                ;;
            balanced)
                progress="<i>Visual: ████░░░ Performance: ████░</i>"
                ;;
            performance)
                progress="<i>Visual: ██░░░░░ Performance: ██████</i>"
                ;;
            gaming)
                progress="<i>Visual: ░░░░░░░ Performance: ███████</i>"
                ;;
            battery)
                progress="<i>Visual: ██░░░░░ Performance: ██░░░░░</i>"
                ;;
            presentation)
                progress="<i>Visual: █████░░ Performance: ███░░░░</i>"
                ;;
        esac
        
        message="$message\n\n$progress"
    fi
    
    # Sử dụng notify-send với đường dẫn đầy đủ
    debug "Sending notification: [$title] $message"
    $NOTIFY_SEND -t $NOTIFICATION_TIMEOUT -i "$icon" "$title" "$message" -h string:x-canonical-private-synchronous:hypr-mode
    
    # Đảm bảo thông báo được hiển thị
    sleep 0.2
    
    # Ghi log thông báo
    log "Notification: [$title] $message"
}

# Hàm test thông báo
test_notification() {
    debug "Testing notification system..."
    $NOTIFY_SEND -t 3000 "Test Notification" "This is a test notification from performance script"
    sleep 0.5
    # Kiểm tra kết quả
    if [ $? -eq 0 ]; then
        debug "Notification test: SUCCESS"
    else
        debug "Notification test: FAILED"
    fi
}

# Hàm xử lý việc thay đổi CPU governor
setup_cpu_governor() {
    check_timeout
    
    local governor="$1"
    
    debug "Attempting to set CPU governor to: $governor"
    
    # Kiểm tra xem có thể thay đổi governor không
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ]; then
        # Kiểm tra governor hiện tại
        current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
        
        # Chỉ thay đổi nếu khác với governor hiện tại
        if [ "$current_governor" = "$governor" ]; then
            debug "CPU governor already set to $governor, skipping"
            return 0
        fi
        
        # Lấy danh sách governor có sẵn
        if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ]; then
            available_governors=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
            debug "Available governors: $available_governors"
            
            # Kiểm tra xem governor yêu cầu có tồn tại không
            if ! echo "$available_governors" | grep -q "$governor"; then
                log "WARNING: Governor '$governor' not available. Using system default."
                return 1
            fi
        fi
        
        # Thử thay đổi governor
        if sudo -n true 2>/dev/null; then
            # Sudo không cần mật khẩu
            debug "Has sudo privileges without password"
            # Sử dụng timeout để tránh bị treo nếu lệnh không thành công
            timeout 2 sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor <<< "$governor" > /dev/null 2>&1 || {
                debug "Failed to set CPU governor with sudo, ignoring"
            }
            
            # Xác nhận thay đổi
            sleep 0.5 # Chờ một chút để đảm bảo thay đổi được áp dụng
            current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
            if [ "$current_governor" = "$governor" ]; then
                debug "Successfully set CPU governor to $governor"
            else
                log "WARNING: Failed to set CPU governor to $governor, current: $current_governor"
            fi
        else
            # Nếu không có quyền sudo, chỉ ghi log và bỏ qua
            log "No sudo permissions to change CPU governor to $governor"
            debug "To enable changing CPU governor without password, run:"
            debug "sudo sh -c 'echo \"$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor\" > /etc/sudoers.d/cpu_governor'"
        fi
    else
        log "CPU governor files not found, skipping CPU governor change"
    fi
}

# Test CPU governor
test_cpu_governor() {
    debug "Testing CPU governor change..."
    current_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
    debug "Current CPU governor: $current_governor"
    
    # Kiểm tra quyền sudo
    if sudo -n true 2>/dev/null; then
        debug "Has sudo privileges without password"
    else
        debug "No sudo privileges without password"
    fi
    
    # Liệt kê các governor có sẵn
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ]; then
        available_governors=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
        debug "Available governors: $available_governors"
    else
        debug "Cannot determine available governors"
    fi
}

# --- Định nghĩa các chế độ ---
setup_normal_mode() {
    check_timeout
    
    log "Setting up normal mode"
    execute_hyprctl keyword "animations:enabled true"
    execute_hyprctl keyword "decoration:blur:enabled true"
    execute_hyprctl keyword "decoration:blur:size 3"
    execute_hyprctl keyword "decoration:blur:passes 1"
    execute_hyprctl keyword "decoration:shadow:enabled true"
    execute_hyprctl keyword "decoration:rounding 10"
    execute_hyprctl keyword "general:gaps_in 5"
    execute_hyprctl keyword "general:gaps_out 5"
    execute_hyprctl keyword "decoration:active_opacity 1.0"
    execute_hyprctl keyword "decoration:inactive_opacity 1.0"
    execute_hyprctl keyword "animations:animation borderangle,1,60,modernBounce,loop"
    execute_hyprctl keyword "misc:animate_mouse_windowdragging true"
    execute_hyprctl keyword "misc:animate_manual_resizes true"
    
    # Đặt CPU governor là schedutil (balanced)
    setup_cpu_governor "schedutil"
}

setup_balanced_mode() {
    check_timeout
    
    log "Setting up balanced mode"
    execute_hyprctl keyword "animations:enabled true"
    execute_hyprctl keyword "decoration:blur:enabled true"
    execute_hyprctl keyword "decoration:blur:size 2"
    execute_hyprctl keyword "decoration:blur:passes 1"
    execute_hyprctl keyword "decoration:shadow:enabled true"
    execute_hyprctl keyword "decoration:shadow:render_power 2"
    execute_hyprctl keyword "decoration:rounding 8"
    execute_hyprctl keyword "general:gaps_in 3"
    execute_hyprctl keyword "general:gaps_out 3"
    execute_hyprctl keyword "decoration:active_opacity 1.0"
    execute_hyprctl keyword "decoration:inactive_opacity 1.0"
    execute_hyprctl keyword "animations:animation borderangle,0,0,easeInOutSine"
    execute_hyprctl keyword "misc:animate_mouse_windowdragging false"
    execute_hyprctl keyword "misc:animate_manual_resizes false"
    
    # Đặt CPU governor là schedutil (balanced)
    setup_cpu_governor "schedutil"
}

setup_performance_mode() {
    check_timeout
    
    log "Setting up performance mode"
    execute_hyprctl keyword "animations:enabled false"
    execute_hyprctl keyword "decoration:blur:enabled false"
    execute_hyprctl keyword "decoration:shadow:enabled false"
    execute_hyprctl keyword "decoration:rounding 0"
    execute_hyprctl keyword "general:gaps_in 0"
    execute_hyprctl keyword "general:gaps_out 0"
    execute_hyprctl keyword "decoration:active_opacity 1.0"
    execute_hyprctl keyword "decoration:inactive_opacity 1.0"
    execute_hyprctl keyword "misc:animate_mouse_windowdragging false"
    execute_hyprctl keyword "misc:animate_manual_resizes false"
    
    # Đặt CPU governor là performance
    setup_cpu_governor "performance"
}

setup_gaming_mode() {
    check_timeout
    
    log "Setting up gaming mode"
    # Tối ưu cho gaming - tắt tất cả hiệu ứng
    execute_hyprctl keyword "animations:enabled false"
    # [phần cũ giữ nguyên]
    
    # Kích hoạt gamemode (nếu đã cài đặt) - với timeout chặt chẽ
    if command -v gamemoded &> /dev/null; then
        debug "Starting gamemode"
        # Dừng gamemode nếu đang chạy
        execute_with_timeout "gamemoded -r" || debug "Could not reset gamemode, ignoring"
        
        # Chạy gamemoded không đợi kết quả và đảm bảo chạy trong background
        (nohup gamemoded >/dev/null 2>&1 &) &
        debug "Gamemode start request sent"
    else
        log "gamemode not installed, skipping"
    fi
    
    # Đặt CPU governor là performance
    setup_cpu_governor "performance"
}

setup_battery_mode() {
    check_timeout
    
    log "Setting up battery mode"
    execute_hyprctl keyword "animations:enabled false"
    execute_hyprctl keyword "decoration:blur:enabled false"
    execute_hyprctl keyword "decoration:shadow:enabled false"
    execute_hyprctl keyword "decoration:rounding 5"
    execute_hyprctl keyword "general:gaps_in 3"
    execute_hyprctl keyword "general:gaps_out 3"
    execute_hyprctl keyword "decoration:active_opacity 1.0"
    execute_hyprctl keyword "decoration:inactive_opacity 0.9"
    execute_hyprctl keyword "misc:vfr true"
    
    # Đặt CPU governor là powersave
    setup_cpu_governor "powersave"
}

setup_presentation_mode() {
    check_timeout
    
    log "Setting up presentation mode"
    execute_hyprctl keyword "animations:enabled true"
    execute_hyprctl keyword "decoration:blur:enabled true"
    execute_hyprctl keyword "decoration:blur:size 2"
    execute_hyprctl keyword "decoration:blur:passes 1"
    execute_hyprctl keyword "decoration:shadow:enabled true"
    execute_hyprctl keyword "decoration:rounding 10"
    execute_hyprctl keyword "general:gaps_in 8"
    execute_hyprctl keyword "general:gaps_out 8"
    execute_hyprctl keyword "decoration:active_opacity 1.0"
    execute_hyprctl keyword "decoration:inactive_opacity 0.9"
    execute_hyprctl keyword "misc:mouse_move_enables_dpms true"
    execute_hyprctl keyword "misc:key_press_enables_dpms true"
    
    # Vô hiệu hóa screensaver/lock bằng cách dừng hypridle
    if systemctl --user is-active hypridle &>/dev/null; then
        systemctl --user stop hypridle &>/dev/null || debug "Failed to stop hypridle, ignoring"
        echo "hypridle" > /tmp/presentation_mode_service
        log "Stopped hypridle for presentation mode"
    else
        log "hypridle not active, nothing to stop"
    fi
    
    # Đặt CPU governor là schedutil
    setup_cpu_governor "schedutil"
}

# Lưu trạng thái chế độ hiện tại
save_current_mode() {
    echo "$1" > "$CURRENT_MODE_FILE"
    log "Saved current mode: $1"
}

# Hiển thị giao diện người dùng để chọn chế độ
show_mode_picker() {
    check_timeout
    
    log "Opening mode picker"
    
    local MODE=""
    local PICKER_FOUND=false
    
    # Thử sử dụng tofi
    if [ -x "$TOFI" ]; then
        debug "Using tofi for mode selection"
        MODE=$(echo -e "normal\nbalanced\nperformance\ngaming\nbattery\npresentation\ninfo" | $TOFI --prompt-text "Select performance mode: ")
        PICKER_FOUND=true
    # Thử sử dụng rofi
    elif [ -x "$ROFI" ]; then
        debug "Using rofi for mode selection"
        MODE=$(echo -e "normal\nbalanced\nperformance\ngaming\nbattery\npresentation\ninfo" | $ROFI -dmenu -p "Select performance mode:")
        PICKER_FOUND=true
    # Thử sử dụng wofi
    elif [ -x "$WOFI" ]; then
        debug "Using wofi for mode selection"
        MODE=$(echo -e "normal\nbalanced\nperformance\ngaming\nbattery\npresentation\ninfo" | $WOFI -d -p "Select performance mode:")
        PICKER_FOUND=true
    fi
    
    check_timeout
    
    # Nếu không tìm thấy công cụ chọn
    if [ "$PICKER_FOUND" = false ]; then
        log "ERROR: No UI picker (tofi, rofi, or wofi) found"
        show_notification "error" "Performance Mode Error" "No UI picker (tofi, rofi, or wofi) found.\nPlease install one of these applications."
        exit 1
    fi
    
    # Chỉ áp dụng nếu người dùng đã chọn một chế độ
    if [ -n "$MODE" ]; then
        debug "User selected mode: $MODE"
        apply_mode "$MODE"
    else
        log "Mode selection canceled by user"
        exit 0
    fi
}

# Hiển thị thông tin về chế độ hiện tại
show_mode_info() {
    check_timeout
    
    local CURRENT_MODE="unknown"
    if [ -f "$CURRENT_MODE_FILE" ]; then
        CURRENT_MODE=$(cat "$CURRENT_MODE_FILE")
    fi
    
    log "Showing info for mode: $CURRENT_MODE"
    
    case "$CURRENT_MODE" in
        normal)
            DESC="Full animations and effects enabled.\nIdeal for normal desktop usage with a strong emphasis on visual appeal."
            ;;
        balanced)
            DESC="Reduced effects for better performance.\nA good compromise between visual effects and system responsiveness."
            ;;
        performance)
            DESC="Minimal effects for maximum performance.\nIdeal for resource-intensive applications like video editing or 3D modeling."
            ;;
        gaming)
            DESC="Optimized for gaming with CPU performance governor.\nMaximizes FPS by disabling all unnecessary visual effects."
            ;;
        battery)
            DESC="Power saving optimizations enabled.\nExtends battery life while maintaining usability."
            ;;
        presentation)
            DESC="Optimized for presentations with screen-lock disabled.\nPrevents interruptions during important presentations."
            ;;
        *)
            DESC="Current mode information unavailable.\nSelect a mode to configure your desktop experience."
            ;;
    esac
    
    # Hiển thị phím tắt trong thông tin
    SHORTCUTS="Keyboard shortcuts:\n• Super+Alt+0: Open mode selector\n• Super+Alt+1-6: Switch modes\n• Super+Alt+i: Show mode info"
    
    # Hiển thị thông tin hệ thống
    SYSTEM_INFO=$(get_system_info)
    
    show_notification "info" "Current Mode: $CURRENT_MODE" "$DESC\n\n$SYSTEM_INFO\n\n$SHORTCUTS"
    exit 0
}

# Khôi phục trạng thái trước đó
cleanup_previous_mode() {
    log "Cleaning up previous mode settings"
    
    # Ghi log chi tiết
    debug "Starting cleanup with PID: $$"
    
    # Dừng gamemode với timeout nghiêm ngặt
    if command -v gamemoded &> /dev/null; then
        debug "Attempting to reset gamemode"
        execute_with_timeout "gamemoded -r" || debug "Gamemode reset timed out, ignoring"
    fi
    
    # Khởi động lại các dịch vụ đã dừng - với timeout
    if [ -f /tmp/presentation_mode_service ]; then
        service=$(cat /tmp/presentation_mode_service)
        if [ "$service" = "hypridle" ]; then
            debug "Restarting hypridle service"
            execute_with_timeout "systemctl --user start hypridle" || debug "Failed to restart hypridle, ignoring"
        fi
        rm -f /tmp/presentation_mode_service
    fi
    
    debug "Cleanup completed"
    check_timeout
}

# Hiển thị thông tin hệ thống hiện tại
get_system_info() {
    check_timeout
    
    # Lấy thông tin CPU governor
    local cpu_governor="unknown"
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ]; then
        cpu_governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    fi
    
    # Lấy thông tin CPU usage một cách nhanh chóng
    local cpu_usage="unknown"
    if [ -f "/proc/stat" ]; then
        local cpu_data=$(grep '^cpu ' /proc/stat)
        local user=$(echo $cpu_data | awk '{print $2}')
        local nice=$(echo $cpu_data | awk '{print $3}')
        local system=$(echo $cpu_data | awk '{print $4}')
        local idle=$(echo $cpu_data | awk '{print $5}')
        local total=$((user + nice + system + idle))
        local usage=$((100 - (idle * 100 / total)))
        cpu_usage="${usage}%"
    fi
    
    # Lấy thông tin RAM usage
    local ram_usage="unknown"
    if command -v free &> /dev/null; then
        ram_usage=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')
    fi
    
    # Lấy thông tin game mode
    local gamemode_status="inactive"
    if command -v gamemoded &> /dev/null; then
        if pgrep -x "gamemoded" > /dev/null; then
            gamemode_status="active"
        fi
    fi
    
    echo "System information:\nCPU: ${cpu_usage} (${cpu_governor}) | RAM: ${ram_usage} | GameMode: ${gamemode_status}"
}

# Phân tích log
analyze_log() {
    check_timeout
    
    echo "Phân tích log performance mode..."
    
    # Đếm số lần chạy script thành công
    success_count=$(grep "Performance Mode Script Completed" "$LOG_FILE" | wc -l)
    
    # Đếm số lỗi
    error_count=$(grep "ERROR" "$LOG_FILE" | wc -l)
    
    # Hiển thị thông tin
    echo "Số lần chạy thành công: $success_count"
    echo "Số lỗi gặp phải: $error_count"
    
    if [ $error_count -gt 0 ]; then
        echo "Các lỗi gần đây:"
        grep "ERROR" "$LOG_FILE" | tail -5
    fi
    
    # Hiển thị thời gian gần đây nhất script được chạy
    last_run=$(grep "Performance Mode Script Started" "$LOG_FILE" | tail -1)
    echo "Lần chạy gần nhất: $last_run"
}

# Kiểm tra và cài đặt các yêu cầu cần thiết
check_requirements() {
    check_timeout
    
    local missing_deps=()
    
    # Kiểm tra các lệnh cần thiết
    if [ ! -x "$HYPRCTL" ]; then
        missing_deps+=("hyprctl")
    fi
    
    if [ ! -x "$NOTIFY_SEND" ]; then
        missing_deps+=("notify-send")
    fi
    
    # Kiểm tra ít nhất một trong các công cụ chọn
    if [ ! -x "$TOFI" ] && [ ! -x "$WOFI" ] && [ ! -x "$ROFI" ]; then
        missing_deps+=("tofi/wofi/rofi")
    fi
    
    # Nếu thiếu lệnh cần thiết, hiển thị thông báo
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log "ERROR: Missing required dependencies: ${missing_deps[*]}"
        $NOTIFY_SEND -t 5000 -i "dialog-error" "Performance Mode Error" \
            "Missing required dependencies: ${missing_deps[*]}\n\nPlease install them to use this script."
        exit 1
    fi
    
    # Kiểm tra quyền truy cập Hyprland
    if ! $HYPRCTL monitors &> /dev/null; then
        log "ERROR: Cannot communicate with Hyprland"
        $NOTIFY_SEND -t 5000 -i "dialog-error" "Performance Mode Error" \
            "Cannot communicate with Hyprland.\nIs Hyprland running and are you using it now?"
        exit 1
    fi
    
    return 0
}

# Áp dụng chế độ được chọn
apply_mode() {
    # Kiểm tra các yêu cầu cần thiết
    check_requirements
    
    local mode="$1"
    local prev_mode=""
    
    if [ -f "$CURRENT_MODE_FILE" ]; then
        prev_mode=$(cat "$CURRENT_MODE_FILE")
    fi
    
    debug "Current mode: $prev_mode, Requested mode: $mode"
    
    # Nếu chuyển đến cùng một chế độ, hiển thị thông tin và thoát
    if [ "$prev_mode" = "$mode" ] && [ "$mode" != "info" ]; then
        show_notification "$mode" "Already in $mode mode" "No changes needed.\n\nSystem information:\n$(get_system_info)"
        exit 0
    fi
    
    # Dọn dẹp các thiết lập trước đó
    cleanup_previous_mode
    check_timeout
    
    # Áp dụng thiết lập chế độ mới
    case "$mode" in
        normal)
            setup_normal_mode
            show_notification "normal" "Normal Mode Activated" "Full animations and effects enabled.\nOptimized for visual appeal."
            save_current_mode "normal"
            ;;
        balanced)
            setup_balanced_mode
            show_notification "balanced" "Balanced Mode Activated" "Reduced effects for better performance.\nGood balance of visuals and speed."
            save_current_mode "balanced"
            ;;
        performance)
            setup_performance_mode
            show_notification "performance" "Performance Mode Activated" "Minimal effects for maximum performance.\nOptimized for resource-intensive tasks."
            save_current_mode "performance"
            ;;
        gaming)
            setup_gaming_mode
            show_notification "gaming" "Gaming Mode Activated" "Maximum performance configuration.\nCPU governor: performance\nGamemode: active"
            save_current_mode "gaming"
            ;;
        battery)
            setup_battery_mode
            show_notification "battery" "Battery Saving Mode Activated" "Power saving optimizations enabled.\nCPU governor: powersave\nVisual effects minimized."
            save_current_mode "battery"
            ;;
        presentation)
            setup_presentation_mode
            show_notification "presentation" "Presentation Mode Activated" "Screen-lock disabled.\nOptimized for presentations.\nModerate visual effects."
            save_current_mode "presentation"
            ;;
        info)
            show_mode_info  # show_mode_info đã có exit 0
            ;;
        test-notification)
            test_notification
            exit 0
            ;;
        test-cpu)
            test_cpu_governor
            exit 0
            ;;
        analyze-log)
            analyze_log
            exit 0
            ;;
        debug)
            DEBUG_MODE=true
            check_paths
            log "Debug mode activated"
            show_notification "info" "Debug Mode" "Script diagnostics activated.\nCheck terminal output for details."
            exit 0
            ;;
        *)
            show_mode_picker  # show_mode_picker đã có exit 0/1
            ;;
    esac
    
    log "Performance Mode Script Completed"
    # Thoát script sau khi hoàn thành
    exit 0
}

# Hàm main - điểm vào chính của script
main() {
    log "--- Performance Mode Script Started: Args: $* ---"
    
    # Nếu không có đối số, mở menu chọn chế độ
    if [ $# -eq 0 ]; then
        apply_mode ""
    else
        apply_mode "$1"
    fi
}

execute_with_timeout() {
    local cmd="$1"
    local timeout_seconds=3  # Thời gian tối đa cho phép lệnh chạy
    
    debug "Running command with timeout: $cmd"
    timeout $timeout_seconds bash -c "$cmd" 2>/dev/null || {
        debug "Command timed out or failed: $cmd"
        return 1
    }
    return 0
}

# Gọi hàm main với tất cả đối số
main "$@"
