
-- ─── Config ───────────────────────────────────────────────────────────────────

local C = require("conf.constants")

require("conf.env")
require("conf.permissions")
require("conf.global")
require("conf.monitors")

require("conf.animations")
require("conf.bind")
require("conf.rules")
require("conf.scratchpad")
require("conf.workspaces")

-- Autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("pgrep kanshi && pkill -HUP kanshi || kanshi")
    hl.exec_cmd("swaybg -o \\* -m fill -i ~/.config/hypr/wallpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd(C.scripts .. "/start")
    hl.exec_cmd(C.scripts .. "/start_app")
end)
