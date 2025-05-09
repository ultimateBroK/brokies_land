#!/bin/bash
echo "== Gói Pacman do người dùng cài =="
pacman -Qe > pacman_packages.txt

echo "== Gói AUR (yay) =="
yay -Qm > aur_packages.txt

cat pacman_packages.txt aur_packages.txt > all_installed_apps.txt
echo "Đã lưu toàn bộ danh sách vào all_installed_apps.txt"
