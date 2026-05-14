local M = {}

M.main_mod = "SUPER"
M.scripts = os.getenv("HOME") .. "/.config/hypr/scripts"
M.monitors = {
    internal = "eDP-1",
}
M.main_monitor = M.monitors.internal
-- Animations list, used by functions that override contextual animations.
M.animations = {
    windows_move = { speed = 1, spring = "springSnappy", style = "slide" },
}

return M
