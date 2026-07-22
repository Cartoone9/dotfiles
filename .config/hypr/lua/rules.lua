-- Window and layer rules migrated from configs/WindowRules.conf and UserConfigs/WindowRules.conf.

-- Rules are kept in legacy order because Hyprland evaluates anonymous rules top-to-bottom.



hl.window_rule({
  match = {
    class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^(chrome-.+-Default)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^([Cc]hromium)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^([Bb]rave-browser(-beta|-dev|-unstable)?)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^([Tt]horium-browser|[Cc]achy-browser)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^(zen-alpha|zen)$",
  },
  tag = "+browser",
})

hl.window_rule({
  match = {
    class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$",
  },
  tag = "+notif",
})

hl.window_rule({
  match = {
    class = "^(nwg-displays|nwg-look)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(Alacritty|kitty)$",
  },
  tag = "+terminal",
})

hl.window_rule({
  match = {
    class = "^([Tt]hunderbird|org.mozilla.Thunderbird)$",
  },
  tag = "+email",
})

hl.window_rule({
  match = {
    class = "^(eu.betterbird.Betterbird)$",
  },
  tag = "+email",
})

hl.window_rule({
  match = {
    class = "^(org.gnome.Evolution)$",
  },
  tag = "+email",
})

hl.window_rule({
  match = {
    class = "^(codium|codium-url-handler|VSCodium)$",
  },
  tag = "+projects",
})

hl.window_rule({
  match = {
    class = "^(VSCode|code|code-url-handler)$",
  },
  tag = "+projects",
})

hl.window_rule({
  match = {
    class = "^(jetbrains-.+)$",
  },
  tag = "+projects",
})

hl.window_rule({
  match = {
    class = "^(dev.zed.Zed|antigravity)$",
  },
  tag = "+projects",
})

hl.window_rule({
  match = {
    class = "^(com.obsproject.Studio)$",
  },
  tag = "+screenshare",
})

hl.window_rule({
  match = {
    class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^([Ff]erdium)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^(teams-for-linux)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^(im.riot.Riot|Element)$",
  },
  tag = "+im",
})

hl.window_rule({
  match = {
    class = "^(gamescope)$",
  },
  tag = "+games",
})

hl.window_rule({
  match = {
    class = "^(steam_app_\\d+)$",
  },
  tag = "+games",
})

hl.window_rule({
  match = {
    xdg_tag = "^(proton-game)$",
  },
  tag = "+games",
})

hl.window_rule({
  match = {
    class = "^([Ss]team)$",
  },
  tag = "+gamestore",
})

hl.window_rule({
  match = {
    title = "^([Ll]utris)$",
  },
  tag = "+gamestore",
})

hl.window_rule({
  match = {
    class = "^(com.heroicgameslauncher.hgl)$",
  },
  tag = "+gamestore",
})

hl.window_rule({
  match = {
    class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
  },
  tag = "+file-manager",
})

hl.window_rule({
  match = {
    class = "^(app.drey.Warp)$",
  },
  tag = "+file-manager",
})

hl.window_rule({
  match = {
    class = "^([Ww]aytrogen)$",
  },
  tag = "+wallpaper",
})

hl.window_rule({
  match = {
    class = "^([Aa]udacious)$",
  },
  tag = "+multimedia",
})

hl.window_rule({
  match = {
    class = "^([Mm]pv|vlc)$",
  },
  tag = "+multimedia_video",
})

hl.window_rule({
  match = {
    title = "^(ROG Control)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(wihotspot(-gui)?)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^([Bb]aobab|org.gnome.[Bb]aobab)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(gnome-disks|wihotspot(-gui)?)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    title = "(Kvantum Manager)",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(file-roller|org.gnome.FileRoller)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(nm-applet|nm-connection-editor|blueman-manager)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(qt5ct|qt6ct)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "(xdg-desktop-portal-gtk)",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(org.kde.polkit-kde-authentication-agent-1)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^([Rr]ofi)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(btrfs-assistant)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(timeshift-gtk)$",
  },
  tag = "+settings",
})

hl.window_rule({
  match = {
    class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
  },
  tag = "+viewer",
})

hl.window_rule({
  match = {
    class = "^(evince)$",
  },
  tag = "+viewer",
})

hl.window_rule({
  match = {
    class = "^(eog|org.gnome.Loupe)$",
  },
  tag = "+viewer",
})

hl.window_rule({
  match = {
    tag = "multimedia",
  },
  no_blur = true,
})

hl.window_rule({
  match = {
    tag = "multimedia",
  },
  opacity = "1.0",
})

hl.window_rule({
  match = {
    class = "([Zz]oom|onedriver|onedriver-launcher)",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^(mpv|com.github.rafostar.Clapper)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^([Qq]alculate-gtk)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Authentication Required)$",
  },
  float = true,
  center = true,
})

