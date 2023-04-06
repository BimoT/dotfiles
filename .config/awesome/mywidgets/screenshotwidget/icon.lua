local wibox = require("wibox")
local beautiful = require("beautiful")

local screenshotwidget_icon = wibox.widget {
    id     = "thebackground",
    bg     = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id     = "theimage",
        image  = beautiful.camera_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

return screenshotwidget_icon
