local M = {}
local C = require("conf.constants")

-- Copy an object.
function M.copy(o)
    local c = {}
    for key, value in pairs(o) do
        c[key] = value
    end
    return c
end

-- Allow to selectively have debounce animations when moving windows.
-- It allows to not have these when swapping workspaces between 2 monitors, or when navigating through scrolling
-- columns.
local restore_anim_timer = nil
function M.wrap_slide_bounce_anim(dsp)
    return function()
        -- Do a local copy to avoid nil access, as the function is not atomic.
        local cpy_restore_anim_timer = restore_anim_timer
        -- Cancel any pending restore.
        if cpy_restore_anim_timer then
            cpy_restore_anim_timer:set_enabled(false)
            restore_anim_timer = nil
        end

        hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, spring = "springSnappyBouncy", style = "slide" })

        local a = M.copy(C.animations.windows_move)
        a["enabled"]  = true
        a["leaf"] = "windowsMove"
        restore_anim_timer = hl.timer(function()
            hl.animation(a)
            restore_anim_timer = nil
        end, { timeout = 200, type = "oneshot" })

        hl.dispatch(dsp)
    end
end

return M
