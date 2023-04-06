local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
local signaling = require("signaling")

--[[
    Create widget for displaying brightnes.
    Depending on `want_icon_widgets` in the theme file, this will return either an icon widget, or an icon + text widget
--]]

local white_icon   = beautiful.brightness_icon
local red_icon     = beautiful.brightness_icon_red
local redshift_cmd = '[[ -n "$(ps cax | grep redshift)" ]] && echo "active" || echo "inactive"'

local brightnesswidget_full = wibox.widget {
    {
        {
            {
                {
                    id     = "theimage",
                    image  = white_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                {
                    id           = "thetext",
                    forced_width = dpi(50),
                    align        = "right",
                    widget       = wibox.widget.textbox,
                },
                id      = "thelayout",
                spacing = beautiful.widget_margin_outer,
                layout  = wibox.layout.fixed.horizontal,
            },
            id      = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id                 = "thebackground",
        shape              = function (cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        fg                 = beautiful.fg_normal,
        bg                 = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
    },
    id     = "mrgnout",
    left   = beautiful.widget_margin_outer,
    right  = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}


local brightnesswidget_icon = wibox.widget {
    id     = "thebackground",
    bg     = beautiful.bg_normal,
    widget = wibox.container.background,
    {
        id     = "theimage",
        image  = white_icon,
        resize = true,
        widget = wibox.widget.imagebox,
    }
}

local function change_redshift (widget)
    -- gets the state of redshift (either active or inactive), then either
    -- kills redshift or starts it
    awful.spawn.easy_async_with_shell(redshift_cmd,
        function(stdout)
        -- first change the icon, then toggle redshift on/off
            if stdout == "active\n" then
                widget:get_children_by_id("theimage")[1]:set_image(white_icon)
                awful.spawn.with_shell("killall redshift")
            elseif stdout == "inactive\n" then
                widget:get_children_by_id("theimage")[1]:set_image(red_icon)
                awful.spawn.with_shell("redshift")
            else -- some error happened
                naughty.notify({
                    title   = "ERROR in redshift",
                    text    = "Unexpected output: "..stdout.." from 'change_redshift' function",
                    bg      = beautiful.bg_urgent,
                    fg      = beautiful.black,
                    timeout = 0
                })
            end
    end)
end

local brightnesswidget, widget_timer

if beautiful.want_icon_widgets then
    brightnesswidget = brightnesswidget_icon
else
    brightnesswidget = brightnesswidget_full
    -- Create a timer to check the status of redshift and brightness, and change the icon 
    -- The callback also runs when the widget is created, so immediately the correct
    -- volume and redshift state is put in the widget.
    widget_timer = gears.timer{
        timeout = 60, -- Run once per minute
        call_now = true,
        autostart = true,
        callback = function ()
            awful.spawn.easy_async_with_shell(redshift_cmd,
                function(stdout)
                    if stdout == "active\n" then
                        brightnesswidget:get_children_by_id("theimage")[1]:set_image(red_icon)
                    elseif stdout == "inactive\n" then
                        brightnesswidget:get_children_by_id("theimage")[1]:set_image(white_icon)
                    else
                        naughty.notify({title="ERROR", text = "Redshift connect signal error: "..stdout.." is giving an error."})
                    end
                end)
            awful.spawn.easy_async_with_shell("sudo brillo -G",
                function(stdout)
                    local val = string.match(stdout, "^(%d+)")
                    brightnesswidget:get_children_by_id("thetext")[1]:set_markup("<b>"..val.."% </b>")
                end)
            end
    }

    -- The signal that watches for a change in volume and updates the widget
    awesome.connect_signal("signaling::brightness", function(brightness_new)
        if brightness_new then
            brightnesswidget:get_children_by_id("thetext")[1]:set_markup("<b>"..brightness_new.."% </b>")
        end
    end)
end

brightnesswidget:buttons(
    gears.table.join(
        awful.button({}, 1, function() --[[ left mouse ]]
            change_redshift(brightnesswidget)
        end),
        awful.button({}, 4, function() --[[ up scroll ]]
            signaling.brightness.change_brightness("up")
            -- brightness_up()
        end),
        awful.button({}, 5, function() --[[ down scroll ]]
            signaling.brightness.change_brightness("down")
            -- brightness_down()
        end)
    )
)

-- Changes the background color and text color on mouse enter
brightnesswidget:connect_signal("mouse::enter", function()
    brightnesswidget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
    brightnesswidget:get_children_by_id("thebackground")[1]:set_fg(beautiful.fg_focus)
end)
brightnesswidget:connect_signal("mouse::leave", function()
    brightnesswidget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
    brightnesswidget:get_children_by_id("thebackground")[1]:set_fg(beautiful.fg_normal)
end)

return brightnesswidget
