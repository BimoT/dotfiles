local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local apps = require("extras.apps")

--[[ Creates a widget for easy screenshotting ]]

local screenshot_widget
if beautiful.want_icon_widgets then
    local icon = require("mywidgets.screenshotwidget.icon")
    screenshot_widget = icon
else
    local full = require("mywidgets.screenshotwidget.full")
    screenshot_widget = full
end

screenshot_widget:connect_signal("mouse::enter", function()
    screenshot_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
end)
screenshot_widget:connect_signal("mouse::leave", function()
    screenshot_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
end)

screenshot_widget:buttons(
    gears.table.join(
       awful.button({}, 1,
            function()
                apps.flameshot_gui()
            end
        )
    )
)

return screenshot_widget
