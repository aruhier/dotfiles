-- Window rules.
local float_rules = {
    { class = "org.kde.polkit-kde-authentication-agent-1" },
    { title = "Confirm to replace files" },
    { class = "file_progress" },
    { title = "File Operation Progress" },
    { class = "confirm" },
    { class = "dialog" },
    { class = "download" },
    { class = "notification" },
    { class = "error" },
    { class = "splash" },
    { title = "confirmreset" },
    { title = "Open File" },
    { title = "branchdialog" },
    { title = "(V|v)iewnior" },
    { class = "pavucontrol-qt" },
    { class = "pavucontrol" },
    { class = "file-roller" },
    { title = "^(Media viewer)$" },
    { title = "^(Volume Control)$" },
    { title = "^(Picture-in-Picture)$" },
    { class = "^(thunderbird)$", title = "^(.*)(Reminder)(.*)$" },
}
for _, match in ipairs(float_rules) do
    hl.window_rule({ match = match, float = true })
end

-- Layer rules.
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "wofi" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.9 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.9 })
