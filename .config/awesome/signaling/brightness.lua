local awful = require("awful")
local naughty = require("naughty")
-- local theme = require("bimotheme")
local notificate = require("extras.notificate")

-- BEWARE:
-- this uses naughty.notify, which will be deprecated in Awesome version 4.4
-- switch to naughty.notification when that happens

local brightnesssignals = {}
--[=[
brightnesssignals.change_redshift = function (option, widget)
    -- gets the state of redshift (either active or inactive), then either
    -- kills redshift or starts it
    local bash_cmd = '[[ -n "$(ps cax | grep redshift)" ]] && echo "active" || echo "inactive"'
    local redshift_state
        awful.spawn.easy_async_with_shell(bash_cmd,
            function(stdout)
            if option == "change" then
                if stdout == "active\n" then
                    awful.spawn.with_shell("killall redshift")
                    brightness_widget:get_children_by_id("redshift_icon")[1]:set_image(white_icon)
                elseif stdout == "inactive\n" then
                    awful.spawn.with_shell("redshift")
                    brightness_widget:get_children_by_id("redshift_icon")[1]:set_image(red_icon)
                else -- some error happened
                    naughty.notify({
                        title = "ERROR in redshift",
                        text = "Unexpected output: "..stdout.." from 'change_redshift' function",
                        bg = theme.bg_urgent,
                        fg = theme.black,
                        timeout = 0
                        })
                end
            end
        end)
end
--]=]

-- function notificate(id)
--     
--     local exists = naughty.getById(id)
-- 
--     if exists then
--         naughty.destroy
--     end
--     naughty.notify({})
-- end

brightnesssignals.change_brightness = function (val)
    --[[
        Signal to change brightness.
        upordown is either "up" or "down" for readability (instead of "A" or "U"), determines the volume change direction
        This should update the brightnesswidget, so that it can be used from both the keyboard with the XF86 keys,
        as well as when scrolling over the widget
    --]]
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
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent

