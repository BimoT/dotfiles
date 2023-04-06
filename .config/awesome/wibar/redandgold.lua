-- local client = client
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
-- local helpers = require("extras.helpers")
local beautiful = require("beautiful")
local mywidgets = require("mywidgets")
local keybindings = require("keybindings")

--[[ local taglist_buttons = gears.table.join( ]]
--[[     awful.button({ }, 1, function(t) t:view_only() end), ]]
--[[     awful.button({ modkey }, 1, function(t) ]]
--[[         if client.focus then ]]
--[[             client.focus:move_to_tag(t) ]]
--[[         end ]]
--[[     end), ]]
--[[     awful.button({ }, 3, awful.tag.viewtoggle), ]]
--[[     awful.button({ modkey }, 3, function(t) ]]
--[[         if client.focus then ]]
--[[             client.focus:toggle_tag(t) ]]
--[[         end ]]
--[[     end), ]]
--[[     awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end), ]]
--[[     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end) ]]
--[[ ) ]]
--[[ local tasklist_buttons = gears.table.join( ]]
--[[     awful.button({ }, 1, function (c) ]]
--[[         if c == client.focus then ]]
--[[             c.minimized = true ]]
--[[         else ]]
--[[             c:emit_signal("request::activate", "tasklist", {raise = true}) ]]
--[[         end ]]
--[[     end), ]]
--[[     awful.button({ }, 3, function() ]]
--[[         awful.menu.client_list({ theme = { width = 250 } }) ]]
--[[     end), ]]
--[[     awful.button({ }, 4, function () ]]
--[[         awful.client.focus.byidx(1) ]]
--[[     end), ]]
--[[     awful.button({ }, 5, function () ]]
--[[         awful.client.focus.byidx(-1) ]]
--[[ end)) ]]

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- helpers.set_wallpaper(s)


    --[[ awful.layout.layouts = { ]]
    --[[     awful.layout.suit.tile, ]]
    --[[     awful.layout.suit.tile.left, ]]
    --[[     awful.layout.suit.tile.bottom, ]]
    --[[     awful.layout.suit.tile.top, ]]
    --[[     awful.layout.suit.floating, ]]
    --[[     awful.layout.suit.fair, ]]
    --[[     awful.layout.suit.fair.horizontal, ]]
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    --[[ } ]]
    -- Each screen has its own tag table.
    --[[ awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1]) ]]

    -- Create a promptbox for each screen
    -- <<disabled in this custom config because we use rofi>>
    -- s.mypromptbox = awful.widget.prompt() --uncomment if you want it
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
    s.mywibox = awful.wibar({
        position = beautiful.wibar_position,
        screen = s,
        height = beautiful.wibar_height,
        visible = true
    })

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

