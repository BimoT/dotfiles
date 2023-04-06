local naughty = require("naughty")
local awful = require("awful")
local notificate = require("extras.notificate")

local volumesignals = {}

---Signal to change volume
--- 
---To be used by interacting with a widget, as well as the XF86 keyboard keys
---Emits: `signaling::volume`
---@param upordown string
---|"up"
---|"down"
volumesignals.change_volume = function(upordown)
    --[[
        as well as when scrolling over the widget.
        Emits a signal called "signaling::volume"
    --]]
    local cmd
    if upordown == "down" then
        cmd = 'pamixer -u; [[ $(pamixer --get-volume) -le 10 ]] && pamixer -d 2 || pamixer -d 5; pamixer --get-volume-human'
    elseif upordown == "up" then -- increase volume
        cmd = 'pamixer -u; [[ $(pamixer --get-volume) -lt 10 ]] && pamixer -i 2 || pamixer -i 5; pamixer --get-volume-human'
    else
        naughty.notify({title = "Error", bg = "#f00", fg = "#fff", text = "unexpected argument in volumesignals.change_volume"})
    end
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local volume_int = stdout:match("^(%d+)")
        notificate.volume(volume_int)
        awesome.emit_signal("signaling::volume", volume_int)
    end)
end

---Signal to toggle mute/unmute
--- 
---To be used by interacting with a widget, as well as the XF86 keyboard keys
---Emits: `signaling::mute`
volumesignals.toggle_mute = function()
    awful.spawn.easy_async_with_shell("pamixer -t; pamixer --get-mute",
        function(stdout)
            local mute_status
            if stdout == "true\n" then --audio is muted, so set mute icon
                mute_status = "muted"
                notificate.mute("muted")
            else
                notificate.mute("unmuted")
                mute_status = "unmuted"
            end
            awesome.emit_signal("signaling::mute", mute_status)
    end)
end

return volumesignals
