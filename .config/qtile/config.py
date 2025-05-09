import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Define modifiers
mod = "mod4"  # SUPER key
alt = "mod1"  # ALT key

# Define applications (from generals.conf)
terminal = "ghostty"
file_manager = "nautilus"
menu = "wofi --show drun"
browser = os.path.expanduser("~/Downloads/zen-x86_64.AppImage")
editor = "zeditor"
trading = 'sh -c \'XAPP_FORCE_GTKWINDOW_ICON="/$HOME/.local/share/ice/icons/TradingView.png" firefox --class WebApp-TradingView1562 --name WebApp-TradingView1562 --profile /$HOME/.local/share/ice/firefox/TradingView1562 --no-remote "https://www.tradingview.com/chart"\''
home_dir = os.path.expanduser("~")

# Key bindings (from bindings.conf)
keys = [
    # Application launchers
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "c", lazy.spawn(editor), desc="Launch editor"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod], "e", lazy.spawn(file_manager), desc="Launch file manager"),
    Key([mod], "a", lazy.spawn(menu), desc="Launch menu"),
    Key([mod], "t", lazy.spawn(trading), desc="Launch trading app"),
    Key([alt], "w", lazy.spawn(f"{home_dir}/.config/hypr/scripts/wallpaper.sh"), desc="Change wallpaper"),
    Key([alt], "g", lazy.spawn(f"{home_dir}/.config/wofi/wofi-emoji.sh"), desc="Emoji picker"),
    
    # System actions
    Key(["control"], "Escape", lazy.spawn(f"{home_dir}/.config/waybar/scripts/launch.sh"), desc="Launch waybar script"),
    Key([mod], "l", lazy.spawn("hyprlock"), desc="Lock screen"),
    Key([mod], "Escape", lazy.spawn("wlogout"), desc="Logout menu"),
    Key([mod], "m", lazy.shutdown(), desc="Exit Qtile"),
    
    # Performance modes (from enhanced_performance_mode.sh)
    Key([mod, alt], "p", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh' >/dev/null 2>&1 &"), desc="Performance mode menu"),
    Key([mod, alt], "1", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh normal' >/dev/null 2>&1 &"), desc="Normal mode"),
    Key([mod, alt], "2", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh balanced' >/dev/null 2>&1 &"), desc="Balanced mode"),
    Key([mod, alt], "3", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh performance' >/dev/null 2>&1 &"), desc="Performance mode"),
    Key([mod, alt], "4", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh gaming' >/dev/null 2>&1 &"), desc="Gaming mode"),
    Key([mod, alt], "5", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh battery' >/dev/null 2>&1 &"), desc="Battery mode"),
    Key([mod, alt], "6", lazy.spawn(f"nohup bash -c '{home_dir}/.config/hypr/scripts/enhanced_performance_mode.sh presentation' >/dev/null 2>&1 &"), desc="Presentation mode"),
    
    # Utilities
    Key([mod], "v", lazy.spawn(f"cliphist list | tofi -c {home_dir}/.config/tofi/configV | cliphist decode | wl-copy"), desc="Clipboard history"),
    Key([mod], "n", lazy.spawn(f"swww img {home_dir}/Pictures/Another_Wallpaper/renato-ramos-puma-37WxvlfW3to-unsplash.jpg --transition-fps 255 --transition-type grow --transition-duration 0.8"), desc="Set wallpaper"),
    
    # Screenshots
    Key([], "Print", lazy.spawn(f"{home_dir}/.config/hypr/scripts/grimblast_save_notify.sh screen"), desc="Screenshot screen"),
    Key([mod], "Print", lazy.spawn(f"{home_dir}/.config/hypr/scripts/grimblast_save_notify.sh output"), desc="Screenshot output"),
    Key([mod, "shift"], "Print", lazy.spawn(f"{home_dir}/.config/hypr/scripts/grimblast_save_notify.sh active"), desc="Screenshot active window"),
    Key([mod, alt], "Print", lazy.spawn(f"{home_dir}/.config/hypr/scripts/grimblast_save_notify.sh area"), desc="Screenshot area"),
    
    # Window management
    Key([mod], "q", lazy.window.kill(), desc="Kill active window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "space", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "p", lazy.layout.toggle_split(), desc="Toggle split (pseudo)"),
    Key([mod], "j", lazy.layout.shuffle_down(), desc="Toggle split direction"),
    
    # Focus movement
    Key([mod], "left", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    
    # Move windows
    Key([mod, "shift"], "left", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    
    # Workspace (group) navigation
    Key([mod], "1", lazy.group["1"].toscreen(), desc="Switch to group 1"),
    Key([mod], "2", lazy.group["2"].toscreen(), desc="Switch to group 2"),
    Key([mod], "3", lazy.group["3"].toscreen(), desc="Switch to group 3"),
    Key([mod], "4", lazy.group["4"].toscreen(), desc="Switch to group 4"),
    Key([mod], "5", lazy.group["5"].toscreen(), desc="Switch to group 5"),
    Key([mod], "6", lazy.group["6"].toscreen(), desc="Switch to group 6"),
    Key([mod], "7", lazy.group["7"].toscreen(), desc="Switch to group 7"),
    Key([mod], "8", lazy.group["8"].toscreen(), desc="Switch to group 8"),
    Key([mod], "9", lazy.group["9"].toscreen(), desc="Switch to group 9"),
    Key([mod], "0", lazy.group["10"].toscreen(), desc="Switch to group 10"),
    
    # Move window to workspace (group)
    Key([mod, "shift"], "1", lazy.window.togroup("1"), desc="Move window to group 1"),
    Key([mod, "shift"], "2", lazy.window.togroup("2"), desc="Move window to group 2"),
    Key([mod, "shift"], "3", lazy.window.togroup("3"), desc="Move window to group 3"),
    Key([mod, "shift"], "4", lazy.window.togroup("4"), desc="Move window to group 4"),
    Key([mod, "shift"], "5", lazy.window.togroup("5"), desc="Move window to group 5"),
    Key([mod, "shift"], "6", lazy.window.togroup("6"), desc="Move window to group 6"),
    Key([mod, "shift"], "7", lazy.window.togroup("7"), desc="Move window to group 7"),
    Key([mod, "shift"], "8", lazy.window.togroup("8"), desc="Move window to group 8"),
    Key([mod, "shift"], "9", lazy.window.togroup("9"), desc="Move window to group 9"),
    Key([mod, "shift"], "0", lazy.window.togroup("10"), desc="Move window to group 10"),
    
    # Special workspace
    Key([mod], "s", lazy.group["magic"].toscreen(), desc="Toggle special workspace"),
    Key([mod, "shift"], "s", lazy.window.togroup("magic"), desc="Move window to special workspace"),
    
    # Workspace navigation with Page Up/Down
    Key([mod], "Page_Up", lazy.group.next_group(), desc="Next group"),
    Key([mod], "Page_Down", lazy.group.prev_group(), desc="Previous group"),
    
    # Mouse bindings
    Key([mod], "XF86ScrollUp", lazy.group.next_group(), desc="Next group"),
    Key([mod], "XF86ScrollDown", lazy.group.prev_group(), desc="Previous group"),
    
    # Media controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh volume_up"), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh volume_down"), desc="Volume down"),
    Key([], "XF86AudioMicMute", lazy.spawn("pamixer --default-source -m"), desc="Mute microphone"),
    Key([], "XF86AudioMute", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh volume_mute"), desc="Mute volume"),
    Key([], "XF86AudioPlay", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh play_pause"), desc="Play/Pause"),
    Key([], "XF86AudioPause", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh play_pause"), desc="Play/Pause"),
    Key([mod], "XF86AudioNext", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh next_track"), desc="Next track"),
    Key([mod], "XF86AudioPrev", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh prev_track"), desc="Previous track"),
    Key([], "XF86MonBrightnessUp", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh brightness_up"), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn(f"{home_dir}/.config/dunst/scripts/volume_brightness.sh brightness_down"), desc="Brightness down"),
]

# Mouse bindings (from bindings.conf)
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

# Groups (from workspaces.conf)
groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    Group("10"),
    Group("magic"),
]

# Layouts (from layout.conf)
layouts = [
    layout.Bsp(
        border_width=3,
        border_focus="#00ffbb",  # Cyber Teal Pulse (from decorantions.conf)
        border_normal="#0a0f12",
        margin=5,
        fair=True,
        border_on_single=True,
    ),
    layout.MonadTall(
        border_width=3,
        border_focus="#00ffbb",
        border_normal="#0a0f12",
        margin=5,
        single_border_width=3,
        single_margin=5,
    ),
]

# Floating layout
floating_layout = layout.Floating(
    border_width=3,
    border_focus="#00ffbb",
    border_normal="#0a0f12",
    float_rules=[
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(title="Picture-in-Picture"),
    ]
)

# Screens and bar (from monitors.conf)
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            ],
            24,
            background="#0a0f12",
            border_color="#00ffbb",
        ),
    ),
]

# Autostart applications (from autostarts.conf)
@hook.subscribe.startup_once
def autostart():
    processes = [
        "/usr/bin/lxqt-policykit-agent",
        "/usr/bin/dunst",
        "waybar",
        "hypridle",
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
        f'dunstify -u critical "Hello, brokie" "Enjoy your life recently? <b>Hell fucking nah</b>, get yo ass up and find the way to <u>ESCAPE THE MATRIX</u>"',
        "swww-daemon",
        f"wl-paste --type text --watch cliphist store",
        f"wl-paste --type image --watch cliphist store",
        "fcitx5 -d",
        "input-remapper-control --command autoload",
        'gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Teal-Dark"',
        'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"',
    ]
    for p in processes:
        subprocess.Popen(p, shell=True)

# Window rules (from rules.conf)
@hook.subscribe.client_new
def window_rules(window):
    if window.match(Match(wm_class="pavucontrol")) or window.match(Match(wm_class="blueman-manager")) or window.match(Match(title="Picture-in-Picture")):
        window.floating = True
        window.center()

# Environment variables (from environments.conf)
os.environ["XDG_CURRENT_DESKTOP"] = "qtile"
os.environ["XDG_SESSION_TYPE"] = "wayland"
os.environ["XDG_SESSION_DESKTOP"] = "qtile"
os.environ["QT_QPA_PLATFORM"] = "wayland;xcb"
os.environ["QT_QPA_PLATFORMTHEME"] = "qt6ct"
os.environ["QT_WAYLAND_DISABLE_WINDOWDECORATION"] = "1"
os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
os.environ["QT_STYLE_OVERRIDE"] = "kvantum"
os.environ["GDK_BACKEND"] = "wayland,x11,*"
os.environ["SDL_VIDEODRIVER"] = "wayland"
os.environ["CLUTTER_BACKEND"] = "wayland"
os.environ["WLR_DRM_NO_ATOMIC"] = "1"
os.environ["__GL_GSYNC_ALLOWED"] = "0"
os.environ["__GL_VRR_ALLOWED"] = "0"
os.environ["WLR_USE_LIBINPUT"] = "1"
os.environ["XCURSOR_SIZE"] = "24"
os.environ["XCURSOR_THEME"] = "Bibata-Modern-Ice"
os.environ["MOZ_ENABLE_WAYLAND"] = "1"
os.environ["ELECTRON_OZONE_PLATFORM_HINT"] = "auto"

# Input configuration (from generals.conf)
dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = {
    "type:touchpad": {
        "natural_scroll": True,
        "tap": True,
    },
    "type:pointer": {
        "accel_profile": "adaptive",
    },
}
