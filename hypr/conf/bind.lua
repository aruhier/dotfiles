local C = require("conf.constants")
local U = require("conf.utils")

-- Direction binding, as multiple bindings use it.
local directions_binds = {
    h = "l",
    l = "r",
    k = "u",
    j = "d"
}

-- Lock.
hl.bind(C.main_mod .. " + CTRL + SHIFT + l", hl.dsp.exec_cmd("loginctl lock-session"))

-- Wlogout.
hl.bind(C.main_mod .. " + m", hl.dsp.exec_cmd(C.scripts .. "/wlogout"))

-- Exit Hyprland.
hl.bind(C.main_mod .. " + CTRL + SHIFT + m", hl.dsp.exit())

-- DPMS on secondary screens.
local function dpms_external_screens(enable)
    local action = enable and "enable" or "disable"

    for _, monitor in ipairs(C.monitors) do
        if monitor ~= C.main_monitor then
            -- Use a timer as the doc recommends triggering dpms this way.
            hl.timer(
                function() hl.dispatch(hl.dsp.dpms({ action = action, monitor = monitor })) end,
                { timeout = 500, type = "oneshot" }
            )
        end
    end
end
hl.bind(C.main_mod .. " + SHIFT + F12", function() dpms_external_screens(false) end)
hl.bind(C.main_mod .. " + F12", function() dpms_external_screens(true) end)

-- Switch inputs on main screen (ddcutil).
hl.bind(C.main_mod .. " + F9",  hl.dsp.exec_cmd('ddcutil setvcp -l "MPG321UX OLED" 60 0x12')) -- HDMI
hl.bind(C.main_mod .. " + F10", hl.dsp.exec_cmd('ddcutil setvcp -l "MPG321UX OLED" 60 0x10')) -- USB-C
hl.bind(C.main_mod .. " + F11", hl.dsp.exec_cmd('ddcutil setvcp -l "MPG321UX OLED" 60 0x0f')) -- DisplayPort

--Ignore bindings submap.
hl.bind(C.main_mod .. " + CTRL + i", hl.dsp.submap("ignore"))
hl.define_submap("ignore", function()
    hl.bind(C.main_mod .. " + CTRL + i", hl.dsp.submap("reset"))
end)

