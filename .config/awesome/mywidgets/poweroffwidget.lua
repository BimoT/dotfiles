local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local apps = require("extras.apps")
local helpers = require("extras.helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local poweroff_widget = wibox.widget {
    {
        {
            {
                id     = "theimage",
                image  = beautiful.poweroff_icon,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id                 = "thebackground",
        shape              = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rouding_param)
        end,
        bg                 = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
    },
    left   = beautiful.widget_margin_outer,
    right  = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

-- Setup menu items
local menu_items = {
    { name = "Shutdown"   , icon_name = beautiful.poweroff_icon, command = apps.poweroff },
    { name = "Reboot"     , icon_name = beautiful.reboot_icon  , command = apps.reboot }  ,
    { name = "Lock screen", icon_name = beautiful.lock_icon    , command = apps.lockscreen }
}

-- Define a popup and rows to hold vertical layout, items will be added later
local popup = awful.popup {
    ontop         = true,
    visible       = false,
    shape         = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.rouding_param)
    end,
    border_width  = beautiful.border_width,
    border_color  = beautiful.border_focus,
    maximum_width = dpi(150),
    offset        = { y = 5 },
    widget        = {},
}

-- Set the layout to vertical
local rows = { layout = wibox.layout.fixed.vertical }

-- Loops over the menu items, create a row, add row to the popup
for _, item in ipairs(menu_items) do
    local row = wibox.widget {
        {
            {
                {
                    image         = item.icon_name,
                    forced_width  = 22,
                    forced_height = 22,
                    widget        = wibox.widget.imagebox
                },
                {
                    text          = item.name,
                    widget        = wibox.widget.textbox,
                    forced_width  = dpi(150),
                    forced_height = dpi(30),
                    font          = beautiful.font_base.." 13"
                },
                spacing = 12,
                layout  = wibox.layout.fixed.horizontal,
            },
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin
        },
        id     = "thebackground",
        bg     = beautiful.bg_normal,
        widget = wibox.container.background
    }


    helpers.hover_bg(row, {background_id = "thebackground", color_after_entering = beautiful.bg_focus, color_after_leaving = beautiful.bg_normal})
    helpers.hover_cursor(row)

    -- Mouse click handler
    -- This handles the command that gets executed!
    row:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                popup.visible = not popup.visible
                --[[ awful.spawn.with_shell(item.command) ]]
                item.command()
            end)
        )
    )

    table.insert(rows, row)
end

-- add rows to the popup
popup:setup(rows)

local function menuhide(widget)
    widget.visible = false
end
local function menushow(widget)
     widget:move_next_to(mouse.current_widget_geometry)
end
local function menutoggle(widget)
    if widget.visible then
        menuhide(widget)
    else
        menushow(widget)
    end
end

-- Toggle popup visibility on mouse click:
poweroff_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            menutoggle(popup)
    end))
)
-- Changes the background color on mouse enter
poweroff_widget:connect_signal("mouse::enter", function()
    poweroff_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
end)
poweroff_widget:connect_signal("mouse::leave", function()
    poweroff_widget:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
end)

return poweroff_widget
