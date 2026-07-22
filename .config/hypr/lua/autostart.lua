-- Autostart migrated from hyprland.conf, configs/Startup_Apps.conf, and configs/Keybinds.conf.

local home = os.getenv("HOME") or "~"
local scriptsDir = home .. "/.config/hypr/scripts"

local exec_once = {
  scriptsDir .. "/WallpaperDaemon.sh",
  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP DESKTOP_SESSION XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE DISPLAY SSH_AUTH_SOCK",
  "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP DESKTOP_SESSION XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE DISPLAY SSH_AUTH_SOCK",
  "systemctl --user start hyprland-session.target",
  "gnome-keyring-daemon --start --components=secrets,ssh,pkcs11",
  -- Polkit agent is managed by hyprpolkitagent.service (systemd user unit,
  -- tied to graphical-session.target); starting a second agent here caused
  -- xfce-polkit and hyprpolkitagent to run simultaneously.
  -- scriptsDir .. "/Polkit.sh",
  -- waybar, swaync, and hypridle are owned by their systemd user units
  -- (WantedBy=graphical-session.target, Restart=on-failure); exec-once'ing
  -- them here too double-starts them — swaync used to latch failed that way.
  home .. "/.config/swaync/sync-bluetooth-on-login.sh",
  home .. "/.config/hypr/scripts/PowerProfileWriteCSS.sh",
  home .. "/.config/hypr/scripts/AirplaneWriteCSS.sh",
}

hl.on("hyprland.start", function()
  for _, command in ipairs(exec_once) do
    hl.exec_cmd(command)
  end
end)
