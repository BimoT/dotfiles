-- Create widget for displaying brightness
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
local signaling = require("signaling")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/Pictures/Icons/'

local white_icon = ICON_DIR .. "bright_white.png"
local red_icon = ICON_DIR .. "bright_red.png"

local brightnesswidget = wibox.widget {
    {
        {
            {
                {
                    id = "img",
                    image = white_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                {
                    id = "txt",
                    forced_width = dpi(50),
                    align = "right",
                    --font = "Ubuntu Nerd Font Complete 12",
                    widget = wibox.widget.textbox,
                },
                id = "lyout",
                spacing = beautiful.widget_margin_outer,
                layout = wibox.layout.fixed.horizontal,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "bckgrnd",
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    id = "mrgnout",
    left = beautiful.widger_margin_outer,
    right = beautiful.widger_margin_outer,
    widget = wibox.container.margin,
}

local redshift_cmd = '[[ -n "$(ps cax | grep redshift)" ]] && echo "active" || echo "inactive"'

local function change_redshift ()
    -- gets the state of redshift (either active or inactive), then either
    -- kills redshift or starts it
    awful.spawn.easy_async_with_shell(redshift_cmd,
        function(stdout)
        -- first change the icon, then toggle redshift on/off
            if stdout == "active\n" then
                brightnesswidget:get_children_by_id("img")[1]:set_image(white_icon)
                awful.spawn.with_shell("killall redshift")
            elseif stdout == "inactive\n" then
                brightnesswidget:get_children_by_id("img")[1]:set_image(red_icon)
                awful.spawn.with_shell("redshift")
            else -- some error happened
                naughty.notify({
                    title = "ERROR in redshift",
                    text = "Unexpected output: "..stdout.." from 'change_redshift' function",
                    bg = beautiful.bg_urgent,
                    fg = beautiful.black,
                    timeout = 0
                })
            end
    end)
end

-- Create a timer to check the status of redshift and brightness, and change the icon 
-- The callback also runs when the widget is created, so immediately the correct
-- volume and redshift state is put in the widget.
local widget_timer = gears.timer{
    timeout = 60, -- Run once per minute
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(redshift_cmd,
            function(stdout)
                if stdout == "active\n" then
                    brightnesswidget:get_children_by_id("img")[1]:set_image(red_icon)
                elseif stdout == "inactive\n" then
                    brightnesswidget:get_children_by_id("img")[1]:set_image(white_icon)
                else
                    naughty.notify({title="ERROR", text = "Redshift connect signal error: "..stdout.." is giving an error."})
                end
            end)
        awful.spawn.easy_async_with_shell("sudo brillo -G",
            function(stdout)
                local val = string.match(stdout, "^(%d+)")
                brightnesswidget:get_children_by_id("txt")[1]:set_markup("<b>"..val.."% </b>")
            end)
        end
}

-- The signal that watches for a change in volume and updates the widget
awesome.connect_signal("signaling::brightness", function(brightness_new)
    if brightness_new then
        brightnesswidget:get_children_by_id("txt")[1]:set_markup("<b>"..brightness_new.."% </b>")
    end
end)
--[=[
local function brightness_up ()
    awful.spawn.easy_async_with_shell("sudo brillo -A 5 -q; brillo -G", function(stdout)
        local val = string.match(stdout, "^(%d+)")
        notificate.brightness(val)
        brightnesswidget:get_children_by_id("txt")[1]:set_markup("<b>"..val.."% </b>")
    end)
end

local function brightness_down ()
    awful.spawn.easy_async_with_shell("sudo brillo -U 5 -q; brillo -G", function(stdout)
        local val = string.match(stdout, "^(%d+)")
        notificate.brightness(val)
        brightnesswidget:get_children_by_id("txt")[1]:set_markup("<b>"..val.."% </b>")
    end)
end
--]=]


brightnesswidget:buttons(
    gears.table.join(
        awful.button({}, 1, function() --[[ left mouse ]]
            change_redshift()
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

-- Changes the background color on mouse enter
brightnesswidget:connect_signal("mouse::enter", function()
    brightnesswidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus)
end)
brightnesswidget:connect_signal("mouse::leave", function()
    brightnesswidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal)
end)

return brightnesswidget
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent
