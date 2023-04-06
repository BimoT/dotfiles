local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("extras.helpers")
local dpi = beautiful.xresources.apply_dpi

--[[ Wrapper widget around a textclock. Clicking it gives a 1-month calendar. ]]

local mytextclock = wibox.widget({
        {
            {
                {
                    id     = "theclock",
                    widget = wibox.widget.textclock("%H:%M"),
                },
            id      = "theinnermargin",
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id                 = "thebackground",
        bg                 = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
        shape              = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        },
    id     = "theoutermargin",
    left   = beautiful.widget_margin_outer,
    right  = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
})

local cal_popup = awful.popup({
        ontop         = true,
        visible       = false,
        shape         = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        border_width  = beautiful.widget_border_width,
        border_color  = beautiful.border_focus,
        maximum_width = dpi(250),
        offset        = { y = 5, x = 5 },
        widget        = {
            {
                wibox.widget.calendar.month(os.date("*t"), beautiful.font_base .. " 10"),
                layout = wibox.layout.fixed.horizontal
            },
            margins = 4,
            widget  = wibox.container.margin,
        }
})

-- closes the popup when you click it
helpers.close_popup_click(cal_popup)

mytextclock:connect_signal("button::press", function ()
    if cal_popup.visible then
        cal_popup.visible = not cal_popup.visible
    else
        cal_popup:move_next_to(mouse.current_widget_geometry)
    end
end)

-- Changes the background color on mouse enter
helpers.hover_bg(mytextclock, {
    background_id = "thebackground",
    color_after_entering = beautiful.bg_focus,
    color_after_leaving = beautiful.bg_normal
})
helpers.hover_fg(mytextclock, {
    background_id = "thebackground",
    color_after_entering = beautiful.fg_focus,
    color_after_leaving = beautiful.fg_normal
})
return mytextclock
