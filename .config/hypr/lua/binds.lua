-- Key and mouse binds migrated from configs/Keybinds.conf and configs/Laptops.conf.

local home = os.getenv("HOME") or "~"
local mainMod = "ALT" -- main modifier; set to "SUPER" if you prefer, helper binds swap to ALT automatically
local auxMod = (mainMod == "SUPER") and "ALT" or "SUPER" -- secondary mod for helper binds
local scriptsDir = home .. "/.config/hypr/scripts"
local term = "kitty"
local files = "nautilus --new-window" -- file manager for mainMod+E; swap for thunar, dolphin, nemo...

local function bind(combo, dispatcher, description, opts)
  opts = opts or {}
  if description then opts.description = description end
  hl.bind(combo, dispatcher, opts)
end

local function exec(command)
  return hl.dsp.exec_cmd(command)
end

local function dir(d)
  return ({ l = "l", r = "r", u = "u", d = "d", left = "l", right = "r", up = "u", down = "d" })[d] or d
end

-- STANDARD
bind("SUPER + Super_L", exec("swaync-client -t -sw"), "notification panel", { release = true })
bind(mainMod .. " + Q", hl.dsp.window.close(), "close active window")
bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), "Float current window")
bind(mainMod .. " + P", hl.dsp.window.pseudo(), "toggle pseudo (dwindle)")
bind(mainMod .. " + G", hl.dsp.layout("togglesplit"), "toggle split (dwindle)")
bind(mainMod .. " + E", exec(files), "file manager")
bind(mainMod .. " + space", exec("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"), "app launcher")
bind(auxMod .. " + backspace", exec(scriptsDir .. "/LockScreen.sh"), "lock screen")
bind(auxMod .. " + delete", exec(scriptsDir .. "/Logout.sh"), "close all apps, then exit Hyprland")
bind(auxMod .. " + grave", exec(home .. "/.config/waybar/scripts/wifi-settings.sh"), "Wifi settings window")
bind(mainMod .. " + Z", exec(home .. "/.config/waybar/scripts/wifi-settings.sh"), "Wifi settings window")
bind(mainMod .. " + B", exec('xdg-open "https://"'), "open default browser")
bind(auxMod .. " + H", exec(scriptsDir .. "/KeyBinds.sh"), "searchable keybinds list")
bind(auxMod .. " + R", exec(scriptsDir .. "/Refresh.sh"), "refresh bar and menus")
bind(auxMod .. " + E", exec(scriptsDir .. "/RofiEmoji.sh"), "emoji menu")
bind(mainMod .. " + CTRL + S", exec("rofi -show window"), "window switcher")
bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), "fullscreen")
-- ALT+F maximizes the active window over its siblings ("hides" them under it);
-- ALT+Tab (cyclenext) hands the maximize over to the next window on the workspace.
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), "hide other windows (maximize toggle)")
bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), "maximize window")
bind(mainMod .. " + CTRL + B", exec("pkill -SIGUSR1 waybar"), "toggle waybar on/off")
bind(auxMod .. " + SHIFT_L", exec(scriptsDir .. "/ScreenShot.sh --area"), "screenshot (swappy)")
bind(mainMod .. " + " .. auxMod .. " + SHIFT_L", exec(scriptsDir .. "/ScreenRecord.sh"), "record selected area")
bind("CTRL + " .. auxMod .. " + SHIFT_L", exec(scriptsDir .. "/ScreenRecord.sh --full"), "record full screen")

