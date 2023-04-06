local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local awesomewidget = wibox.widget {
    {
        {
            {
                widget = awful.widget.keyboardlayout,
            },
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        shape              = gears.shape.rounded_rect,
        bg                 = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
    },
    id     = "mrgnout",
    left   = beautiful.widget_margin_outer,
    right  = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

return awesomewidget
