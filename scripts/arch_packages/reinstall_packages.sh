#!/bin/bash

# Script: reinstall_packages.sh
# Mục đích: Cài lại toàn bộ các gói từ danh sách pacman và AUR đã lưu

# Kiểm tra các file danh sách tồn tại
if [[ ! -f pacman_packages.txt ]]; then
    echo "❌ File pacman_packages.txt không tồn tại!"
    exit 1
fi

if [[ ! -f aur_packages.txt ]]; then
    echo "❌ File aur_packages.txt không tồn tại!"
    exit 1
fi

echo "🛠️ Đang cài lại các gói Pacman..."
sudo pacman -S --needed --noconfirm $(cat pacman_packages.txt)

echo "🛠️ Đang cài lại các gói AUR bằng yay..."
yay -S --needed --noconfirm $(cat aur_packages.txt)

echo "✅ Hoàn tất cài đặt!"
