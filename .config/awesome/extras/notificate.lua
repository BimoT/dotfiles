local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/Pictures/Icons/'

-- TODO: write function for custom stacking notifications
local funcs = {}



function funcs.brightness(value)
    -- takes the brightness value, adds a percentage sign, and makes a
    -- notification. This updates the notification if it already exists
    local options = {
        title = "Brightness:",
        text = "\n"..value.."%",
        font = beautiful.font_base.." 18",
        margin = dpi(20), --wibox.container.margin(left = 12, right = 12, top = 12, bottom = 12),
        --shape = gears.shape.rounded_rect,
        shape = function(cr, width, height ) gears.shape.infobubble(cr, width, height, 8, 15, 20) end,
        timeout = 2,
        position = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon = ICON_DIR .. "bright_white.png"
    }
    if brightnotify ~= nil then
        brightnotify = naughty.notify({ preset = options,
            replaces_id = brightnotify.id })
    else
        brightnotify = naughty.notify(options)
    end

end

function funcs.volume(value)
    -- takes the volume notification, adds a percentage sign, and makes a
    -- notification (or updates it if there is a notification already)
    local options = {
        title = "Volume:",
        text = "\n"..value.."%",
        font = beautiful.font_base.." 16",
        margin = dpi(20),
        --shape = gears.shape.rounded_rect,
        shape = function(cr, width, height ) gears.shape.infobubble(cr, width, height, 8, 15, 20) end,
        timeout = 2,
        position = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon = ICON_DIR .. "sound_icon.png"
    }
    if volumenotify ~= nil then -- create new one
        volumenotify = naughty.notify({ preset = options,
            replaces_id = volumenotify.id })
    else
        volumenotify = naughty.notify(options)
    end
end

function funcs.mute(status)
    -- Makes a notification of the mute status, or updates the existing
    -- notification
    local muted_options = {
        title = "Volume status:",
        text = "Muted",
        font = beautiful.font_base.." 18",
        margin = dpi(20),
        --shape = gears.shape.rounded_rect,
        shape = function(cr, width, height ) gears.shape.infobubble(cr, width, height, 8, 15, 20) end,
        timeout = 2,
        position = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon = ICON_DIR.."sound_icon_mute.png",
    }
    local unmuted_options = {
        title = "Volume status:",
        text = "Unmuted",
        font = beautiful.font_base.." 18",
        margin = dpi(20),
        --shape = gears.shape.rounded_rect,
        shape = function(cr, width, height) gears.shape.infobubble(cr, width, height, 8, 15, 20) end,
        timeout = 3,
        position = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon = ICON_DIR.."sound_icon.png",
    }
    
    local options = {
        muted = muted_options,
        unmuted = unmuted_options
    }

    if mutenotify ~= nil then -- create new one
        mutenotify = naughty.notify({preset = options[status],
            replaces_id = mutenotify.id})
    else
        mutenotify = naughty.notify({preset = options[status]})
    end
end


return funcs
-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent

