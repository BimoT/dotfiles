local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local screenshot_widget_full = wibox.widget {
    {
        {
            {
                id     = "theimage",
                image  = beautiful.camera_icon,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id                 = "thebackground",
        shape              = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg                 = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
    },
    left   = beautiful.widget_margin_outer,
    right  = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

return screenshot_widget_full
