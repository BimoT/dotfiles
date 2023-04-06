local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local brightnesswidget_full = wibox.widget {
    {
        {
            {
                {
                    id     = "theimage",
                    image  = beautiful.brightness_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                {
                    id           = "thetext",
                    forced_width = dpi(50),
                    align        = "right",
                    widget       = wibox.widget.textbox,
                },
                id      = "thelayout",
                spacing = beautiful.widget_margin_outer,
                layout  = wibox.layout.fixed.horizontal,
            },
            id      = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id                 = "thebackground",
        shape              = function (cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        fg                 = beautiful.fg_normal,
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

return brightnesswidget_full