-- SYSTEM
bind(mainMod .. " + SHIFT + Q", exec(scriptsDir .. "/KillActiveProcess.sh"), "Terminate active process")
bind(auxMod .. " + escape", exec(scriptsDir .. "/Wlogout.sh"), "powermenu")
bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"), "remove master")
bind(mainMod .. " + I", hl.dsp.layout("addmaster"), "add master")
bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"), "swap with master")
bind(auxMod .. " + 1", exec(scriptsDir .. "/ChangeLayout.sh dwindle"), "layout dwindle")
bind(auxMod .. " + 2", exec(scriptsDir .. "/ChangeLayout.sh master"), "layout master")
bind(auxMod .. " + 3", exec(scriptsDir .. "/ChangeLayout.sh scrolling"), "layout scrolling")
bind(mainMod .. " + SHIFT + period", hl.dsp.layout("move +col"), "move to right column")
bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("move -col"), "move to left column")
bind(auxMod .. " + comma", hl.dsp.layout("swapcol l"), "swap columns left")
bind(auxMod .. " + period", hl.dsp.layout("swapcol r"), "swap columns right")
-- hyprctl keyword is rejected by the Lua config provider; hl.config via eval works
bind(auxMod .. " + bracketright", exec("hyprctl eval \"hl.config({ scrolling = { direction = 'right' } })\""), "Horizontal scroll")
bind(auxMod .. " + bracketleft", exec("hyprctl eval \"hl.config({ scrolling = { direction = 'down' } })\""), "Vertical scroll")
bind(auxMod .. " + backslash", exec("bash -c '[[ $(hyprctl getoption scrolling:direction -j | jq -r \".str\") == \"right\" ]] && d=down || d=right; hyprctl eval \"hl.config({ scrolling = { direction = [[$d]] } })\"'"), "toggle scrolling V/H")
bind(mainMod .. " + tab", hl.dsp.window.cycle_next({ next = true }), "cycle next window")
bind(mainMod .. " + tab", hl.dsp.window.alter_zorder({ mode = "top" }), "bring active to top")

-- MEDIA / HARDWARE KEYS
bind("XF86AudioRaiseVolume", exec(scriptsDir .. "/Volume.sh --inc"), "volume up", { locked = true, repeating = true })
bind("XF86AudioLowerVolume", exec(scriptsDir .. "/Volume.sh --dec"), "volume down", { locked = true, repeating = true })
bind(mainMod .. " + XF86AudioRaiseVolume", exec(scriptsDir .. "/Volume.sh --inc-precise"), "volume up precise", { locked = true, repeating = true })
bind(mainMod .. " + XF86AudioLowerVolume", exec(scriptsDir .. "/Volume.sh --dec-precise"), "volume down precise", { locked = true, repeating = true })
bind("XF86AudioMicMute", exec(scriptsDir .. "/Volume.sh --toggle-mic"), "toggle mic mute", { locked = true })
bind("XF86AudioMute", exec(scriptsDir .. "/Volume.sh --toggle"), "toggle mute", { locked = true })
bind("XF86Sleep", exec("systemctl suspend"), "sleep", { locked = true })
bind("XF86RFKill", exec(scriptsDir .. "/AirplaneMode.sh"), "airplane mode", { locked = true })
bind("XF86AudioPause", exec(scriptsDir .. "/MediaCtrl.sh --pause"), "pause", { locked = true })
bind("XF86AudioPlay", exec(scriptsDir .. "/MediaCtrl.sh --pause"), "play", { locked = true })
bind("XF86AudioNext", exec(scriptsDir .. "/MediaCtrl.sh --nxt"), "next track", { locked = true })
bind("XF86AudioPrev", exec(scriptsDir .. "/MediaCtrl.sh --prv"), "previous track", { locked = true })
bind("XF86AudioStop", exec(scriptsDir .. "/MediaCtrl.sh --stop"), "stop", { locked = true })
-- Laptop-specific keys
bind("XF86KbdBrightnessDown", exec(scriptsDir .. "/BrightnessKbd.sh --dec"), "decrease keyboard brightness", { repeating = true })
bind("XF86KbdBrightnessUp", exec(scriptsDir .. "/BrightnessKbd.sh --inc"), "increase keyboard brightness", { repeating = true })
bind("XF86MonBrightnessDown", exec(scriptsDir .. "/Brightness.sh --dec"), "decrease monitor brightness", { locked = true, repeating = true })
bind("XF86MonBrightnessUp", exec(scriptsDir .. "/Brightness.sh --inc"), "increase monitor brightness", { locked = true, repeating = true })
bind("XF86TouchpadToggle", exec(scriptsDir .. "/TouchPad.sh"), "disable touchpad")
bind(auxMod .. " + F6", exec(scriptsDir .. "/ScreenShot.sh --now"), "screenshot")
bind(auxMod .. " + SHIFT + F6", exec(scriptsDir .. "/ScreenShot.sh --area"), "screenshot (area)")
bind(auxMod .. " + CTRL + F6", exec(scriptsDir .. "/ScreenShot.sh --in5"), "screenshot (5 secs delay)")
bind("SUPER + ALT + F6", exec(scriptsDir .. "/ScreenShot.sh --in10"), "screenshot (10 secs delay)")
bind("ALT + F6", exec(scriptsDir .. "/ScreenShot.sh --active"), "screenshot (active window only)")

