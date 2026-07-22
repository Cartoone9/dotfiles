-- Monitor rules migrated from monitors.conf.
-- NOTE: NWG-Displays may still overwrite monitors.conf; mirror future changes here.

-- Laptop panel
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = 1,
})

-- Lenovo P27h-30 external monitor, placed above the laptop.
-- X = -320 centers 2560px external over 1920px laptop: -(2560 - 1920) / 2
-- Y = -1440 puts it directly above the laptop.
hl.monitor({
	output = "DP-2",
	mode = "2560x1440@74.78",
	position = "-320x-1440",
	scale = 1,
})

-- Laptop workspaces
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })

-- External monitor workspaces
hl.workspace_rule({ workspace = "5", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-2" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })

-- Optional fallback for unknown extra displays.
-- Keep only one generic fallback, and keep it after explicit monitor rules.
hl.monitor({
	output = "",
	mode = "highres",
	position = "auto",
	scale = 1,
})

hl.monitor({
	output = "Virtual-1",
	mode = "1920x1080@60",
	position = "auto",
	scale = 1,
})
