local C = require("conf.constants")

-- Fallback for any unspecified monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.monitor({
    output = C.monitors.lg_27,
    mode = "preferred",
    position = "auto",
    bitdepth = 10,
    cm = "dp3",
    supports_hdr = -1,
})

hl.monitor({
    output = C.monitors.msi_32,
    mode = "3840x2160@239.99Hz",
    position = "auto",
    max_luminance = 500,
    max_avg_luminance = 500,
    sdr_max_luminance = 200,
})

hl.monitor({
    output = C.monitors.dell_27,
    mode = "2560x1440@59.95100Hz",
    position = "auto",
})

local time_config_reload = os.time()
local function restart_waybar()
    hl.dispatch(hl.dsp.exec_cmd("pkill waybar; FREETYPE_PROPERTIES='cff:no-stem-darkening=0 autofitter:no-stem-darkening=0' waybar"))
end
hl.timer(restart_waybar, { timeout = 100, type = "oneshot"})
local waybar_timer = nil

hl.on("monitor.added", function()
    -- Leave some time as startup/reload.
    if os.time() - time_config_reload < 3 then
        return
    end

    if waybar_timer == nil then
        waybar_timer = hl.timer(function()
            restart_waybar()
            waybar_timer = nil
        end, { timeout = 2000, type = "oneshot"})
    else
        waybar_timer:set_timeout(2000)
    end
end)
