-- Environment variables migrated from configs/ENVariables.conf and UserConfigs/01-UserDefaults.conf.

hl.env("EDITOR", "nvim")
hl.env("DOTS_VERSION", "2.3.22")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("DESKTOP_SESSION", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")
hl.env("GDK_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
-- XCURSOR_* covers XWayland/GTK apps, which ignore hyprcursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto") -- auto selects Wayland if possible, X11 otherwise
hl.env("SSH_AUTH_SOCK", (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") .. "/keyring/ssh")
-- TOUCHPAD_DEVICE is deliberately not set: TouchPad.sh autodetects the
-- touchpad from `hyprctl devices`. Export it here to pin a specific device.