hl.window_rule({
  match = {
    class = "^(xfce-polkit|mate-polkit|polkit-mate-authentication-agent-1)$",
    title = "^(Authentication required|Authentication Required)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.35) (monitor_h*0.35)",
})

hl.window_rule({
  match = {
    class = "(codium|codium-url-handler|VSCodium)",
    title = "negative:(.*codium.*|.*VSCodium.*)",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^(com.heroicgameslauncher.hgl)$",
    title = "negative:(Heroic Games Launcher)",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^([Ss]team)$",
    title = "negative:^([Ss]team)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Add Folder to Workspace)$",
  },
  float = true,
  size = "(monitor_w*0.7) (monitor_h*0.6)",
  center = true,
})

hl.window_rule({
  match = {
    title = "^(Save As)$",
  },
  float = true,
  size = "(monitor_w*0.7) (monitor_h*0.6)",
  center = true,
})

hl.window_rule({
  match = {
    initial_title = "(Open Files)",
  },
  float = true,
  size = "(monitor_w*0.7) (monitor_h*0.6)",
})

hl.window_rule({
  match = {
    title = "^(SDDM Background)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.16) (monitor_h*0.12)",
})

hl.window_rule({
  match = {
    class = "^(hyprland-donate-screen)$",
  },
  float = true,
  center = true,
})

hl.window_rule({
  match = {
    title = "^(ROG Control)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    title = "^(Keybindings)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    class = "^(nm-connection-editor)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    class = "^(nm-applet)$",
    title = "^(Wi-Fi Network Authentication Required)$",
  },
  center = true,
})

hl.window_rule({
  match = {
    class = ".*",
  },
  idle_inhibit = "fullscreen",
})

hl.window_rule({
  match = {
    class = "^(jetbrains-.*)$",
  },
  no_initial_focus = true,
})

hl.window_rule({
  match = {
    title = "^(wind.*)$",
  },
  no_initial_focus = true,
})

hl.window_rule({
  name = "Picture-in-Picture",
  match = {
    title = "^[Pp]icture-in-[Pp]icture$",
  },
  float = true,
  move = "72% 7%",
  opacity = "0.95 0.75",
  pin = true,
  keep_aspect_ratio = true,
  size = "(monitor_w*0.3) (monitor_h*0.3)",
})

hl.window_rule({
  name = "Kwallet",
  match = {
    class = "^(org.kde.kwalletmanager)$",
    title = "^(Wallet Manager)$",
    initial_class = "^(org.kde.kwalletmanager)$",
    initial_title = "^(Wallet Manager)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.6) (monitor_h*0.6)",
})

hl.window_rule({
  name = "NVIDIA Settings",
  match = {
    class = "^(nvidia-settings)$",
    title = "^(NVIDIA Settings)$",
    initial_class = "^(nvidia-settings)$",
    initial_title = "^(NVIDIA Settings)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.6) (monitor_h*0.6)",
})

hl.window_rule({
  name = "Wallpaper (tag)",
  match = {
    tag = "wallpaper",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.7) (monitor_h*0.7)",
  opacity = "0.9 0.7",
})

hl.window_rule({
  name = "Settings (tag)",
  match = {
    tag = "settings",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.7) (monitor_h*0.7)",
  opacity = "0.8 0.7",
})

hl.window_rule({
  name = "Viewer (tag)",
  match = {
    tag = "viewer",
  },
  float = true,
  center = true,
  opacity = "0.82 0.75",
})

hl.window_rule({
  name = "Multimedia Video (tag)",
  match = {
    tag = "multimedia_video",
  },
  no_blur = true,
  opacity = "1.0",
})

hl.window_rule({
  name = "Games (tag)",
  match = {
    tag = "games",
  },
  no_blur = true,
  fullscreen = false,
})

hl.window_rule({
  name = "Ferdium",
  match = {
    class = "^([Ff]erdium)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.6) (monitor_h*0.7)",
})

hl.window_rule({
  name = "Calculators",
  match = {
    class = "(org.gnome.Calculator|qalculate-gtk)",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.55) (monitor_h*0.45)",
})

hl.window_rule({
  name = "Thunar Dialogs",
  match = {
    class = "([Tt]hunar)",
    title = "negative:(.*[Tt]hunar.*)",
  },
  float = true,
  center = true,
})

hl.window_rule({
  name = "GNOME Settings (wifi window)",
  match = {
    class = "^(org.gnome.Settings)$",
  },
  -- width <= 600px collapses the libadwaita sidebar: wifi panel only
  float = true,
  center = true,
  size = "600 880",
  opacity = "0.8 0.7",
})

hl.window_rule({
  name = "Bitwarden",
  match = {
    class = "^(Bitwarden)$",
    title = "^(Bitwarden)$",
    initial_class = "^(Bitwarden)$",
    initial_title = "^(Bitwarden)$",
  },
  float = true,
  center = true,
  size = "(monitor_w*0.6) (monitor_h*0.6)",
})



hl.layer_rule({
  match = {
    namespace = "rofi",
  },
  blur = true,
  ignore_alpha = 0,
  dim_around = true,
  animation = "fade",
})

hl.layer_rule({
  match = {
    namespace = "notifications",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "quickshell:overview",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "quickshell:overview",
  },
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "wallpaper",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "notifications",
  },
  animation = "slide",
})

hl.layer_rule({
  match = {
    namespace = "swaync-notification-window",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "swaync-notification-window",
  },
  ignore_alpha = 0,
})

hl.layer_rule({
  match = {
    namespace = "swaync-control-center",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "swaync-control-center",
  },
  ignore_alpha = 0,
})

hl.layer_rule({
  match = {
    namespace = "swaync-control-center",
  },
  dim_around = true,
})

hl.layer_rule({
  match = {
    namespace = "logout_dialog",
  },
  blur = true,
})

hl.layer_rule({
  match = {
    namespace = "logout_dialog",
  },
  ignore_alpha = 0,
})
