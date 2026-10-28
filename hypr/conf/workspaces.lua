local C = require("conf.constants")
local U = require("conf.utils")

local home_monitor = {
    [1] = C.main_monitor,
    [2] = C.monitors.dell_27,
    [3] = C.monitors.lg_27,
}
for ws, monitor in ipairs(home_monitor) do
    hl.workspace_rule({ workspace = tostring(ws), monitor = monitor, default = true })
end

-- Firefox main.
hl.workspace_rule({ workspace = "1", layout = "scrolling" })
-- Firefox secondary.
hl.workspace_rule({ workspace = "10", layout = "scrolling" })
hl.workspace_rule({ workspace = "12", layout = "scrolling" })

-- Special workspace windows use 86% of the monitor (was dwindle.special_scale_factor).
U.set_special_area_ratio(0.86)

local workspace_keys = {
    [1]  = "a",
    [2]  = "s",
    [3]  = "d",
    [4]  = "f",
    [5]  = "u",
    [6]  = "i",
    [7]  = "o",
    [8]  = "p",
    [9]  = "7",
    [10] = "8",
    [11] = "9",
    [12] = "0",
}

for i = C.persistent_workspaces_range[1], C.persistent_workspaces_range[2] do
    hl.workspace_rule({ workspace = i, default_name = workspace_keys[i], persistent = true })
end
for i = C.persistent_workspaces_range[2] + 1, #workspace_keys do
    hl.workspace_rule({ workspace = i, default_name = workspace_keys[i], persistent = false })
end

for ws, key in pairs(workspace_keys) do
    hl.bind(C.main_mod .. " + " .. key,         hl.dsp.focus({ workspace = ws, on_current_monitor = true }))
    hl.bind(C.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws, follow = false }))
end

-- Touchpad 3 finger swipe.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