-- FOCUS / WINDOW MANAGEMENT
bind(mainMod .. " + H", hl.dsp.focus({ direction = dir("l") }), "focus left")
bind(mainMod .. " + J", hl.dsp.focus({ direction = dir("d") }), "focus down")
bind(mainMod .. " + K", hl.dsp.focus({ direction = dir("u") }), "focus up")
bind(mainMod .. " + L", hl.dsp.focus({ direction = dir("r") }), "focus right")
bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = dir("l") }), "move window left")
bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = dir("d") }), "move window down")
bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = dir("u") }), "move window up")
bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = dir("r") }), "move window right")
bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), "resize left (-50)", { repeating = true })
bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), "resize right (+50)", { repeating = true })
bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), "resize up (-50)", { repeating = true })
bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), "resize down (+50)", { repeating = true })
bind(auxMod .. " + left", hl.dsp.window.swap({ direction = "l" }), "swap window left")
bind(auxMod .. " + right", hl.dsp.window.swap({ direction = "r" }), "swap window right")
bind(auxMod .. " + up", hl.dsp.window.swap({ direction = "u" }), "swap window up")
bind(auxMod .. " + down", hl.dsp.window.swap({ direction = "d" }), "swap window down")
-- Static replacements for the per-layout binds ChangeLayout.sh used to set at
-- runtime; those fought the Lua binds and flipped behavior on every reload.
bind(auxMod .. " + J", hl.dsp.window.cycle_next({ next = true }), "cycle next window")
bind(auxMod .. " + K", hl.dsp.window.cycle_next({ prev = true }), "cycle previous window")
bind(auxMod .. " + O", hl.dsp.layout("togglesplit"), "toggle split (dwindle)")
bind(auxMod .. " + G", hl.dsp.group.toggle({}), "toggle group")
bind(mainMod .. " + CTRL + tab", hl.dsp.group.next({}), "change active in group")
bind(auxMod .. " + tab", hl.dsp.group.next({}), "Change Group Forward")
bind(auxMod .. " + SHIFT + tab", hl.dsp.group.prev({}), "Change Group Back")
bind(auxMod .. " + CTRL + K", hl.dsp.window.move({ into_group = "l" }), "Move left into group")
bind(auxMod .. " + CTRL + L", hl.dsp.window.move({ into_group = "r" }), "Move right into group")
bind(auxMod .. " + CTRL + H", hl.dsp.window.move({ out_of_group = true }), "Move active out of group")

-- WORKSPACES
for i = 1, 10 do
  local key = i == 10 and 0 or i
  bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), "workspace " .. i)
  bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "move to workspace " .. i)
  bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), "move silently to workspace " .. i)
end
bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }), "move to previous workspace")
bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), "move to next workspace")
bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }), "move silently to previous workspace")
bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }), "move silently to next workspace")
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "next workspace")
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "previous workspace")
bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }), "next workspace")
bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }), "previous workspace")
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special(""), "toggle special workspace")
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }), "move to special workspace")
-- Mouse move/resize
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), "move window", { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), "resize window", { mouse = true })

-- WIFI SETTINGS WINDOW: Escape closes it (the app itself binds Escape to
-- "navigate back", which just reopens the sidebar). The bind only exists
-- while the window is focused, so Escape behaves normally everywhere else.
local wifi_esc_bound = false

local function wifi_esc_unbind()
  if wifi_esc_bound then
    hl.unbind("escape")
    wifi_esc_bound = false
  end
end

hl.on("window.active", function(w)
  local ok, class = pcall(function() return w and w.class end)
  if ok and class == "org.gnome.Settings" then
    if not wifi_esc_bound then
      hl.bind("escape", hl.dsp.window.close({ window = "address:" .. w.address }),
        { description = "close wifi settings" })
      wifi_esc_bound = true
    end
  else
    wifi_esc_unbind()
  end
end)

-- The window dying emits window.close but neither window.destroy nor a
-- window.active for the refocus on this build, so unbind on close.
hl.on("window.close", function(w)
  local ok, class = pcall(function() return w and w.class end)
  if ok and class == "org.gnome.Settings" then wifi_esc_unbind() end
end)
