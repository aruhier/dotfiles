local M = {}

M.main_mod = "SUPER"
M.scripts = os.getenv("HOME") .. "/.config/hypr/scripts"
M.monitors = {
    msi_32 = "desc:Microstep MPG321UX OLED 0x01010101",
    lg_27 = "desc:LG Electronics 27GL850 912NTWG0N049",
    dell_27 = "desc:Dell Inc. DELL U2715H GH85D83V2Q6S"
}
M.main_monitor = M.monitors.msi_32
-- Animations list, used by functions that override contextual animations.
M.animations = {
    windows_move = { speed = 1, spring = "springSnappy", style = "slide" },
}

return M
