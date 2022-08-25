--[[ Creates a widget for easy screenshotting ]]
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local ICON_DIR = gears.filesystem.get_configuration_dir() .. 'icons/widget_icons/'

local scrsh_func = require("extras.screenshotfunc")


local screenshot_widget = wibox.widget {
    {
        {
            {
                id = "img",
                image = ICON_DIR .. "media_icon.png",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "bckgrnd",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    id = "mrgnout",
    left = beautiful.widget_margin_outer,
    right = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

screenshot_widget:connect_signal("mouse::enter", function()
    screenshot_widget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus)
end)
screenshot_widget:connect_signal("mouse::leave", function()
    screenshot_widget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal)
end)

screenshot_widget:buttons(
    gears.table.join(
       awful.button({}, 1, function() scrsh_func.flameshot_gui() end)
    )
)

return screenshot_widget
--vim:filetype=lua:expandtap:autoindent:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

