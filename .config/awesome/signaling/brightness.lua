local awful = require("awful")
local naughty = require("naughty")
-- local theme = require("bimotheme")
local notificate = require("extras.notificate")

-- TODO: switch to naughty.notification when at Awesome version 4.4 (naughty.notify -> naughty.notification)
-- this uses naughty.notify, which will be deprecated in Awesome version 4.4

local brightnesssignals = {}

---Signal to change brightness
--- 
---To be used by interacting with a widget, as well as the XF86 keyboard keys
---Emits: `signaling::brightness`
---@param val string
---|"up"
---|"down"
brightnesssignals.change_brightness = function (val)
    local direction
    if val == "up" then direction = "A" elseif val == "down" then direction = "U" else
        naughty.notify({title = "Error", bg = "#f00", fg = "#fff", text = "unexpected argument in brightnessignals.change_brightness"})
    end
    awful.spawn.easy_async_with_shell( "sudo brillo -" .. direction .. " 5 -q; brillo -G",
        function(stdout)
            local brightness_int = stdout:match("^(%d+)")
            -- needs more work?
            notificate.brightness(brightness_int) -- so only update after the brightness has been changed
            awesome.emit_signal("signaling::brightness", brightness_int)
        end)
end


return brightnesssignals
