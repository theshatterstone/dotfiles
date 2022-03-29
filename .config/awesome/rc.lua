local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local scratch       = require("scratch")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Meslo LGS Regular 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 32
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil

-- Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

-- entries must be comma-separated
run_once({ "wmname LG3D" }) -- Fix java problem
run_once({ "kbdd" })
run_once({ "nm-applet -sm-disable" }) -- Network manager tray icon

-- Variable definitions
local themes = {
    "pro-dark",           -- 1
    "pro-gotham",         -- 2
    "pro-light",          -- 3
    "pro-medium-dark",    -- 4
    "pro-medium-light",   -- 5
}

local chosen_theme = themes[4]
local modkey       = "Mod4"
local altkey       = "Mod4"
local terminal     = "gnome-terminal"
local editor       = os.getenv("EDITOR") or "text-editor"
local gui_editor   = "gvim"
local browser      = "firefox"
local guieditor    = "subl3"
local scrlocker    = "xlock"
local home   = os.getenv("HOME")

-- Theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. chosen_theme .. "/theme.lua")

-- Layouts
awful.util.terminal = terminal
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    lain.layout.centerwork,
    awful.layout.suit.spiral,
    awful.layout.suit.magnifier,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    lain.layout.cascade,
    lain.layout.cascade.tile,
    lain.layout.centerwork.horizontal,
    lain.layout.termfair.center,
}

awful.util.taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )
awful.util.tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function()
                         local instance = nil

                         return function ()
                             if instance and instance.wibox.visible then
                                 instance:hide()
                                 instance = nil
                             else
                                 instance = awful.menu.clients({ theme = { width = 250 } })
                             end
                        end
                     end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

-- Widgets
local markup = lain.util.markup
space3 = markup.font("Terminus 3", " ")
-- space2 = markup.font("Terminus 2", " ")
-- vspace1 = '<span font="Terminus 3"> </span>'
-- vspace2 = '<span font="Terminus 3">  </span>'
clockgf = beautiful.clockgf

spr = wibox.widget.imagebox(beautiful.spr)
spr4px = wibox.widget.imagebox(beautiful.spr4px)
spr5px = wibox.widget.imagebox(beautiful.spr5px)

widget_display = wibox.widget.imagebox(beautiful.widget_display)
widget_display_r = wibox.widget.imagebox(beautiful.widget_display_r)
widget_display_l = wibox.widget.imagebox(beautiful.widget_display_l)
widget_display_c = wibox.widget.imagebox(beautiful.widget_display_c)

-- Clock / Calendar
local clock_icon = wibox.widget.imagebox(beautiful.widget_clock)
local clock_types = {
    "%H:%M",          -- 13:19
    "%a %d %b %H:%M", -- Thu 08 Feb 13:19
}

local chosen_clock_type = clock_types[1] -- You can choose a clock type
local textclock = wibox.widget.textclock(markup(clockgf, space3 .. chosen_clock_type .. markup.font("Tamsyn 3", " ")))
local clock_widget = wibox.container.background(textclock)
clock_widget.bgimage=beautiful.widget_display
lain.widget.calendar({
    cal = "cal --color=always",
    attach_to = { textclock },
    notification_preset = {
        font = beautiful.calendar_font,
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- CPU
local cpu_icon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(space3 .. cpu_now.usage .. "%" .. markup.font("Tamsyn 4", " "))
    end
})
local cpu_widget = wibox.container.background(cpu.widget)
cpu_widget.bgimage=beautiful.widget_display

-- MEM
local mem_icon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(space3 .. mem_now.used .. "MB" .. markup.font("Tamsyn 4", " "))
    end
})
local mem_widget = wibox.container.background(mem.widget)
mem_widget.bgimage=beautiful.widget_display

-- Net
local netdl_icon = wibox.widget.imagebox(beautiful.widget_netdl)
local netup_icon = wibox.widget.imagebox(beautiful.widget_netul)

local net_widgetdl = lain.widget.net({
    iface = "wlp3s0",
    settings = function()
        widget:set_markup(markup.font("Tamsyn 1", " ") .. net_now.received)
    end
})
local net_widgetul = lain.widget.net({
    iface = "wlp3s0",
    settings = function()
        widget:set_markup(markup.font("Tamsyn 1", "  ") .. net_now.sent)
    end
})
local netdl_widget = wibox.container.background(net_widgetdl.widget)
netdl_widget.bgimage=beautiful.widget_display
local netup_widget = wibox.container.background(net_widgetul.widget)
netup_widget.bgimage=beautiful.widget_display

-- Keyboard layout switcher
kbdwidget = wibox.widget.textbox()
kbdwidget.border_width = 1
kbdwidget.border_color = beautiful.bg_normal
kbdwidget.font = beautiful.font
kbdwidget:set_markup("<span foreground=".."'"..beautiful.fg_normal.."'".."> Eng </span>")

kbdstrings = {[0] = " Eng ",
              [1] = " Rus "}

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    kbdwidget:set_markup("<span foreground=".."'"..beautiful.fg_normal.."'"..">" .. kbdstrings[layout] .. "</span>")
    end
)
local kbd_widget = wibox.container.background(kbdwidget)
kbd_widget.bgimage=beautiful.widget_display

-- FS
local fs_icon = wibox.widget.imagebox(beautiful.widget_fs)
local fs = lain.widget.fs({
    notification_preset = { fg = beautiful.fg_normal, bg = beautiful.bg_normal, font = beautiful.fs_font },
    settings = function()
        local fsp = string.format(" %3.2f %s ", fs_now["/home"].free, fs_now["/home"].units)
        widget:set_markup(markup.font(beautiful.font, fsp))
    end
})
local fs_widget = wibox.container.background(fs.widget)
fs_widget.bgimage=beautiful.widget_display
-- MPD

prev_icon = wibox.widget.imagebox(beautiful.mpd_prev)
next_icon = wibox.widget.imagebox(beautiful.mpd_nex)
stop_icon = wibox.widget.imagebox(beautiful.mpd_stop)
pause_icon = wibox.widget.imagebox(beautiful.mpd_pause)
play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)

mpdwidget = lain.widget.mpd({
    settings = function ()
        if mpd_now.state == "play" then
            mpd_now.artist = mpd_now.artist:upper():gsub("&.-;", string.lower)
            mpd_now.title = mpd_now.title:upper():gsub("&.-;", string.lower)
            widget:set_markup(markup.font("Tamsyn 3", " ")
                              .. markup.font("Tamsyn 7",
                              mpd_now.artist
                              .. " - " ..
                              mpd_now.title
                              .. markup.font("Tamsyn 2", " ")))
            play_pause_icon = wibox.widget.imagebox(beautiful.mpd_pause)
            mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
            mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font("Tamsyn 4", "") ..
                              markup.font("Tamsyn 7", "MPD PAUSED") ..
                              markup.font("Tamsyn 10", ""))
            play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
            mpd_sepl = wibox.widget.imagebox(beautiful.mpd_sepl)
            mpd_sepr = wibox.widget.imagebox(beautiful.mpd_sepr)
        else
            widget:set_markup("")
            play_pause_icon = wibox.widget.imagebox(beautiful.mpd_play)
            mpd_sepl = wibox.widget.imagebox(nil)
            mpd_sepr = wibox.widget.imagebox(nil)
        end
    end
})

music_widget = wibox.container.background(mpdwidget.widget)
music_widget.bgimage=beautiful.widget_display
music_widget:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.util.spawn_with_shell(ncmpcpp) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc prev || ncmpcpp prev")
    mpdwidget.update()
end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc next || ncmpcpp next")
    mpdwidget.update()
end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    play_pause_icon:set_image(beautiful.play)
    awful.util.spawn_with_shell("mpc stop || ncmpcpp stop")
    mpdwidget.update()
end)))
play_pause_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle")
    mpdwidget.update()
end)))

-- Battery
local bat_icon = wibox.widget.imagebox(beautiful.widget_battery)
local bat = lain.widget.bat({
    battery = "BAT0",
    timeout = 1,
    notify = "on",
    n_perc = {5,15},
    settings = function()
        bat_notification_low_preset = {
            title = "Battery low",
            text = "Plug the cable!",
            timeout = 15,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
        bat_notification_critical_preset = {
            title = "Battery exhausted",
            text = "Shutdown imminent",
            timeout = 15,
            fg = beautiful.bat_fg_critical,
            bg = beautiful.bat_bg_critical
        }

        if bat_now.status ~= "N/A" then
            if bat_now.status == "Charging" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " +" .. bat_now.perc .. "%")))
                bat_icon:set_image(beautiful.widget_ac)
            elseif bat_now.status == "Full" then
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " ~" .. bat_now.perc .. "%")))
                bat_icon:set_image(beautiful.widget_battery)
            elseif tonumber(bat_now.perc) <= 35 then
                bat_icon:set_image(beautiful.widget_battery_empty)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " -" .. bat_now.perc .. "%")))
            elseif tonumber(bat_now.perc) <= 80 then
                bat_icon:set_image(beautiful.widget_battery_low)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " -" .. bat_now.perc .. "%")))
            elseif tonumber(bat_now.perc) <= 99 then
                bat_icon:set_image(beautiful.widget_battery)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " -" .. bat_now.perc .. "%")))
            else
                bat_icon:set_image(beautiful.widget_battery)
                widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " -" .. bat_now.perc .. "%")))
            end
        else
            widget:set_markup(markup.font(beautiful.font, markup.fg.color(beautiful.fg_normal, " AC ")))
            bat_icon:set_image(beautiful.widget_ac)
        end
    end
})
local bat_widget = wibox.container.background(bat.widget)
bat_widget.bgimage=beautiful.widget_display

-- Mail
local mail_icon = wibox.widget.imagebox(beautiful.widget_mail)
-- commented because it needs to be set before use
-- local mail = lain.widget.imap({
--     timeout  = 180,
--     server   = "server",
--     mail     = "login",
--     password = "password",
--     settings = function()
--         mail_notification_preset.fg = beutiful.fg_normal
--         mail  = ""
--         count = ""

--         if mailcount > 0 then
--             mail = "Mail "
--             count = mailcount .. " "
--         end

--         widget:set_markup(markup.font(beautiful.font, markup(blue, mail) .. markup("#FFFFFF", count)))
--     end
-- })
-- local mail_widget = wibox.container.background(mail.widget)
-- mail_widget.bgimage=beautiful.widget_display

function connect(s)
  s.quake = lain.util.quake({ app = awful.util.terminal })

  -- If wallpaper is a function, call it with the screen
  local wallpaper = beautiful.wallpaper
  if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
  end
  gears.wallpaper.maximized(wallpaper, s, true)

  -- Tags
  --awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])
  layout = { awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[1], awful.layout.layouts[3], awful.layout.layouts[5], awful.layout.layouts[5]}
  awful.tag({ "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  " }, s, layout)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc( 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(-1) end),
                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, height = 22, bg = beautiful.panel, fg = beautiful.fg_normal })

  -- Add widgets to the wibox
  s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          spr5px,
          s.mytaglist,
          spr5px,
          chrome_button,

      },
      s.mytasklist, -- Middle widget
      --nil,
      { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          s.mypromptbox,
          wibox.widget.systray(),
          spr5px,
          spr,
          widget_display_l,
          kbd_widget,
          widget_display_r,
          spr,
          spr5px,
          -- MPD widget
          spr,
          prev_icon,
          spr,
          stop_icon,
          spr,
          play_pause_icon,
          spr,
          next_icon,
          mpd_sepl,
          music_widget,
          mpd_sepr,
          spr5px,
          -- Mail widget
          spr,
          mail_icon,
          widget_display_l,
          mail_widget,
          widget_display_r,
          spr5px,
          -- CPU widget
          spr,
          cpu_icon,
          widget_display_l,
          cpu_widget,
          widget_display_r,
          spr5px,
          -- Mem widget
          spr,
          mem_icon,
          widget_display_l,
          mem_widget,
          widget_display_r,
          spr5px,
          -- Fs widget
          spr,
          fs_icon,
          widget_display_l,
          fs_widget,
          widget_display_r,
          spr5px,
          -- Net widget
          spr,
          netdl_icon,
          widget_display_l,
          netdl_widget,
          widget_display_c,
          netup_widget,
          widget_display_r,
          netup_icon,
          -- Battery widget
          spr,
          bat_icon,
          widget_display_l,
          bat_widget,
          widget_display_r,
          spr5px,
          -- Clock
          spr,
          clock_icon,
          widget_display_l,
          clock_widget,
          widget_display_r,
          spr5px,
          spr,
          -- Layout box
          s.mylayoutbox,
      },
  }
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) connect(s) end)

-- Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})

screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}
    --),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    
    awful.key({ modkey },            "r",     function () awful.util.spawn('dmenu_run') end,
              {description = "run dmenu", group = "launcher"}),
    
    awful.key({ modkey },            "p",     function () awful.util.spawn('rofi -show run') end,
              {description = "run rofi", group = "launcher"}),
    
    awful.key({ modkey },            "l",     function () awful.util.spawn('rofi -show drun') end,
              {description = "run rofi drun", group = "launcher"}),

    awful.key({ modkey },            "w",     function () awful.util.spawn('firefox') end,
              {description = "run firefox", group = "launcher"}),

    awful.key({ modkey },            "Delete",     function () awful.util.spawn('shutdown now') end,
              {description = "shutdown now", group = "launcher"}),

    awful.key({ modkey, "Shift" },            "Delete",     function () awful.util.spawn('reboot') end,
              {description = "reboot now", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
-- Rules

awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },

    { rule = { class = "Caja" },
      properties = { floating = true, geometry = { x=200, y=150, height=600, width=1100 } } },
    { rule = { class = "Nm-connection-editor" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { role = "_NET_WM_STATE_FULLSCREEN" },
      properties = { floating = true } },
    { rule = { class = "Gimp", role = "gimp-image-window" },
      properties = { maximized = true } },
}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 16}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized then -- no borders if only 1 client visible
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell('nitrogen --restore')

