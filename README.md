# 🏠 Brokies Land 🏠

_Where your desktop dreams are big, but your wallet isn't!_

[![Hyprland Badge](https://img.shields.io/badge/WM-Hyprland-blue)](https://hyprland.org/)
[![Status](https://img.shields.io/badge/Status-Broke%20-green)](https://github.com/ultimatebrok/brokies_land)

## 🌟 What's This All About?

Ever spent all your money on that sweet PC hardware and realized you're too broke to spend hours configuring your desktop? Welcome to Brokies Land! This is a ready-to-rock Hyprland configuration crafted for those who are rich in spirit but challenged in funds.

> "We may be broke, but our desktops? They're priceless." - The Brokie Manifesto

## ✨ Why You'll Love It

-   **Zero Effort Setup** - Because time is money, and you ain't got either to waste on configs.
-   **Looks Like a Million Bucks** - Impress your friends without emptying your already empty pockets.
-   **Copy-Paste Magic** - Why reinvent the wheel when you can just... borrow it?
-   **100% Free, Always** - No premium BS here. Just pure, unadulterated, free goodness.

## 🗂️ What's Inside the Box?

go check it out...I'm lazy to write it all out, lol

## 🛠️ Gear Up: Dependencies

### Core Essentials

The bread and butter (or ramen and water) of this setup:

-   `hyprland` - The compositor that proves you can have nice things without selling a kidney.
-   `xdg-desktop-portal-hyprland` - Because everyone deserves a portal... to a cooler desktop.

### The Bling (Bar)

-   `waybar` - Making you look like you know what you're doing, even if you don't.

### Terminal Time

-   `kitty` or `ghostty` - Terminals that are way too cool for their own good.

### Stay Notified

-   `dunst` - Notifications that are informative without being intrusive (or expensive).

### Launch It!

-   `tofi` - The minimalist app launcher that's big on style.

### File Wrangling

-   `nautilus` - File manager for keeping your digital life (and budget) in order.

### Lock It Down

-   `hyprlock` - A lock screen that screams "premium" without the price tag.
-   `hypridle` - The free alternative to actually paying attention.
-   `wlogout` and `wleave` - Because even logging out should be aesthetically pleasing.

### Eye Candy

-   `swww` - Wallpaper transitions that say, "I'm not broke," even if you are.
-   `grimblast` - Capture your awesome (and free) setup for bragging rights.
-   `nwg-look` - Polish your desktop to a mirror shine.
-   `kvantum` - Make your apps look like they cost more than your car.
-   `noto-fonts-cjk` - Fonts that add a touch of class to your broke existence.

### Theming
- `bibata-cursor-theme`: Cursor theme
- fluent-icon-theme-git`: Icon theme 
- ![Orchis-theme](https://github.com/vinceliuice/Orchis-theme): Shell theme (GTK theme)

> Clone the 2 above and install via script inside
### Clipboard Hero

-   `cliphist` - Clipboard manager that saves you from repeating yourself (and wasting precious time).

### Qt Corner

-   `qt5-wayland` - For those Qt5 apps you can't live without.
-   `qt6-wayland` - Future-proofing your broke life, one Qt6 app at a time.

### Polkit Power

-   `polkit-kde-agent` - The free bouncer for your system's VIP requests.

### Utility Belt

-   `brightnessctl` - Control your screen brightness and save those precious watts.
-   `playerctl` - Control your media without paying for a fancy remote.
-   `pavucontrol` - Audio control that makes you feel like a sound engineer.
-   `bluez` - Bluetooth support for your budget headphones.
-   `bluez-utils` - Bluetooth utilities for when you want to cut the cord (without cutting your budget).
    -   `jamesdsp` - A DSP for your audio that doesn't cost a dime
-   `gnome-clocks` - Wake up, brokies, watch out for alarms

### Browser

-   `zen-browser` - Because Chrome eats RAM for breakfast

### Code Editor

-   `visual-studio-code` - Editor to build that million-dollar app idea (someday)
-  `zed-preview` - An alternative to VSCode

### Time to Install (The Free Way)

#### Arch Linux (Using paru)

```bash
# One command to rule them all (the broke way)
paru -S hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland waybar kitty dunst tofi nautilus polkit-kde-agent swww brightnessctl grimblast-git hyprlock hypridle wleave-git wlogout playerctl pavucontrol cliphist nwg-look kvantum zen-browser-bin visual-studio-code-bin zed-preview-bin noto-fonts-cjk bluez bluez-utils ghostty jamesdsp bibata-cursor-theme fluent-icon-theme-git gnome-clocks
```

> 💡 Brokie Tip: Hate `paru`? `yay` still works wonders!

## 🚀 Get Started ASAP

For the financially challenged and impatient:

```bash
# Clone the magic
git clone https://github.com/ultimatebrok/brokies_land.git

# Copy-paste like a pro
cp -r brokies_land/.config/* ~/.config/

# Fire it up and bask in the glory
Hyprland
```

## ⌨️ Keyboard Ninja Moves

| Combo               | What it does                                                    |
| :------------------ | :-------------------------------------------------------------- |
| `SUPER + T`         | Opens terminal (to check if you've won the lottery)            |
| `SUPER + E`         | Opens file manager (to admire your collection of free ebooks) |
| `SUPER + B`         | Opens browser (to find more free stuff)                       |
| `SUPER + C`         | Opens code editor (for that side hustle that will make you rich) |
| `SUPER + A`         | App launcher (find even more free apps)                       |
| `SUPER + Q`         | Closes windows (like you close those "urgent" emails)          |
| `SUPER + F`         | Toggle fullscreen (maximize your limited screen space)         |
| `SUPER + Space`     | Toggle floating window (because sometimes you just need to float) |
| `SUPER + Left/Right/Up/Down` | Navigate windows (avoiding real-life expenses)            |
| `SUPER + SHIFT + 1-0` | Move window to workspace (organize your digital empire)        |
| `SUPER + 1-0`       | Switch to workspace (escape reality)                          |
| `SUPER + L`         | Lock screen (hide your shame... or your awesome desktop)      |
| `SUPER + ESCAPE`    | Show logout menu (when you need a break from being awesome)    |
| `SUPER + M`         | Exit Hyprland (when even virtual life gets too real)           |
| `SUPER + N`         | Change wallpaper (new look, same broke you)                   |
| `SUPER + V`         | Show clipboard history (relive your copy-paste victories)      |
| `SUPER + S`         | Toggle scratchpad (hide your secrets... or your grocery list)  |
| `Print`             | Screenshot full screen (proof that you're winning at life)     |
| `SUPER + Print`     | Screenshot active window (show off your best side)             |
| `SUPER + ALT + Print` | Screenshot selected area (crop out the messy parts)            |

## 📸 Proof's in the Pudding

![Screenshot](https://raw.githubusercontent.com/ultimatebrok/brokies_land/main/screenshots/desktop.png)

## 🎬 See It In Action

Why settle for static screenshots when you can see the full broke experience? Check out this video tour of Brokies Land in all its glory:

https://github.com/ultimatebrok/brokies_land/raw/main/demo/showcase.mp4


## 💖 Join the Brokie Revolution

Got a free alternative to share? A config tweak that makes things look extra fancy? Fork it, tweak it, and share it with your fellow brokies!

## 📜 The Fine Print (License)

MIT Licensed. See LICENSE file for details. Free as in beer... or instant noodles.

---

<p align="center"><i>Living the high-resolution life on a low-resolution budget!</i></p>