-- Screenshots.
hl.bind(C.main_mod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window"))  -- window
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))  -- monitor
hl.bind(C.main_mod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region")) -- region

-- Volume.
for _, mute_bind in ipairs({ "XF86AudioMute", C.main_mod .. " + F1" }) do
    hl.bind(mute_bind, hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
end
for _, down_bind in ipairs({ "XF86AudioLowerVolume", C.main_mod .. " + F2" }) do
    hl.bind(down_bind, hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { locked = true })
    hl.bind("SHIFT + " .. down_bind, hl.dsp.exec_cmd("swayosd-client --output-volume -1"), { locked = true })
end
for _, up_bind in ipairs({ "XF86AudioRaiseVolume", C.main_mod .. " + F3" }) do
    hl.bind(up_bind, hl.dsp.exec_cmd("swayosd-client --output-volume +5"), { locked = true })
    hl.bind("SHIFT + " .. up_bind, hl.dsp.exec_cmd("swayosd-client --output-volume +1"), { locked = true })
end

-- Media keys.
for _, mpc_prev in ipairs({ "XF86AudioPrev", C.main_mod .. " + F5" }) do
    hl.bind(mpc_prev, hl.dsp.exec_cmd("mpc prev"),   { locked = true })
end
for _, mpc_play in ipairs({ "XF86AudioPlay", C.main_mod .. " + F6" }) do
    hl.bind(mpc_play, hl.dsp.exec_cmd("mpc toggle"),   { locked = true })
end
for _, mpc_next in ipairs({ "XF86AudioNext", C.main_mod .. " + F6" }) do
    hl.bind(mpc_next, hl.dsp.exec_cmd("mpc next"),   { locked = true })
end

-- Brightness.
local brightness_up_bind = "XF86MonBrightnessUp"
local brightness_down_bind = "XF86MonBrightnessDown"

hl.bind(brightness_up_bind, hl.dsp.exec_cmd("light -A 10"), { locked = true })
hl.bind("SHIFT + " .. brightness_up_bind, hl.dsp.exec_cmd("light -A 1"), { locked = true })
hl.bind(brightness_up_bind, hl.dsp.exec_cmd("light -U 10"), { locked = true })
hl.bind("SHIFT + " .. brightness_down_bind, hl.dsp.exec_cmd("light -U 1"), { locked = true })

-- Theme.
hl.bind(C.main_mod .. " + CTRL + F5", hl.dsp.exec_cmd(C.scripts .. "/theme everforest-dark"),  { locked = true })
hl.bind(C.main_mod .. " + CTRL + F6", hl.dsp.exec_cmd(C.scripts .. "/theme everforest-light"), { locked = true })

-- Notifications (swaync).
hl.bind(C.main_mod .. " + n", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(C.main_mod .. " + SHIFT + n", hl.dsp.exec_cmd("swaync-client -C"))

-- Close window.
hl.bind(C.main_mod .. " + z", hl.dsp.window.close())
-- Dwindle layout specific.
hl.bind(C.main_mod .. " + CTRL + p", hl.dsp.layout("pseudo"))

--Float.
hl.bind(C.main_mod .. " + CTRL + f", hl.dsp.window.float({ action = "toggle" }))
-- Monocle.
hl.bind(C.main_mod .. " + CTRL + t", hl.dsp.window.fullscreen({ mode = "maximized" }))
-- Fullscreen.
hl.bind(C.main_mod .. " + SHIFT + CTRL + f", hl.dsp.window.fullscreen())
-- Fake fullscreen.
hl.bind(C.main_mod .. " + ALT + f", hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }))

-- Move around, move windows around.
for key, dir in pairs(directions_binds) do
    hl.bind(C.main_mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
    hl.bind(C.main_mod .. " + SHIFT + " .. key, U.wrap_slide_bounce_anim(hl.dsp.window.move({ direction = dir })))
end

-- Cycle windows.
hl.bind(C.main_mod .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(C.main_mod .. " + SHIFT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({next = false}))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.focus({ last = true }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Move to screen.
local monitors_binds = {
    q = C.monitors.lg_27,
    w = C.main_monitor,
    e = C.monitors.dell_27,
}
for key, monitor in pairs(monitors_binds) do
    hl.bind(C.main_mod .. " + " .. key, hl.dsp.focus({ monitor = monitor }))
    hl.bind(C.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ monitor = monitor }))
end

-- Split ratio.
local split_ratios = {
    { key = "1", dwindle_ratio = "0.2", scrolling_ratio = "0.1" },
    { key = "2", dwindle_ratio = "0.4", scrolling_ratio = "0.2" },
    { key = "3", dwindle_ratio = "0.6", scrolling_ratio = "0.3" },
    { key = "4", dwindle_ratio = "0.8", scrolling_ratio = "0.4" },
    { key = "5", dwindle_ratio = "1.0", scrolling_ratio = "0.5" },
    { key = "6", dwindle_ratio = "1.2", scrolling_ratio = "0.6" },
    { key = "7", dwindle_ratio = "1.4", scrolling_ratio = "0.7" },
    { key = "8", dwindle_ratio = "1.6", scrolling_ratio = "0.8" },
    { key = "9", dwindle_ratio = "1.8", scrolling_ratio = "0.9" },
    { key = "0", dwindle_ratio = nil, scrolling_ratio = "1" },
}
for _, r in ipairs(split_ratios) do
    hl.bind(C.main_mod .. " + CTRL + " .. r.key, function()
        local layout = hl.get_active_workspace().tiled_layout
        if layout == "dwindle" and r.dwindle_ratio ~= nil then
            hl.dispatch(U.wrap_slide_bounce_anim((hl.dsp.layout("splitratio " .. r.dwindle_ratio .. " exact"))))
        elseif layout == "scrolling" and r.scrolling_ratio ~= nil then
            hl.dispatch(U.wrap_slide_bounce_anim(hl.dsp.layout("colresize " .. r.scrolling_ratio)))
        end
    end)
end

-- Split preselection.
for key, dir in pairs(directions_binds) do
    hl.bind(C.main_mod .. " + CTRL + " .. key, hl.dsp.layout("preselect " .. dir))
end
hl.bind(C.main_mod .. " + CTRL + Space", hl.dsp.layout("preselect ''"))

-- Split orientation (dwindle) or promote column (scrolling).
hl.bind(C.main_mod .. " + b", function()
    local layout = hl.get_active_workspace().tiled_layout
    if layout == "dwindle" then
        hl.dispatch(U.wrap_slide_bounce_anim(hl.dsp.layout("togglesplit")))
    elseif layout == "scrolling" then
        hl.dispatch(U.wrap_slide_bounce_anim(hl.dsp.layout("consume_or_expel next")))
    end
end)

-- Resize.
local resize_binds = {
    h = { x = -50,  y = 0   },
    l = { x = 50,   y = 0   },
    k = { x = 0,    y = -50 },
    j = { x = 0,    y = 50  },
}
-- TODO: fix it
for key, delta in pairs(resize_binds) do
    hl.bind(C.main_mod .. " + ALT + " .. key,         hl.dsp.window.resize({ x = delta.x,     y = delta.y,     relative = true }))
    hl.bind(C.main_mod .. " + ALT + SHIFT + " .. key, hl.dsp.window.resize({ x = delta.x * 2, y = delta.y * 2, relative = true }))
end

-- Resize submap.
hl.bind(C.main_mod .. " + CTRL + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    for key, delta in pairs(resize_binds) do
        hl.bind(key, hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }), { repeating = true })
    end
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Mouse binds.
hl.bind(C.main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(C.main_mod .. " + mouse:273", U.wrap_slide_bounce_anim(hl.dsp.window.resize()), { mouse = true })

-- Show active window title.
hl.bind(C.main_mod .. " + t", function()
    local w = hl.get_active_window()
    if w ~= nil then
        hl.notification.create({ text = w.title, duration = 5000 })
    end
end)

-- Apps

hl.bind(C.main_mod .. " + Return", hl.dsp.exec_cmd("foot"))
hl.bind(C.main_mod .. " + r", hl.dsp.exec_cmd("wofi -S drun --allow-images"))
hl.bind("ALT + z", hl.dsp.exec_cmd(C.scripts .. "/apps/firefox"))
hl.bind("ALT + x", hl.dsp.exec_cmd(C.scripts .. "/apps/thunderbird"))
