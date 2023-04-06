local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local apps = require("extras.apps")

--[[ Creates a widget for easy screenshotting ]]

local screenshot_widget_full = wibox.widget {
    {
        {
            {
                id = "theimage",
                image = beautiful.camera_icon,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "thebackground",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    left = beautiful.widget_margin_outer,
    right = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

local screenshotwidget_icon = wibox.widget {
    id = "thebackground",
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id = "theimage",
        image = beautiful.camera_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

local screenshot_widget
if beautiful.want_icon_widgets then
    screenshot_widget = screenshotwidget_icon
else
    screenshot_widget = screenshot_widget_full
end

screenshot_widget:connect_signal("mouse::enter", function()
    screenshot_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
end)
screenshot_widget:connect_signal("mouse::leave", function()
    screenshot_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
end)

screenshot_widget:buttons(
    gears.table.join(
       awful.button({}, 1, function() apps.flameshot_gui() end)
    )
)

return screenshot_widget
