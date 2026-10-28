-- Launch apps when their special workspace is created empty.
local scratchpad_apps = {}
hl.on("workspace.created", function(ws)
    local cmd = scratchpad_apps[ws.name]
    if cmd and ws.is_empty then
        hl.exec_cmd(cmd, { workspace = ws.name })
    end
end)

local signal = "ALT + s"
scratchpad_apps["special:signal"] = "uwsm-app -s b -- flatpak run org.signal.Signal --enable-features=UseOzonePlatform --ozone-platform=wayland"
hl.bind(signal, hl.dsp.workspace.toggle_special("signal"))
hl.bind("SHIFT + " .. signal, hl.dsp.window.move({ workspace = "special:signal" }))

local telegram = "ALT + f"
scratchpad_apps["special:telegram"] = "uwsm-app -s b -- flatpak run org.telegram.desktop --enable-features=UseOzonePlatform --ozone-platform=wayland"
hl.bind(telegram, hl.dsp.workspace.toggle_special("telegram"))
hl.bind("SHIFT + " .. telegram, hl.dsp.window.move({ workspace = "special:telegram" }))

local temp = "ALT + d"
hl.bind(temp, hl.dsp.workspace.toggle_special("temp"))
hl.bind("SHIFT + " .. temp, function()
    hl.dispatch(hl.dsp.window.move({ workspace = "special:temp" }))
    hl.dispatch(hl.dsp.focus({ workspace = "special:temp" }))
end)

scratchpad_apps["special:keepassxc"] = "uwsm-app -s b -- flatpak run org.keepassxc.KeePassXC"
scratchpad_apps["special:spotify"] = "uwsm-app -s b -- flatpak run com.spotify.Client"

hl.define_submap("scratchpad", function()
    local keepassxc = "ALT + k"
    hl.bind(keepassxc, function()
        hl.dispatch(hl.dsp.workspace.toggle_special("keepassxc"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("SHIFT + " .. keepassxc, function()
        hl.dispatch(hl.dsp.window.move({ workspace = "special:keepassxc" }))
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    local spotify = "ALT + s"
    hl.bind(spotify, function()
        hl.dispatch(hl.dsp.workspace.toggle_special("spotify"))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
    hl.bind("SHIFT + " .. spotify, function()
        hl.dispatch(hl.dsp.window.move({ workspace = "special:spotify" }))
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)
hl.bind("ALT + a", hl.dsp.submap("scratchpad"))
