local wibox = require("wibox")
local beautiful = require("beautiful")

local volumewidget_icon = wibox.widget{
    id     = "thebackground",
    bg     = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id     = "theimage",
        image  = beautiful.sound_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

return volumewidget_icon
