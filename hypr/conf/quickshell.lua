local C = require("conf.constants")

-- Output name -> workspace where its bar is hidden, e.g. { ["DP-2"] = "a" }.
local bar_hidden_on = {}

-- Workspace name -> its edge-to-edge rule, created on first use and then only toggled.
-- A config reload clears the rules and resets this table together.
local edge_rules = {}

-- Changing a workspace rule makes Hyprland move all persistent workspaces to their
-- rule's monitor. This is a workaround to pin them to the current monitor on change.
-- It is particularly an issue with the Quickshell bar autohide feature, that changes
-- dynamically the workspace rules.
local function keep_on_current_monitor()
    for _, ws in ipairs(hl.get_workspaces()) do
        if ws.id >= C.persistent_workspaces_range[1] and ws.id <= C.persistent_workspaces_range[2] and ws.monitor then
            hl.workspace_rule({ workspace = tostring(ws.id), monitor = ws.monitor.name })
        end
    end
end

local function set_edges(name, flush)
    local rule = edge_rules[name]
    if not rule and not flush then
        return
    end
    keep_on_current_monitor()
    if rule then
        rule:set_enabled(flush)
    else
        edge_rules[name] = hl.workspace_rule({
            workspace = "name:" .. name,
            gaps_out = 0,
            no_border = true,
            no_rounding = true,
        })
    end
end

-- Checks if another output's bar is also hidden on this workspace.
local function held_elsewhere(name)
    for _, held in pairs(bar_hidden_on) do
        if held == name then
            return true
        end
    end
    return false
end

-- Entry points for Quickshell, global so `hyprctl eval` can reach them.
quickshell = {}

-- Hides the bar on a workspace (name) or shows again (nil).
function quickshell.bar_autohide(output, name)
    local old = bar_hidden_on[output]
    bar_hidden_on[output] = name
    if old == name then
        return
    end
    if old and not held_elsewhere(old) then
        set_edges(old, false)
    end
    if name then
        set_edges(name, true)
    end
end

-- On quickshell exit or crash, restore the edges rules on that output.
-- Skipped if another bar is still there (a reload opens the new bar first).
hl.on("layer.closed", function(layer)
    if layer.namespace ~= "quickshell-bar" or not layer.monitor then
        return
    end
    local output = layer.monitor.name
    for _, other in ipairs(hl.get_layers()) do
        if other.namespace == "quickshell-bar" and other.address ~= layer.address
            and other.mapped and other.monitor and other.monitor.name == output then
            return
        end
    end
    quickshell.bar_autohide(output, nil)
end)

-- An unplugged output's bar is destroyed without telling quickshell, and layer.closed
-- can't say which output it was on once the monitor is gone. Disable the autohide to
-- restore the workspaces gaps.
hl.on("monitor.removed", function(monitor)
    local output = type(monitor) == "string" and monitor or (monitor and monitor.name)
    if output and bar_hidden_on[output] then
        quickshell.bar_autohide(output, nil)
    end
end)
