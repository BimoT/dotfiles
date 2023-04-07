local beautiful = require("beautiful")
local gears = require("gears")

local M = {}

---Creates the background to be used for a focused '98 style titlebar
---@param c any The client window
M.focused_bg = function (c)
    gears.color({
        type  = "linear",
        from  = { 0, 0 },
        to    = { c.width, 0 },
        stops = {
            { 0, beautiful.bg_focus },
            { 1, beautiful.bg_focus2 }
        },
    })
end

---Creates the background to be used for an unfocused '98 style titlebar
---@param c any The client window
M.unfocused_bg = function (c)
    gears.color({
        type  = "linear",
        from  = { 0, 0 },
        to    = { c.width, 0 },
        stops = {
            { 0, beautiful.inactive_color },
            { 1, beautiful.inactive_color2 }
        },
    })
end

return M
