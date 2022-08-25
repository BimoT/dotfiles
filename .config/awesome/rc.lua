-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awesome, client, screen, root = awesome, client, screen, root
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local mytheme = "redandgold"
beautiful.init("~/.config/awesome/themes/"..mytheme..".lua")
-- to set dpi, custom added
-- local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- {{{ Variable definitions
-- Notification library

local ICON_DIR = os.getenv('HOME') .. '/Pictures/Icons/'
--[[ custom libraries ]]
user = {
    terminal = "alacritty",
    webbrowser = "firefox",
    editor = "nvim",
    filemanager_gui = "thunar",
    filemanager_tui = "lf",
    icon_dir = gears.filesystem.get_configuration_dir() .. "icons/"
}
local mywidgets = require("mywidgets")
require("titlebar."..mytheme)
local signaling = require("signaling")
local apps = require("extras.apps")
local helpers = require("extras.helpers")
local keybindings = require("keybindings")

-- {{{ error handling
-- check if awesome encountered an error during startup and fell back to
-- another config (this code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}


-- This is used later as the default terminal and editor to run.
local terminal = user.terminal

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", helpers.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    helpers.set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keybindings.taglist_buttons,
        --new
        style = {
                    shape = function(cr, width, height)
                        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 0)
                    end,
                    squares_resize = true,
                    spacing = 5,
                }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = keybindings.tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 9,
                    color         = '#111111',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 1,
            layout  = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 5,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 5,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    -- Create the wibox
    -- manually adjusted height, visible
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 40, visible = true })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mywidgets.poweroffwidget,
            s.mytaglist,
            -- s.mypromptbox, -- <<disabled here cause we use rofi>>
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mywidgets.awesomewidget,
            mywidgets.screenshotwidget,
            mywidgets.diskwidget,
            mywidgets.brightnesswidget,
            mywidgets.volumewidget,
            mywidgets.keyboardwidget,
            wibox.widget.systray(),
            -- mytextclock,
            mywidgets.clockwidget,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons = keybindings.desktopbuttons
-- }}}

-- {{{ Key bindings
globalkeys = keybindings.globalkeys

clientkeys = keybindings.clientkeys

clientbuttons = keybindings.clientbuttons

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            titlebars_enabled = true,
            requests_no_titlebars = false,
            raise = true,
            keys = keybindings.clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients have titlebars.
    { rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester",  -- xev.
        },
        role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "ConfigManager",  -- Thunderbird's about:config.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
        properties = {
            floating = true,
            titlebars_enabled = true,
            requests_no_titlebars = false
        }
    },

    --[[ When clients spawn as float, manually give them "startasfloat" class ]]
    { rule_any = { instance = { "startasfloat" } },
    properties = { placement = awful.placement.centered, floating = true }},

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" }},
    --    except_any = {instance = { "gvim", "Alacritty", "gcolor" }},
    --    properties = { titlebars_enabled = true }
    --},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    --[[ Shape of the window ]]
    c.shape = function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 20) end
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
          -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
client.connect_signal("manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
-- currently disabled
--[[
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
--]]
if beautiful.border_width > 0 then
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
    end)
end
-- }}}


--{{ Autostart Aplications
awful.spawn.with_shell("nm-applet")
--[[ If no terminal is open, then open a terminal ]]
awful.spawn.with_shell("[[ -n $(ps cax | grep "..terminal..") ]] || "..terminal )
--}}
-- vim: filetype=lua:expandtab:shiftwidth=4
