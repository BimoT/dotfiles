local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

-- TODO: write function for custom stacking notifications
local funcs = {}


function funcs.brightness(value)
    -- takes the brightness value, adds a percentage sign, and makes a
    -- notification. This updates the notification if it already exists
    local options = {
        title        = "Brightness:",
        text         = "\n"..value.."%",
        font         = beautiful.font_base.." 18",
        margin       = dpi(20),
        shape        = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        timeout      = 2,
        position     = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon         = beautiful.brightness_icon,
    }
    if brightnotify ~= nil then
        brightnotify = naughty.notify({
            preset      = options,
            replaces_id = brightnotify.id
        })
    else
        brightnotify = naughty.notify(options)
    end
end

function funcs.volume(value)
    -- takes the volume notification, adds a percentage sign, and makes a
    -- notification (or updates it if there is a notification already)
    local options = {
        title        = "Volume:",
        text         = "\n"..value.."%",
        font         = beautiful.font_base.." 16",
        margin       = dpi(20),
        shape        = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        timeout      = 2,
        position     = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon         = beautiful.sound_icon,
    }
    if volumenotify ~= nil then -- create new one
        volumenotify = naughty.notify({
            preset      = options,
            replaces_id = volumenotify.id
        })
    else
        volumenotify = naughty.notify(options)
    end
end

function funcs.mute(status)
    -- Makes a notification of the mute status, or updates the existing
    -- notification
    local muted_options = {
        title        = "Volume status:",
        text         = "Muted",
        font         = beautiful.font_base.." 18",
        margin       = dpi(20),
        shape        = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        timeout      = 2,
        position     = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon         = beautiful.sound_icon_mute,
    }
    local unmuted_options = {
        title        = "Volume status:",
        text         = "Unmuted",
        font         = beautiful.font_base.." 18",
        margin       = dpi(20),
        shape        = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end,
        timeout      = 3,
        position     = "top_right",
        border_color = beautiful.border_focus,
        border_width = 2,
        icon         = beautiful.sound_icon,
    }
    local options = {
        muted   = muted_options,
        unmuted = unmuted_options
    }

    if mutenotify ~= nil then -- create new one
        mutenotify = naughty.notify({
            preset      = options[status],
            replaces_id = mutenotify.id
        })
    else
        mutenotify = naughty.notify({
            preset = options[status]
        })
    end
end

return funcs
