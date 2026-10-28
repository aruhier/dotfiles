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

-- Simulate the old dwindle.special_scale_factor.
-- Increase the gap in special workspaces to center the window, sized as a ratio of
-- each monitor (e.g. 0.86 = 86% of its width and height), through gaps_out.
-- Monitor name -> { rule, key }, so a rule is only replaced when its gaps change.
local special_area_rules = {}
local special_area_ratio = nil

local function apply_special_area()
    for _, m in ipairs(hl.get_monitors()) do
        local width, height = m.width / m.scale, m.height / m.scale
        -- Odd transforms rotate the monitor by 90°.
        if m.transform % 2 == 1 then
            width, height = height, width
        end
        local x = math.floor(width * (1 - special_area_ratio) / 2)
        local y = math.floor(height * (1 - special_area_ratio) / 2)
        local key = x .. "x" .. y

        local current = special_area_rules[m.name]
        if not current or current.key ~= key then
            if current then
                current.rule:set_enabled(false)
            end
            special_area_rules[m.name] = {
                key = key,
                rule = hl.workspace_rule({
                    workspace = "s[true] m[" .. m.name .. "]",
                    gaps_out = { top = y, right = x, bottom = y, left = x },
                }),
            }
        end
    end
end

function M.set_special_area_ratio(ratio)
    local first_call = special_area_ratio == nil
    special_area_ratio = ratio
    apply_special_area()
    if first_call then
        hl.on("monitor.added", apply_special_area)
    end
end

return M
