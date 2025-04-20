<h1 align="center">🏠 Brokies Land 🏠</h1>

<p align="center"><i>A complete configuration for multiple Wayland compositors on Linux desktops</i></p>

<p align="center">
  <a href="https://hyprland.org/"><img src="https://img.shields.io/badge/WM-Hyprland-blue" alt="Hyprland Badge"></a>
  <a href="https://github.com/ultimatebrok/brokies_land"><img src="https://img.shields.io/badge/Status-Active-green" alt="Status"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow" alt="License"></a>
</p>

<div align="center">
  <h2>🎬 See It In Action</h2>
  <p>Check out this video tour of Brokies Land:</p>
  <p>https://github.com/user-attachments/assets/45feadbf-fcd9-45b8-b92e-083919a5048a</p>
</div>

## 🌟 Overview

Brokies Land is a ready-to-use configuration designed for Linux users who want a functional and aesthetic desktop environment without spending hours on configuration. It supports multiple Wayland compositors including Hyprland, Niri, and SwayFX, all combined with modern Wayland components and a carefully curated selection of applications and utilities.

<b>✨ Features</b>

- **Multiple Compositor Support** - Works with Hyprland, Niri, and SwayFX
- **Simple Setup** - Easy installation and configuration process
- **Modern Aesthetic** - Clean, minimal interface with thoughtful design
- **Performance Focused** - Optimized for efficiency on various hardware
- **Fully Integrated** - All components work together seamlessly
- **Customizable** - Easy to modify and adapt to your preferences
- **100% Free** - Open source and freely available

## 🗂️ Components

<details open>
<summary><b>Configuration Includes</b></summary>
<p>The complete desktop setup includes configuration for:</p>

- Hyprland compositor with multi-monitor support
- Waybar status bar with custom modules
- Notification system with Dunst
- Tofi application launcher
- Hyprlock screen locker
- Wallpaper management with smooth transitions
- Media player controls with visual feedback
- Power management and system monitoring
- Screenshot utilities with various capture options
- Clipboard history management
</details>

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

### Optional Compositor Packages

```bash
# Install Niri (column-based Wayland compositor)
paru -S niri-git

# Install SwayFX (enhanced Sway with visual effects)
paru -S swayfx-git
```

> You can substitute `paru` with `yay` if preferred

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/ultimatebrok/brokies_land.git

