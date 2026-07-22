-- Appearance migrated from UserConfigs/UserDecorations.conf (originally wallust-generated,
-- wallust removed 2026-07). Static Monokai colors are inlined so Hyprland Lua does not need
-- hyprlang variables.

local color0 = "rgb(272822)"
local color10 = "rgb(383830)"
local color12 = "rgb(F92672)"
local color15 = "rgb(F92672)"

hl.config({
  general = {
    border_size = 2,
    gaps_in = 7,
    gaps_out = 14,
    col = {
      active_border = "rgb(F92672)",
      inactive_border = "rgb(454545)",
    },
  },
  decoration = {
    rounding = 10,
    active_opacity = 0.9,
    inactive_opacity = 0.9,
    fullscreen_opacity = 1.0,
    dim_inactive = false,
    dim_strength = 0.1,
    dim_special = 0.8,
    shadow = {
      enabled = false,
      range = 3,
      render_power = 1,
      color = color12,
      color_inactive = color10,
    },
    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      xray = true,
      ignore_opacity = true,
      special = true,
      popups = true,
    },
  },
  group = {
    col = {
      border_active = color15,
    },
    groupbar = {
      col = {
        active = color0,
      },
    },
  },
})
