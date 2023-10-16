from libqtile import bar, layout, widget
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
ctl = "control"
shift = "shift"

keys = [
    Key([mod], "space", lazy.next_layout()),  # switch to next layout
    Key([mod], "h", lazy.layout.left()),  # focus left
    Key([mod], "l", lazy.layout.right()),  # focus right
    Key([mod], "j", lazy.layout.down()),  # focus down
    Key([mod], "k", lazy.layout.up()),  # focus up
    Key([mod, shift], "h", lazy.layout.shuffle_left()),  # move left
    Key([mod, shift], "l", lazy.layout.shuffle_right()),  # move right
    Key([mod, shift], "j", lazy.layout.shuffle_down()),  # move down
    Key([mod, shift], "k", lazy.layout.shuffle_up()),  # move up
    Key([mod, ctl], "h", lazy.layout.grow_left()),  # resize left
    Key([mod, ctl], "l", lazy.layout.grow_right()),  # resize right
    Key([mod, ctl], "j", lazy.layout.grow_down()),  # resize down
    Key([mod, ctl], "k", lazy.layout.grow_up()),  # resize up
    Key([mod], "n", lazy.layout.normalize()),  # TODO: what does this do?
    Key([mod, shift], "Return", lazy.spawn("alacritty")),  # spawn a terminal
    Key([mod], "Tab", lazy.layout.next()),  # switch to next window
    Key([mod, shift], "c", lazy.window.kill()),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
    ),  # toggle fullscreen
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
    ),  # toggle floating
    Key([mod], "r", lazy.reload_config()),  # reload the config
    Key([mod, shift], "q", lazy.shutdown()),  # exit qtile
    Key(
        [mod],
        "p",
        lazy.spawn("j4-dmenu-desktop --dmenu='tofi' --no-generic"),
    ),  # tofi is like dmenu
    Key(
        [mod], "equal", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
    ),  # volume up
    Key(
        [mod], "minus", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
    ),  # volume down
    Key(
        [mod], "m", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ),  # toggle audio
]

for i in [Group(str(s)) for s in range(10)]:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
            ),  # mod+<number> to switch workspace
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            ),  # mod+shift+<number> to move and follow window to workspace
        ]
    )

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="awakened-poe-trade"),
    ],
    border_focus="#b6a0ff",
    border_normal="#444444",
    border_width=2,
)

layouts = [
    layout.Max(
        border_focus="#b6a0ff", border_normal="#444444", border_width=2, margin=2
    ),
    layout.Columns(
        border_focus="#b6a0ff", border_normal="#444444", border_width=2, margin=2
    ),
    # TODO: try out more layouts
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Stack(num_stacks=2),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="monospace",
    fontsize=17,
    padding=1,
)

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
        cmd="pactl get-sink-mute @DEFAULT_SINK@ | sed -e 's/Mute: yes/AUDIO OFF /' -e 's/Mute: no//'",
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

auto_fullscreen = False
bring_front_click = True
focus_on_window_activation = "never"
follow_mouse_focus = False

wl_input_rules = {
    "type:pointer": InputConfig(accel_profile="flat"),
}