# Copy configuration files
cp -r brokies_land/.config/* ~/.config/
```

### Starting Hyprland
```bash
# Start Hyprland (default)
Hyprland
```

### Starting Niri
```bash
# Install Niri first if not already installed
# paru -S niri-git

# Start Niri
niri
```

### Starting SwayFX
```bash
# Install SwayFX first if not already installed
# paru -S swayfx-git

# Start SwayFX
swayfx
```

## 🔄 Compositor-Specific Information

<details>
<summary><b>Hyprland</b></summary>
<p>Hyprland is the primary compositor for Brokies Land with full feature support including:</p>

- Dynamic tiling with dwindle layout
- Smooth animations and rounded corners
- Blur effects and shadows
- Special workspaces feature
- Performance mode script integration

<p>The configuration is extensively documented in <code>.config/hypr/hyprland.conf</code></p>
</details>

<details>
<summary><b>Niri</b></summary>
<p>Niri is a modern Wayland compositor with a column-based layout system:</p>

- Simple and predictable window management
- Clean, minimalist approach
- Spring-based animations
- Streamlined configuration with KDL format

<p>The configuration can be found in <code>.config/niri/config.kdl</code></p>

<p><b>Note:</b> Some Hyprland-specific features might not be available in Niri due to architectural differences.</p>
</details>

<details>
<summary><b>SwayFX</b></summary>
<p>SwayFX is an enhanced fork of Sway with additional visual effects:</p>

- Traditional i3-like tiling
- Enhanced blur and visual effects
- Compatibility with most Sway configurations
- Stable and reliable performance

<p>The configuration can be found in <code>.config/sway/config</code></p>

<p><b>Note:</b> Keyboard shortcuts may differ slightly from the Hyprland defaults.</p>
</details>

## ⌨️ Keyboard Shortcuts

<details>
<summary><b>Common Shortcuts (Available in all compositors)</b></summary>
<table align="center">
  <tr>
    <th>Shortcut</th>
    <th>Function</th>
  </tr>
  <tr>
    <td><code>SUPER + Return</code></td>
    <td>Open terminal (Ghostty)</td>
  </tr>
  <tr>
    <td><code>SUPER + E</code></td>
    <td>Open file manager (Nautilus)</td>
  </tr>
  <tr>
    <td><code>SUPER + B</code></td>
    <td>Open browser (Zen Browser)</td>
  </tr>
  <tr>
    <td><code>SUPER + C</code></td>
    <td>Open code editor (Zed)</td>
  </tr>
  <tr>
    <td><code>SUPER + T</code></td>
    <td>Open Trading View</td>
  </tr>
  <tr>
    <td><code>SUPER + A</code></td>
    <td>App launcher (Wofi/Tofi)</td>
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
    <td><code>SUPER + SHIFT + Arrow Keys</code></td>
    <td>Move window in direction</td>
  </tr>
  <tr>
    <td><code>SUPER + 1-0</code></td>
    <td>Switch to workspace</td>
  </tr>
  <tr>
    <td><code>SUPER + SHIFT + 1-0</code></td>
    <td>Move window to workspace</td>
  </tr>
  <tr>
    <td><code>SUPER + L</code></td>
    <td>Lock screen</td>
  </tr>
  <tr>
    <td><code>SUPER + V</code></td>
    <td>Show clipboard history</td>
  </tr>
  <tr>
    <td><code>Print</code></td>
    <td>Screenshot full screen</td>
  </tr>
  <tr>
    <td><code>CTRL + Escape</code></td>
    <td>Restart Waybar</td>
  </tr>
</table>
</details>

<details>
<summary><b>Hyprland-Specific Shortcuts</b></summary>
<table align="center">
  <tr>
    <th>Shortcut</th>
    <th>Function</th>
  </tr>
  <tr>
    <td><code>SUPER + S</code></td>
    <td>Toggle special workspace</td>
  </tr>
  <tr>
    <td><code>SUPER + SHIFT + S</code></td>
    <td>Move to special workspace</td>
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
    <td><code>SUPER + ALT + P</code></td>
    <td>Toggle performance modes</td>
  </tr>
  <tr>
    <td><code>SUPER + Print</code></td>
    <td>Screenshot current output</td>
  </tr>
  <tr>
    <td><code>SUPER + SHIFT + Print</code></td>
    <td>Screenshot active window</td>
  </tr>
  <tr>
    <td><code>SUPER + ALT + Print</code></td>
    <td>Screenshot selected area</td>
  </tr>
  <tr>
    <td><code>SUPER + ESCAPE</code></td>
    <td>Show logout menu</td>
  </tr>
</table>
</details>

<details>
<summary><b>Niri-Specific Notes</b></summary>
<p>Niri uses a column-based layout system rather than the dynamic tiling of Hyprland.</p>
<ul>
  <li>Window movement in Niri often moves entire columns of windows</li>
  <li>Niri doesn't have special workspaces like Hyprland</li>
  <li>To exit Niri, use <code>SUPER + M</code></li>
</ul>
<p>Full keybinding details can be found in <code>.config/niri/config.kdl</code></p>
</details>

<details>
<summary><b>SwayFX-Specific Notes</b></summary>
<p>SwayFX follows the i3-style keyboard shortcuts with some additions.</p>
<ul>
  <li>Layout management uses <code>SUPER + E</code> to toggle between split layouts</li>
  <li>Resize mode can be entered with <code>SUPER + R</code></li>
  <li>To exit SwayFX, use <code>SUPER + SHIFT + E</code></li>
</ul>
<p>Full keybinding details can be found in <code>.config/sway/config</code></p>
</details>

## 🎨 Customization

Brokies Land is designed to be easily customized. Here are some quick customization tips:

- **Wallpapers**: Add your own wallpapers to `.config/assets/backgrounds`
- **Waybar**: Edit `.config/waybar/config.jsonc` to modify the status bar
- **Keybindings**: Adjust `.config/hypr/hyprland.conf` for custom shortcuts
- **Notifications**: Configure `.config/dunst/dunstrc` for notification appearance
- **Colors**: Most components use Catppuccin Mocha theme colors by default

## 💖 Contributing

Contributions are welcome! If you have improvements, configurations, or bug fixes, please feel free to fork the repository and submit a pull request.

## 📜 License

MIT License. See LICENSE file for details.

<hr>

<p align="center"><i>A minimal, efficient Hyprland configuration for Linux enthusiasts</i></p>
