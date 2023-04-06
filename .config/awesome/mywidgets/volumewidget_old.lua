local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local signaling = require("signaling")

--[[
    Create widget for displaying volume.
    Depending on `want_icon_widgets` in the theme file, this will return either an icon widget, or an icon + text widget
--]]

local sound_icon = beautiful.sound_icon
local mute_icon  = beautiful.sound_icon_mute


local volumewidget_full = wibox.widget {
    {
        {
            {
                {
                    id     = "theimage",
                    image  = sound_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                {
                    id           = "thetext",
                    forced_width = dpi(50),
                    align        = "right",
                    --font       = "Ubuntu Nerd Font Complete 12",
                    widget       = wibox.widget.textbox,
                },
                id = "thelayout",
                spacing = beautiful.widget_margin_outer,
                layout = wibox.layout.fixed.horizontal,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "thebackground",
        shape = function (cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    id = "mrgnout",
    left = beautiful.widget_margin_outer,
    right = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

local volumewidget_icon = wibox.widget{
    id = "thebackground",
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id = "theimage",
        image = sound_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

local volumewidget
local volume_timer
if beautiful.want_icon_widgets then
    volumewidget = volumewidget_icon
else
    volumewidget = volumewidget_full
    volume_timer = gears.timer{
        timeout = 60, -- Run once per minute
        call_now = true,
        autostart = true,
        callback = function ()
            --check volume and set volume text
            awful.spawn.easy_async_with_shell("pamixer --get-volume-human",
                function(stdout)
                    local out = string.match(stdout, "^(%d+)")
                    if out then -- "because stdout can be 'muted', in which case 'out' = nil"
                        volumewidget:get_children_by_id("thetext")[1]:set_markup("<b>"..out.."%</b>")
                    else
                        volumewidget:get_children_by_id("thetext")[1]:set_markup("<b>0%</b>")
                    end
            end)
            -- check mute status and set icon
            awful.spawn.easy_async_with_shell("pamixer --get-mute",
                function(stdout)
                    if stdout == "true\n" then --audio is muted, so set mute icon
                        volumewidget:get_children_by_id("theimage")[1]:set_image(mute_icon)
                    else
                        volumewidget:get_children_by_id("theimage")[1]:set_image(sound_icon)
                    end
            end)
        end
    }
    awesome.connect_signal("signaling::volume", function (vol)
        if vol then
            volumewidget:get_children_by_id("thetext")[1]:set_markup("<b>"..vol.."%</b>")
        end
    end)
end

--[[ used in both icon widget and full widget ]]
awesome.connect_signal("signaling::mute", function(mute_status)
    if mute_status == "muted" then
        volumewidget:get_children_by_id("theimage")[1]:set_image(mute_icon)
    elseif mute_status == "unmuted" then
        volumewidget:get_children_by_id("theimage")[1]:set_image(sound_icon)
    end
end)

volumewidget:buttons(
    gears.table.join(
        awful.button({}, 1, function() --left mouse
            signaling.volume.toggle_mute()
            -- toggle_mute()
        end),
        awful.button({}, 4, function() --up scroll
            signaling.volume.change_volume("up")
            -- volume_up()
        end),
        awful.button({}, 5, function() --down scroll
            signaling.volume.change_volume("down")
            -- volume_down()
        end)
    )
)

-- Changes the background color on mouse enter
volumewidget:connect_signal("mouse::enter", function()
    volumewidget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
    volumewidget:get_children_by_id("thebackground")[1]:set_fg(beautiful.fg_focus)
end)
volumewidget:connect_signal("mouse::leave", function()
    volumewidget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
    volumewidget:get_children_by_id("thebackground")[1]:set_fg(beautiful.fg_normal)
end)


return volumewidget
