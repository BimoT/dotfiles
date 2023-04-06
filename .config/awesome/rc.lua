-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library stuff, prevents warnings during editing
local awesome, client, screen, root = awesome, client, screen, root

local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")

--[[ Initialize the theme ]]
local mytheme = require("mytheme")
local beautiful = require("beautiful") -- Theme handling library
beautiful.init("~/.config/awesome/themes/"..mytheme..".lua")
require("wibar."..mytheme)
require("titlebar."..mytheme)

local apps = require("extras.apps")
local helpers = require("extras.helpers")
local keybindings = require("keybindings")

-- {{{ error handling
-- check if awesome encountered an error during startup and fell back to
-- another config (this code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title  = "oops, there were errors during startup!",
        text   = awesome.startup_errors
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
            title  = "Oops, an error happened!",
            text   = tostring(err)
        })
        in_error = false
    end)
end
-- }}}


-- This is used later as the default terminal and editor to run.
local terminal = apps.terminal

awful.screen.connect_for_each_screen(function (s)
    helpers.set_wallpaper(s)
    awful.layout.layouts = {
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
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
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", helpers.set_wallpaper)

--[[ Mouse bindings ]]
root.buttons = keybindings.desktopbuttons

--[[ Key bindings ]]
globalkeys    = keybindings.globalkeys
clientkeys    = keybindings.clientkeys
clientbuttons = keybindings.clientbuttons
root.keys(globalkeys)

--[[ Rules ]]
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = {
            border_width          = beautiful.want_client_borders and beautiful.border_width,
            border_color          = beautiful.border_normal,
            focus                 = awful.client.focus.filter,
            raise                 = true,
            opacity               = 1,
            keys                  = keybindings.clientkeys,
            buttons               = clientbuttons,
            screen                = awful.screen.preferred,
            placement             = awful.placement.no_overlap+awful.placement.no_offscreen,
            titlebars_enabled     = true,
            requests_no_titlebars = false,
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
            floating              = true,
            titlebars_enabled     = true,
            requests_no_titlebars = false
        }
    },

    --[[ When clients spawn as float, manually give them "startasfloat" class ]]
    -- FIX: we need the original class name for titlebar, but floating needs to happen
    {
        rule_any = {
            class = {
                "alacrittyfloat"
            }
        },
        properties = {
            floating  = true,
            placement = awful.placement.centered,
        }
    },

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

--[[ Signals ]]
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    --[[ Shape of the window ]]
    -- c.shape = function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 20) end
    c.shape = function(cr, width, height) gears.shape.rectangle(cr, width, height) end
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


--[[ Sloppy focus, currently disabled ]]
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

-- [[ Borders ]]
if beautiful.want_client_borders and beautiful.border_width > 0 then
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_focus
        -- c.opacity = 1
    end)
end


--[[ Autostart Aplications ]]
-- Network manager
awful.spawn.with_shell("nm-applet")
-- If no terminal is open, then open a terminal
awful.spawn.with_shell("[[ -n $(ps cax | grep "..terminal..") ]] || "..terminal )
