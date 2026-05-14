hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,
        border_size = 2,
        no_focus_fallback = true,
        layout = "dwindle",
        col = {
            active_border = "rgba(817f7faa)",
            inactive_border = "rgba(424242aa)",
        },
    },

    binds = {
        -- With focus and move window, stay on the current monitor.
        -- Example: with 2 monitors, focus left from the edge of the right monitor will not jump to the left monitor.
        window_direction_monitor_fallback = false,
        hide_special_on_workspace_change = true,
    },

    cursor = {
        min_refresh_rate = 48,
        no_warps = true,
    },

    dwindle = {
        force_split = 2,
        preserve_split = true,
        special_scale_factor = 0.86,
    },

    decoration = {
        rounding = 5,
        rounding_power = 4,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            popups = true,
        },
        shadow = {
            range = 8,
        },
    },

    input = {
        kb_layout = "us",
        kb_options = "compose:ralt",
        repeat_rate = 35,
        repeat_delay = 333,
        numlock_by_default = true,
        follow_mouse = 2,
        float_switch_override_focus = 0,
        mouse_refocus = false,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            disable_while_typing = true,
            natural_scroll = false,
            middle_button_emulation = true,
            scroll_factor = 0.5,
        },
    },

    misc = {
        -- Buggy on OLED screen, creates flicker on Firefox fullscreen.
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_focuses_monitor = false,
    },

    xwayland = {
        -- Pixelated: https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = true,
    },

    ecosystem = {
        enforce_permissions = true,
    },
})
