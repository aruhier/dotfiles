# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import subprocess
import startup


@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()


mod = "mod4"
alt = "mod1"

keys = [
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "ugrave", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod, "control"], "m", lazy.layout.maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),
    Key([mod, "control"], "f", lazy.window.toggle_floating()),
    Key([mod, "shift", "control"], "f", lazy.window.toggle_fullscreen()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "Tab", lazy.prev_layout()),
    Key([alt], "Tab", lazy.layout.next()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod, "shift"], "r", lazy.spawncmd()),
    Key([mod], "a", lazy.to_screen(2)),
    Key([mod], "z", lazy.to_screen(0)),
    Key([mod], "e", lazy.to_screen(1)),
    Key([mod, "control"], "l",
        lazy.spawn("light-locker-command -l")),

    # pulseaudio
    Key([mod], "F1", lazy.spawn("pulseaudio-ctl mute")),
    Key([], "XF86AudioMute", lazy.spawn("pulseaudio-ctl mute")),
    Key([mod], "F2", lazy.spawn("pulseaudio-ctl down")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pulseaudio-ctl down")),
    Key([mod], "F3", lazy.spawn("pulseaudio-ctl up")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pulseaudio-ctl up")),
    Key([mod], "F4", lazy.spawn("mpc toggle")),
    Key([mod], "F5", lazy.spawn("mpc prev")),
    Key([mod, "shift"], "F5", lazy.spawn("mpc seek -5")),
    Key([mod], "F6", lazy.spawn("mpc next")),
    Key([mod, "shift"], "F6", lazy.spawn("mpc seek +5")),
    Key([mod, "control"], "p", lazy.spawn("clerk --queue show")),


    # Applications shortcuts
    Key([mod], "Return", lazy.spawn("urxvt")),
    Key([alt], "w", lazy.spawn("firefox")),
    Key([alt], "x", lazy.spawn("thunderbird")),
]

groups = (
    [Group(i) for i in "qs"] +
    [Group("d", matches=[Match(wm_class=["Thunderbird", "Pidgin"])])] +
    [Group(i) for i in "fuiop"]
)

for i in groups:
    # mod + letter of group = switch to group
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )

    # mod + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name)))

layouts = [
    layout.MonadTall(ratio=0.5, margin=3, border_normal="ffffffff"),
    layout.Max(),
    layout.VerticalTile(fair=True),
    layout.RatioTile(
        border_width=2,
        margin=3, ratio_increment=0.1, ratio=2, fancy=False
    ),
    layout.Matrix(columns=2, margin=5),
]

widget_defaults = dict(
    font='Sans',
    fontsize=14,
    padding=3,
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Notify(),
                # widget.Mpd(host="127.0.0.1", port=6600, reconnect=True),
                widget.Spacer(30),
                widget.Systray(padding=15),
                widget.Spacer(15),
                widget.Sep(),
                widget.Spacer(15),
                widget.Backlight(
                    backlight_name="intel_backlight",
                    brightness_file="actual_brightness",
                    update_interval=0.5
                ),
                widget.Battery(),
                widget.Clock(format='%a %d %B %H:%M')
            ],
            27,
            opacity=0.95,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True

wmname = "LG3D"
subprocess.call(["xset", "-b"])
