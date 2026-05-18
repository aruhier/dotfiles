local C = require("conf.constants")

-- Firefox main.
hl.workspace_rule({ workspace = "1", monitor = C.main_monitor, default = true })
-- Firefox secondary.
hl.workspace_rule({ workspace = "10", layout = "scrolling" })
hl.workspace_rule({ workspace = "12", layout = "scrolling" })

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

for ws, key in pairs(workspace_keys) do
    hl.bind(C.main_mod .. " + " .. key,         hl.dsp.focus({ workspace = ws, on_current_monitor = true }))
    hl.bind(C.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws, follow = false }))
end

-- Touchpad 3 finger swipe.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
