#!/usr/bin/env zsh

EXPORT_DIR="./conda_env_exports"
mkdir -p "$EXPORT_DIR"

# Lấy danh sách tất cả envs (bỏ dòng đầu, comment, trống)
env_lines=$(conda env list | awk 'NR>2 && $1 !~ /^#/ && $1 != ""')

echo "🔄 Đang xuất tất cả environment Conda (bản đầy đủ)..."

while read -r line; do
    # Lấy cột 1 là env name hoặc path
    env=$(echo "$line" | awk '{print $1}')
    env_safe_name=$(basename "$env" | tr '/' '_' | tr ' ' '_')

    echo "📦 Exporting: $env_safe_name"

    # Nếu là tên: dùng -n, nếu là đường dẫn: dùng -p
    if [[ "$env" != /* ]]; then
        conda env export -n "$env" --no-builds > "$EXPORT_DIR/${env_safe_name}.yml"
    else
        conda env export -p "$env" --no-builds > "$EXPORT_DIR/${env_safe_name}.yml"
    fi
done <<< "$env_lines"

echo "✅ Xuất xong! Tất cả file lưu trong: $EXPORT_DIR"

