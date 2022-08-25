local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local click_to_hide = require("click_to_hide")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/Pictures/Icons/'

-- local poweroff_widget = wibox.widget {
--     {
--        image = ICON_DIR .. "poweroff.png",
--        resize = true,
--        widget = wibox.widget.imagebox,
--     },
--     margins = 4,
--     widget = wibox.container.margin
-- }
local poweroff_widget = wibox.widget {
    {
        {
            {
                id = "img",
                image = ICON_DIR .. "poweroff.png",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "bckgrnd",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.rouding_param)
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

-- Setup menu items
local menu_items = {
    { name = "Shutdown", icon_name = "poweroff.png", command = "sudo poweroff" },
    { name = "Reboot", icon_name = "reboot_icon.png", command = "sudo reboot" },
    { name = "Lock screen", icon_name = "lock_icon.png", command = "i3lock -c 901f1f --pointer=default"}
}

-- Define a popup and rows to hold vertical layout, items will be added later
local popup = awful.popup {
    ontop = true,
    visible = false, -- should be hidden when created
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.rouding_param)
    end,
    border_width = beautiful.border_width,
    border_color = beautiful.border_focus,
    maximum_width = dpi(150),
    offset = { y = 5 },
    widget = {}
}

-- Set the layout to vertical
local rows = { layout = wibox.layout.fixed.vertical }

-- Loops over the menu items, create a row, add row to the popup
for _, item in ipairs(menu_items) do
    local row = wibox.widget {
        {
            {
                {
                    image = ICON_DIR .. item.icon_name,
                    forced_width = 22,
                    forced_height = 22,
                    widget = wibox.widget.imagebox
                },
                {
                    text = item.name,
                    widget = wibox.widget.textbox,
                    forced_width = dpi(150),
                    forced_height = dpi(30),
                    font = beautiful.font_base.." 13"
                },
                spacing = 12,
                layout = wibox.layout.fixed.horizontal,
            },
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    -- Changes the color of the row if the mouse hovers over it
    row:connect_signal("mouse::enter", function(c)
        c:set_bg(beautiful.bg_focus)
    end)
    row:connect_signal("mouse::leave", function(c)
        c:set_bg(beautiful.bg_normal)
    end)

    -- Changes the cursor to a little hand instead of the regular cursor
    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    row:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    -- Mouse click handler
    -- This handles the command that gets executed!
    row:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                popup.visible = not popup.visible
                awful.spawn.with_shell(item.command)
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
-- If you click outside of the popup, then it closes the popup
click_to_hide(popup)
-- Toggle popup visibility on mouse click:
poweroff_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            menutoggle(popup)
            -- if popup.visible then
            --     popup.visible = not popup.visible
            -- else
            --     popup:move_next_to(mouse.current_widget_geometry)
            -- end
    end))
)
-- Changes the background color on mouse enter
poweroff_widget:connect_signal("mouse::enter", function()
    poweroff_widget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus)
end)
poweroff_widget:connect_signal("mouse::leave", function()
    poweroff_widget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal)
end)

return poweroff_widget


-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
