<h1 align="center">🏠 Brokies Land 🏠</h1>

<p align="center"><i>A minimal Hyprland configuration for Linux desktops</i></p>

<p align="center">
  <a href="https://hyprland.org/"><img src="https://img.shields.io/badge/WM-Hyprland-blue" alt="Hyprland Badge"></a>
  <a href="https://github.com/ultimatebrok/brokies_land"><img src="https://img.shields.io/badge/Status-Active-green" alt="Status"></a>
</p>

<div align="center">
  <h2>🎬 See It In Action</h2>
  <p>Check out this video tour of Brokies Land:</p>
  <p>https://github.com/user-attachments/assets/45feadbf-fcd9-45b8-b92e-083919a5048a</p>
</div>

## 🌟 Overview

Brokies Land is a ready-to-use Hyprland configuration designed for Linux users who want a functional and aesthetic desktop environment without spending hours on configuration.

<details>
<summary><b>✨ Features</b></summary>

- **Simple Setup** - Easy installation and configuration process
- **Modern Aesthetic** - Clean, minimal interface with thoughtful design
- **Performance Focused** - Optimized for efficiency on various hardware
- **100% Free** - Open source and freely available
</details>

## 🗂️ Components

<details open>
<summary><b>Configuration Includes</b></summary>
<p>The complete desktop setup with configuration for multiple components</p>
</details>

## 🛠️ Dependencies

<details>
<summary><b>Core Components</b></summary>

- `hyprland` - Wayland compositor
- `xdg-desktop-portal-hyprland` - XDG portal for Hyprland
</details>

<details>
<summary><b>Interface</b></summary>
<div class="content" style="margin-left: 15px;">

- <code>waybar</code> - Status bar for showing system information
- <code>tofi</code> - Minimal and fast application launcher
- <code>dunst</code> - Lightweight notification daemon
</div>
</details>

<details>
<summary><b>Terminal & File Management</b></summary>
<div class="content" style="margin-left: 15px;">

- <code>kitty</code> - Fast, feature-rich GPU-based terminal emulator
- <code>ghostty</code> - Modern, GPU-accelerated terminal alternative
- <code>nautilus</code> - GNOME's file manager with Wayland support
</div>
</details>

<details>
<summary><b>System Tools</b></summary>
<div class="content" style="margin-left: 15px;">

- <code>hyprlock</code> - Secure screen locker for Hyprland
- <code>hypridle</code> - Idle management daemon
- <code>wlogout</code> - Wayland logout menu
- <code>swww</code> - Efficient wallpaper daemon with smooth transitions
- <code>grimblast</code> - Screenshot utility with built-in editor
</div>
</details>

<details>
<summary><b>Appearance</b></summary>
<div class="content" style="margin-left: 15px;">

- <code>nwg-look</code> - GTK settings manager for Wayland
- <code>kvantum</code> - SVG-based Qt theme engine
- <code>noto-fonts-cjk</code> - Google Noto CJK fonts
- <code>bibata-cursor-theme</code> - Modern cursor theme
- <code>fluent-icon-theme-git</code> - Fluent design icon theme
- <a href="https://github.com/vinceliuice/Orchis-theme">Orchis-theme</a> - Modern GTK theme based on Material Design
</div>
</details>

<details>
<summary><b>Additional Utilities</b></summary>
<div class="content" style="margin-left: 15px;">

- <code>cliphist</code> - Wayland clipboard manager
- <code>qt5-wayland</code> & <code>qt6-wayland</code> - Wayland support for Qt applications
- <code>polkit-kde-agent</code> - Authentication agent for system permissions
- <code>brightnessctl</code> - Brightness control utility
- <code>playerctl</code> - Media player controller
- <code>pavucontrol</code> - PulseAudio volume control
- <code>bluez</code> & <code>bluez-utils</code> - Bluetooth protocol stack and utilities
- <code>jamesdsp</code> - Sound effects processor for PipeWire/PulseAudio
- <code>gnome-clocks</code> - Alarms, timers, and world clock application
</div>
</details>

<details>
<summary><b>Applications</b></summary>

- `zen-browser` - Web browser
- `visual-studio-code` - Code editor
- `zed-preview` - Alternative code editor
</details>

### Installation Command

```bash
# Install all dependencies with paru
paru -S hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland waybar kitty dunst tofi nautilus polkit-kde-agent swww brightnessctl grimblast-git hyprlock hypridle wleave-git wlogout playerctl pavucontrol cliphist nwg-look kvantum zen-browser-bin visual-studio-code-bin zed-preview-bin noto-fonts-cjk bluez bluez-utils ghostty jamesdsp bibata-cursor-theme fluent-icon-theme-git gnome-clocks
```

> You can substitute `paru` with `yay` if preferred

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/ultimatebrok/brokies_land.git

# Copy configuration files
cp -r brokies_land/.config/* ~/.config/

# Start Hyprland
Hyprland
```

## ⌨️ Keyboard Shortcuts

<table align="center">
  <tr>
    <th>Shortcut</th>
    <th>Function</th>
  </tr>
  <tr>
    <td><code>SUPER + T</code></td>
    <td>Open terminal</td>
  </tr>
  <tr>
    <td><code>SUPER + E</code></td>
    <td>Open file manager</td>
  </tr>
  <tr>
    <td><code>SUPER + B</code></td>
    <td>Open browser</td>
  </tr>
  <tr>
    <td><code>SUPER + C</code></td>
    <td>Open code editor</td>
  </tr>
  <tr>
    <td><code>SUPER + A</code></td>
    <td>App launcher</td>
  </tr>
  <tr>
    <td><code>SUPER + Q</code></td>
    <td>Close active window</td>
  </tr>
  <tr>
    <td><code>SUPER + F</code></td>
    <td>Toggle fullscreen</td>
  </tr>
  <tr>
    <td><code>SUPER + Space</code></td>
    <td>Toggle floating window</td>
  </tr>
  <tr>
    <td><code>SUPER + Arrow Keys</code></td>
    <td>Navigate between windows</td>
  </tr>
  <tr>
    <td><code>SUPER + SHIFT + 1-0</code></td>
    <td>Move window to workspace</td>
  </tr>
  <tr>
    <td><code>SUPER + 1-0</code></td>
    <td>Switch to workspace</td>
  </tr>
  <tr>
    <td><code>SUPER + L</code></td>
    <td>Lock screen</td>
  </tr>
  <tr>
    <td><code>SUPER + ESCAPE</code></td>
    <td>Show logout menu</td>
  </tr>
  <tr>
    <td><code>SUPER + M</code></td>
    <td>Exit Hyprland</td>
  </tr>
  <tr>
    <td><code>SUPER + N</code></td>
    <td>Change wallpaper</td>
  </tr>
  <tr>
    <td><code>SUPER + V</code></td>
    <td>Show clipboard history</td>
  </tr>
  <tr>
    <td><code>SUPER + S</code></td>
    <td>Toggle scratchpad</td>
  </tr>
  <tr>
    <td><code>Print</code></td>
    <td>Screenshot full screen</td>
  </tr>
  <tr>
    <td><code>SUPER + Print</code></td>
    <td>Screenshot active window</td>
  </tr>
  <tr>
    <td><code>SUPER + ALT + Print</code></td>
    <td>Screenshot selected area</td>
  </tr>
</table>

## 💖 Contributing

Contributions are welcome! If you have improvements, configurations, or bug fixes, please feel free to fork the repository and submit a pull request.

## 📜 License

MIT License. See LICENSE file for details.

<hr>

<p align="center"><i>A minimal, efficient Hyprland configuration for Linux enthusiasts</i></p>
