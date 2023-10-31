"""Provides qtile with my personal config choices"""
from libqtile import bar, layout, hook, qtile, widget  # pylint: disable=E0401
from libqtile.backend.wayland import InputConfig  # pylint: disable=E0401
from libqtile.config import (  # pylint: disable=E0401
    Click,
    Drag,
    EzKey,
    Group,
    Key,
    Match,
    Screen,
)
from libqtile.lazy import lazy  # pylint: disable=E0401


@hook.subscribe.client_new
def mpv(window):
    """Move and follow mpv to workspace 9"""
    if ("mpv" in window.name) and ("mpv" in window.get_wm_class()):
        window.togroup("9", switch_group=True)


keys = [
    EzKey("M-<space>", lazy.next_layout()),  # switch to next layout
    EzKey("M-h", lazy.layout.left()),  # focus left
    EzKey("M-l", lazy.layout.right()),  # focus right
    EzKey("M-j", lazy.layout.down()),  # focus down
    EzKey("M-k", lazy.layout.up()),  # focus up
    EzKey("M-S-h", lazy.layout.shuffle_left()),  # move left
    EzKey("M-S-l", lazy.layout.shuffle_right()),  # move right
    EzKey("M-S-j", lazy.layout.shuffle_down()),  # move down
    EzKey("M-S-k", lazy.layout.shuffle_up()),  # move up
    EzKey("M-C-h", lazy.layout.grow_left()),  # resize left
    EzKey("M-C-l", lazy.layout.grow_right()),  # resize right
    EzKey("M-C-j", lazy.layout.grow_down()),  # resize down
    EzKey("M-C-k", lazy.layout.grow_up()),  # resize up
    EzKey("M-S-<Return>", lazy.spawn("foot")),  # spawn a terminal
    EzKey("M-<Tab>", lazy.layout.next()),  # switch to next window
    EzKey("M-S-c", lazy.window.kill()),
    EzKey(
        "M-f",
        lazy.window.toggle_fullscreen(),
    ),  # toggle fullscreen
    EzKey(
        "M-t",
        lazy.window.toggle_floating(),
    ),  # toggle floating
    EzKey("M-r", lazy.reload_config()),  # reload the config
    EzKey("M-S-q", lazy.shutdown()),  # exit qtile
    EzKey(
        "M-p",
        lazy.spawn("j4-dmenu-desktop --dmenu='tofi' --no-generic"),
    ),  # tofi is like dmenu
    EzKey(
        "M-<equal>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
    ),  # volume up
    EzKey(
        "M-<minus>", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
    ),  # volume down
    EzKey(
        "M-m", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ),  # toggle audio
    EzKey(
        "M-<backslash>", lazy.spawn("playerctl play-pause")
    ),  # play/pause video/audio
    EzKey("M-<bracketleft>", lazy.spawn("playerctl previous")),  # previous track
    EzKey("M-<bracketright>", lazy.spawn("playerctl next")),  # next track
]

if qtile.core.name == "wayland":
    for i in range(1, 7):
        keys.extend([EzKey(f"C-A-<f{i}>", lazy.core.change_vt(i))])

for i in [Group(str(s)) for s in range(10)]:
    keys.extend(
        [
            Key(
                ["mod4"],
                i.name,
                lazy.group[i.name].toscreen(),
            ),  # mod+<number> to switch workspace
            Key(
                ["mod4", "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            ),  # mod+shift+<number> to move and follow window to workspace
        ]
    )

mouse = [
    Drag(
        ["mod4"],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        ["mod4"],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click(["mod4"], "Button2", lazy.window.bring_to_front()),
]

borders = {
    "border_focus": "#b6a0ff",
    "border_normal": "#444444",
    "border_width": 2,
}

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="awakened-poe-trade"),
    ],
    **borders,
)

layouts = [
    layout.Max(**borders, margin=2),
    layout.Columns(**borders, margin=2),
]

widget_defaults = {
    "font": "monospace",
    "fontsize": 17,
    "padding": 1,
}

myWidgets = [
    widget.GroupBox(
        block_highlight_text_color="000000",
        borderwidth=2,
        hide_unused=True,
        highlight_method="block",
        padding_x=4,
        this_current_screen_border="b6a0ff",
        use_mouse_wheel=False,
    ),
    widget.TextBox("> ", foreground="#a8a8a8"),
    widget.WindowName(foreground="#b0d6f5"),
    widget.GenPollCommand(
        cmd="pactl get-sink-mute @DEFAULT_SINK@ | sed -e 's/Mute: yes/AUDIO OFF /' -e 's/Mute: no//'",  # pylint: disable=C0301
        foreground="#ff8059",
        shell=True,
        update_interval=1,
    ),
    widget.TextBox(fmt=" "),
    widget.GenPollCommand(
        cmd="pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume:/ {print $5}'",
        shell=True,
        update_interval=1,
    ),
    widget.TextBox(fmt=" &lt; ", foreground="#a8a8a8"),
    widget.Memory(
        format="{MemUsed:0.0f}{mm}/{MemTotal:0.0f}{mm} ({MemPercent:0.0f}%)",
        foreground="#b0d6f5",
    ),
    widget.TextBox(fmt=" &lt; ", foreground="#a8a8a8"),
    widget.GenPollCommand(
        cmd="ip -br a | grep UP | sed 's/   //g' | cut -d ' ' -f 3 | cut -d/ -f1",
        shell=True,
        foreground="#6ae4b9",
    ),
    widget.TextBox(fmt=" &lt; ", foreground="#a8a8a8"),
    widget.Load(format="{load:.2f}"),
    widget.TextBox(fmt=" &lt; ", foreground="#a8a8a8"),
    widget.Clock(foreground="#f8dec0", format="%0e %^a %H:%M "),
]

screens = [
    Screen(
        top=bar.Bar(
            myWidgets,
            24,
        )
    )
]


auto_fullscreen = False  # pylint: disable=C0103
bring_front_click = True  # pylint: disable=C0103
focus_on_window_activation = "never"  # pylint: disable=C0103
follow_mouse_focus = False  # pylint: disable=C0103

if qtile.core.name == "wayland":
    wl_input_rules = {
        "type:pointer": InputConfig(accel_profile="flat"),
    }
