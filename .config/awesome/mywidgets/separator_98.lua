-- Separator widget for in the wibar in Awesome98
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local sep = { mt = {} }

-- 2 px spacing
-- 2 px v-bar, left=#808080, right=#ffffff
-- 2 px spacing
-- 3 px v-bar (4 px shorter than left bar, centered):
--      #808080 bg, then white, then #c0c0c0 (in reverse order, from bottom to top)
-- 4 px spacing
--FIX: this is not working yet!
local left_bar = {
    top    = dpi(1),
    bottom = dpi(1),
    widget = wibox.container.margin,
    {
        bg           = beautiful.inactive_color,
        shape        = gears.shape.rectangle,
        forced_width = dpi(2),
        widget       = wibox.container.background,
        {
            left   = dpi(1),
            widget = wibox.container.margin,
            {
                bg     = beautiful.white,
                widget = wibox.container.background,
                -- {
                --     widget = wibox.widget.textbox,
                --     text = ""
                -- }
            },
        },
    },
}

local right_bar = {
    top    = dpi(2),
    bottom = dpi(2),
    widget = wibox.container.margin,
    {
        bg            = beautiful.inactive_color,
        shape         = gears.shape.rectangle,
        forced_width  = dpi(3),
        -- forced_height = beautiful.wibar_height,
        widget        = wibox.container.background,
        {
            bottom = dpi(1),
            right  = dpi(1),
            widget = wibox.container.margin,
            {
                bg     = beautiful.white,
                widget = wibox.container.background,
                {
                    top  = dpi(1),
                    left = dpi(1),
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.bg_normal,
                        widget = wibox.container.background,
                        -- {
                        --     widget = wibox.widget.textbox,
                        --     text = ""
                        -- }
                    }
                }
            }
        }
    }
}

function sep.new()
    return wibox.widget.base.make_widget_declarative({
        bg     = beautiful.bf_normal,
        fg     = beautiful.fg_normal,
        widget = wibox.container.background,
        {
            left   = dpi(2),
            right  = dpi(4),
            widget = wibox.container.margin,
            {
                layout  = wibox.layout.fixed.horizontal,
                spacing = dpi(2),
                left_bar,
                right_bar,
                -- widget = wibox.widget.textbox,
                -- text = "h"
            }
        }
    })
end

function sep.mt:__call()
    return sep.new()
end
return setmetatable(sep, sep.mt)
