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
M.persistent_workspaces_range = {1, 8}

return M
