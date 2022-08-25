--[[ Create widget for displaying volume ]]
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local signaling = require("signaling")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/Pictures/Icons/'
local sound_icon = ICON_DIR.."sound_icon.png"
local mute_icon = ICON_DIR.."sound_icon_mute.png"


local volumewidget = wibox.widget {
    {
        {
            {
                {
                    --image = ICON_DIR .. "bright_white.png",
                    id = "img",
                    image = sound_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                {
                    id = "txt",
                    forced_width = dpi(50),
                    align = "right",
                    --markup = "100%",
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
        shape = function (cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    id = "mrgnout",
    left = beautiful.widget_margin_outer,
    right = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

local volume_timer = gears.timer{
    timeout = 60, -- Run once per minute
    call_now = true,
    autostart = true,
    callback = function ()
        --check volume and set volume text
        awful.spawn.easy_async_with_shell("pamixer --get-volume-human",
            function(stdout)
                volumewidget:get_children_by_id("txt")[1]:set_markup("<b>"..stdout.." </b>")
        end)
        -- check mute status and set icon
        awful.spawn.easy_async_with_shell("pamixer --get-mute",
            function(stdout)
                if stdout == "true\n" then --audio is muted, so set mute icon
                    volumewidget:get_children_by_id("img")[1]:set_image(mute_icon)
                else
                    volumewidget:get_children_by_id("img")[1]:set_image(sound_icon)
                end
        end)

    end
}
--[=[
local function toggle_mute()
    -- first it toggles the mute, then it gets the mute status, then it notifies and changes the widget icon
    awful.spawn.easy_async_with_shell("pamixer -t; pamixer --get-mute",
        function(stdout)
            if stdout == "true\n" then --audio is muted, so set mute icon
                notificate.mute("muted")
                volumewidget:get_children_by_id("img")[1]:set_image(mute_icon)
            else
                notificate.mute("unmuted")
                volumewidget:get_children_by_id("img")[1]:set_image(sound_icon)
            end
    end)
end

local function volume_up ()
    -- if volume < 10, then increase only by 2, else by 5
    awful.spawn.easy_async_with_shell('pamixer -u; [[ $(pamixer --get-volume) -lt 10 ]] && pamixer -i 2 || pamixer -i 5; pamixer --get-volume-human',
        function(stdout)
            volumewidget:get_children_by_id("txt")[1]:set_markup("<b>"..stdout.." </b>")
            notificate.volume(string.match(stdout, "^(%d+)"))
    end)
end

local function volume_down ()
    -- if volume <= 10, then decrease only by 2, else by 5
    awful.spawn.easy_async_with_shell('pamixer -u; [[ $(pamixer --get-volume) -le 10 ]] && pamixer -d 2 || pamixer -d 5; pamixer --get-volume-human',
        function(stdout)
            volumewidget:get_children_by_id("txt")[1]:set_markup("<b>"..stdout.." </b>")
            notificate.volume(string.match(stdout, "^(%d+)"))
    end)
end
--]=]

awesome.connect_signal("signaling::volume", function (vol)
    if vol then
        volumewidget:get_children_by_id("txt")[1]:set_markup("<b>"..vol.."% </b>")
    end
end)

awesome.connect_signal("signaling::mute", function(mute_status)
    if mute_status == "muted" then
        volumewidget:get_children_by_id("img")[1]:set_image(mute_icon)
    elseif mute_status == "unmuted" then
        volumewidget:get_children_by_id("img")[1]:set_image(sound_icon)
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
    volumewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus)
end)
volumewidget:connect_signal("mouse::leave", function()
    volumewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal)
end)


return volumewidget
