-- #############################
-- Keyboard Shortcuts
-- #############################

-- General
hl.unbind("SUPER + P")
hl.unbind("SUPER + L")
hl.unbind("SUPER + h")
hl.unbind("SUPER + l")
hl.unbind("SUPER + K")
hl.unbind("SUPER + j")
hl.unbind("SUPER + SHIFT + h")
hl.unbind("SUPER + SHIFT + l")
hl.unbind("SUPER + SHIFT + k")
hl.unbind("SUPER + SHIFT + j")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + SHIFT + ALT + S")

-- App Launcher
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("caelestia shell drawers toggle launcher"))

-- Window Navigation
hl.bind("SUPER + h", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshot"))

-- IDE
hl.unbind("SUPER + C")

-- Browser
hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.exec_cmd("brave"))

-- Terminal
hl.unbind("SUPER + T")
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))


-- #############################
-- Special Workspaces
-- #############################

-- Terminal 
hl.bind("SUPER + minus", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace "))

-- Gemini
hl.bind("SUPER + equal", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace G"))

-- System Monitor
hl.bind("SUPER + P", hl.dsp.exec_cmd("caelestia toggle sysmon"))


-- #############################
-- Hardware
-- #############################

-- Monitors
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@75",
    position = "-1920x0",
    scale    = 1
})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@165",
    position = "0x0",
    scale    = 1
})

-- ~/.config/caelestia/hypr-user.lua
local hs = require("hyprsplit")

hs.config({
    num_workspaces = 10,
})

for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = false }))
end   
