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

import os
import re
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
#from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from typing import List   # noqa: F401from typing import List  # noqa: F401
from libqtile.backend.wayland import InputConfig
mod = "mod4"
terminal = guess_terminal()

myTerm = "alacritty"
fileman = "pcmanfm"
# if qtile.core.name == "x11":
#     myTerm = "alacritty"
#     fileman = "thunar"
#     bgchange = "feh --bg-fill --randomize /home/shatterstone/wallpapers"
# elif qtile.core.name == "wayland":
#     myTerm = "foot"
#     fileman = "pcmanfm"
#     bgchange = "swaybg -m fill -i ~/wallpapers/0066.jpg"

keys = [
         ### The essentials
         Key([mod], "Return",
             lazy.spawn(myTerm),
             desc='Launches My Terminal'
             ),
         Key([mod, "shift"], "Return",
             lazy.spawn(fileman),
             desc='File Manager'
             ),
         Key([mod], "p",
             lazy.spawn("rofi -combi-modi drun,run -show combi"),
             desc='Rofi'
             ),
         Key([mod], "e",
             lazy.spawn("emacsclient -c -a 'emacs'"),
             desc='Launch Emacs'
             ),
         Key([mod], "r",
             lazy.spawn("dmenu_run"),
             desc="dmenu"),
         Key([mod], "w",
             lazy.spawn(myBrowser),
             desc='Firefox'
             ),
        #  Key([mod, "shift"], "s",
        #      lazy.spawn(bgchange),
        #      desc='Change Wallpaper'
        #      ),
         Key([mod], "Tab",
             lazy.next_layout(),
             desc='Toggle through layouts'
             ),
         Key([mod, "shift"], "c",
             lazy.window.kill(),
             desc='Kill active window'
             ),
         Key([mod, "shift"], "r",
             lazy.restart(),
             desc='Restart Qtile'
             ),
         Key([mod, "shift"], "q",
             lazy.spawn('archlinux-logout'),
             desc='Shutdown Qtile'
             ),
                 # ------------ Hardware Configs ------------
        # Volume
        Key([], "XF86AudioMute",
            lazy.spawn("amixer set Master toggle"),
            desc='Mute audio'
            ),
        Key([], "XF86AudioLowerVolume",
            lazy.spawn("amixer set Master 1%-"),
            desc='Volume down'
            ),
        Key([], "XF86AudioRaiseVolume",
            lazy.spawn("amixer set Master 1%+"),
            desc='Volume up'
            ),

		# # Media keys
		# Key([], "XF86AudioPlay",
		# 	lazy.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify " "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.PlayPause"),
		# 	desc='Audio play'
		# 	),
		# Key([], "XF86AudioNext",
		# 	lazy.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify " "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.Next"),
		# 	desc='Audio next'
		# 	),
		# Key([], "XF86AudioPrev",
		# 	lazy.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify " "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.Previous"),
		# 	desc='Audio previous'
		# 	),

        # Brightness
        Key([], "XF86MonBrightnessDown",
            lazy.spawn("brightnessctl set 1%-"),
            desc='Brightness down'
            ),
        Key([], "XF86MonBrightnessUp",
            lazy.spawn("brightnessctl set +1%"),
            desc='Brightness up'
            ),
         ### Switch focus to specific monitor (out of three)
#         Key([mod], "w",
#           lazy.to_screen(0),
#           desc='Keyboard focus to monitor 1'
#             ),
#         Key([mod], "e",
#             lazy.to_screen(1),
#             desc='Keyboard focus to monitor 2'
#             ),
#         Key([mod], "r",
#             lazy.to_screen(2),
#             desc='Keyboard focus to monitor 3'
#             ),
#         ### Switch focus of monitors
#         Key([mod], "period",
#             lazy.next_screen(),
#             desc='Move focus to next monitor'
#             ),
#         Key([mod], "comma",
#             lazy.prev_screen(),
#             desc='Move focus to prev monitor'
#             ),
         ### Treetab controls
          Key([mod, "shift"], "h",
             lazy.layout.move_left(),
             desc='Move up a section in treetab'
             ),
         Key([mod, "shift"], "l",
             lazy.layout.move_right(),
             desc='Move down a section in treetab'
             ),
         ### Window controls
         Key([mod], "j",
             lazy.layout.down(),
             desc='Move focus down in current stack pane'
             ),
         Key([mod], "k",
             lazy.layout.up(),
             desc='Move focus up in current stack pane'
             ),
         Key([mod, "shift"], "j",
             lazy.layout.shuffle_down(),
             lazy.layout.section_down(),
             desc='Move windows down in current stack'
             ),
         Key([mod, "shift"], "k",
             lazy.layout.shuffle_up(),
             lazy.layout.section_up(),
             desc='Move windows up in current stack'
             ),
         Key([mod], "h",
             lazy.layout.shrink(),
             lazy.layout.decrease_nmaster(),
             desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
             ),
         Key([mod], "l",
             lazy.layout.grow(),
             lazy.layout.increase_nmaster(),
             desc='Expand window (MonadTall), increase number in master pane (Tile)'
             ),
         Key([mod], "n",
             lazy.layout.normalize(),
             desc='normalize window size ratios'
             ),
         Key([mod], "m",
             lazy.layout.maximize(),
             desc='toggle window between minimum and maximum sizes'
             ),
         Key([mod, "shift"], "f",
             lazy.window.toggle_floating(),
             desc='toggle floating'
             ),
         Key([mod], "f",
             lazy.window.toggle_fullscreen(),
             desc='toggle fullscreen'
             ),
         ### Stack controls
         Key([mod, "shift"], "Tab",
             lazy.layout.rotate(),
             lazy.layout.flip(),
             desc='Switch which side main pane occupies (XmonadTall)'
             ),
          Key([mod], "space",
             lazy.layout.next(),
             desc='Switch window focus to other pane(s) of stack'
             ),
         Key([mod, "shift"], "space",
             lazy.layout.toggle_split(),
             desc='Toggle between split and unsplit sides of stack'
             ),
         # Emacs programs launched using the key chord CTRL+e followed by 'key'
        #  KeyChord(["control"],"e", [
        #      Key([], "e",
        #          lazy.spawn("emacsclient -c -a 'emacs'"),
        #          desc='Launch Emacs'
        #          ),
        #      Key([], "b",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(ibuffer)'"),
        #          desc='Launch ibuffer inside Emacs'
        #          ),
        #      Key([], "d",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(dired nil)'"),
        #          desc='Launch dired inside Emacs'
        #          ),
        #      Key([], "i",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(erc)'"),
        #          desc='Launch erc inside Emacs'
        #          ),
        #      Key([], "m",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(mu4e)'"),
        #          desc='Launch mu4e inside Emacs'
        #          ),
        #      Key([], "n",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(elfeed)'"),
        #          desc='Launch elfeed inside Emacs'
        #          ),
        #      Key([], "s",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(eshell)'"),
        #          desc='Launch the eshell inside Emacs'
        #          ),
        #      Key([], "v",
        #          lazy.spawn("emacsclient -c -a 'emacs' --eval '(+vterm/here nil)'"),
        #          desc='Launch vterm inside Emacs'
        #          )
        #  ]),
        # Dmenu scripts launched using the key chord SUPER+d followed by 'key'
         KeyChord([mod], "d", [
             Key([], "e",
                 lazy.spawn("./dmscripts/dm-confedit"),
                 desc='Choose a config file to edit'
                 ),
             Key([], "i",
                 lazy.spawn("./dmscripts/dm-maim"),
                 desc='Take screenshots via dmenu'
                 ),
             Key([], "k",
                 lazy.spawn("./dmscripts/dm-kill"),
                 desc='Kill processes via dmenu'
                 ),
             Key([], "l",
                 lazy.spawn("./dmscripts/dm-logout"),
                 desc='A logout menu'
                 ),
             Key([], "m",
                 lazy.spawn("./dmscripts/dm-man"),
                 desc='Search manpages in dmenu'
                 ),
             Key([], "o",
                 lazy.spawn("./dmscripts/dm-bookman"),
                 desc='Search your qutebrowser bookmarks and quickmarks'
                 ),
             Key([], "r",
                 lazy.spawn("./dmscripts/dm-reddit"),
                 desc='Search reddit via dmenu'
                 ),
             Key([], "s",
                 lazy.spawn("./dmscripts/dm-websearch"),
                 desc='Search various search engines via dmenu'
                 ),
            #  Key([], "p",
            #      lazy.spawn("passmenu"),
            #      desc='Retrieve passwords with dmenu'
            #      )
         ])
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("default config", name="default"),
                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"