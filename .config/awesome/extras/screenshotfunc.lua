local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local SCREENSHOT_DIR = "~/Pictures/Screenshots/"
local ICON_DIR = "~/.config/awesome/Icons/"

local container = {}

function container.flameshot_gui()
    -- captures a part of the screen with a GUI interface
    awful.spawn.with_shell("flameshot gui -p "..SCREENSHOT_DIR)
end

function container.flameshot_cli()
    -- captures the whole screen
    awful.spawn.with_shell("flameshot screen -p "..SCREENSHOT_DIR)
    naughty.notify({
        title = "Screenshot taken",
        text = SCREENSHOT_DIR,
        font = beautiful.font_base.." 18",
        margin = dpi(20), --wibox.container.margin(left = 12, right = 12, top = 12, bottom = 12),
        --shape = gears.shape.rounded_rect,
        shape = function(cr, width, height ) gears.shape.infobubble(cr, width, height, 8, 15, 20) end,
        timeout = 2,
        position = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon = ICON_DIR.."Widget_icons/media_icon.png",
    })
end

return container
-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent
