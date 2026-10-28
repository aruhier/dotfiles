local C = require("conf.constants")

local default_rule = { mode = "preferred", position = "auto", scale = "auto" }

-- Known monitors, matched by output name or by a substring of their description.
-- `rule` is the monitor's default rule, used when a profile doesn't override it.
local known = {
    internal = {
        output = C.monitors.internal,
        rule = { mode = "2944x1840@90.00", scale = 1.6, bitdepth = 10, cm = "dp3", disabled = false },
    },
    home_oled_32 = {
        descr = "MPG321UX OLED",
        rule = { mode = "3840x2160@120.00", position = "auto", scale = 1.25 },
    },
    xr_glasses = {
        descr = "VITURE Beast",
        rule = { mode = "1920x1080@60.00", position = "auto", scale = 1.25 },
    },
}

-- Ordered by priority: the first profile whose enabled monitors are all
-- connected wins, put profiles with more monitors first. The last profile
-- is the fallback, applied when nothing else matches.
-- Each entry overrides the monitor's default rule; use {} to keep it as is.
local profiles = {
    {
        name = "home",
        monitors = {
            home_oled_32 = {},
            internal = { disabled = true },
        },
    },
    {
        name = "xr",
        monitors = {
            xr_glasses = {},
            internal = { disabled = true },
        },
    },
    {
        name = "laptop",
        monitors = {
            internal = {},
        },
    },
}

local function set_monitor(output, rule, override)
    local r = { output = output }
    for k, v in pairs(rule) do
        r[k] = v
    end
    for k, v in pairs(override or {}) do
        r[k] = v
    end
    hl.monitor(r)
end

-- Maps each connected known monitor to its output name.
local function find_connected(current)
    local connected = {}
    for _, m in ipairs(current) do
        for key, spec in pairs(known) do
            if m.name == spec.output
                or (spec.descr and string.find(m.description, spec.descr, 1, true)) then
                connected[key] = m.name
            end
        end
    end
    return connected
end

local function pick_profile(connected)
    for _, profile in ipairs(profiles) do
        local complete = true
        for key, rule in pairs(profile.monitors) do
            if not rule.disabled and not connected[key] then
                complete = false
                break
            end
        end
        if complete then
            return profile
        end
    end
    return profiles[#profiles]
end

local function apply_profile()
    local current = hl.get_monitors()
    local connected = find_connected(current)
    local profile = pick_profile(connected)

    local found = {}
    for key, override in pairs(profile.monitors) do
        local output = connected[key] or known[key].output
        if output then
            set_monitor(output, known[key].rule, override)
            found[output] = true
        end
    end

    -- Reset monitors outside the profile to their default rule, in case a
    -- previous profile left an override on them.
    local key_by_output = {}
    for key, output in pairs(connected) do
        key_by_output[output] = key
    end
    for _, m in ipairs(current) do
        if not found[m.name] then
            local key = key_by_output[m.name]
            set_monitor(m.name, key and known[key].rule or default_rule)
        end
    end
end

-- Fallback for any unspecified monitor
set_monitor("", default_rule)

-- Soak time: wait for hotplug events to settle (e.g. a dock connecting several
-- monitors) before applying a profile, instead of applying each intermediate state.
local settle_timer = nil
local function apply_profile_when_settled()
    local _settle_timer = settle_timer
    if _settle_timer then
        _settle_timer:set_enabled(false)
    end

    settle_timer = hl.timer(function()
        settle_timer = nil
        apply_profile()
    end, { timeout = 500, type = "oneshot" })
end

apply_profile()
hl.on("monitor.added", apply_profile_when_settled)
hl.on("monitor.removed", apply_profile_when_settled)
