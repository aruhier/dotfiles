local signal = "ALT + s"
hl.workspace_rule({
    workspace = "special:signal",
    on_created_empty = "flatpak run org.signal.Signal --enable-features=UseOzonePlatform --ozone-platform=wayland",
})
hl.bind(signal, hl.dsp.workspace.toggle_special("signal"))
hl.bind("SHIFT + " .. signal, hl.dsp.window.move({ workspace = "special:signal" }))

local telegram = "ALT + f"
hl.workspace_rule({
    workspace = "special:telegram",
    on_created_empty = "flatpak run org.telegram.desktop --enable-features=UseOzonePlatform --ozone-platform=wayland",
})
hl.bind(telegram, hl.dsp.workspace.toggle_special("telegram"))
hl.bind("SHIFT + " .. telegram, hl.dsp.window.move({ workspace = "special:telegram" }))

local temp = "ALT + d"
hl.bind(temp, hl.dsp.workspace.toggle_special("temp"))
hl.bind("SHIFT + " .. temp, function()
    hl.dispatch(hl.dsp.window.move({ workspace = "special:temp" }))
    hl.dispatch(hl.dsp.focus({ workspace = "special:temp" }))
end)

hl.workspace_rule({
    workspace = "special:keepassxc",
    on_created_empty = "flatpak run org.keepassxc.KeePassXC",
})
hl.workspace_rule({
    workspace = "special:spotify",
    on_created_empty = "flatpak run com.spotify.Client",
})

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
