local wibox = require("wibox")
local beautiful = require("beautiful")

local brightnesswidget_icon = wibox.widget {
    id     = "thebackground",
    bg     = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id     = "theimage",
        image  = beautiful.brightness_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

return brightnesswidget_icon
