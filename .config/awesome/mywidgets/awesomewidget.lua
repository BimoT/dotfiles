local awesome = awesome or {}
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
-- local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
-- local mytheme = require("bimotheme")
-- local notificate = require("extras.notificate")
local apps = require("extras.apps")
--[[ local click_to_hide = require("click_to_hide") ]]

local awesomewidget = wibox.widget {
    {
        {
            {
                id = "img",
                image = beautiful.awesome_icon,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "bckgrnd",
        shape = function(cr, width, height)
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

local function create_icon_widget()
    wibox.widget {
        {
            {
                {
                    id = "img",
                    image = beautiful.awesome_icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                id = "mrgnin",
                margins = beautiful.widget_margin_inner,
                widget = wibox.container.margin,
            },
            id = "bckgrnd",
            shape = function(cr, width, height)
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
end

local menu_items = {
    --[[ { name = "Hotkeys", command = function() hotkeys_popup.show_help(nil, awful.screen.focused()) end }, ]]
    { name = "Hotkeys", command = apps.hotkeys_popup },
    --[[ { name = "Manual", command = function() awful.spawn(terminal .. " -e man awesome") end}, ]]
    { name = "Manual", command = apps.awesome_manpages },
    --[[ { name = "Edit config", command = function() awful.spawn(apps.terminal .. " -e " .. "nvim" ..  " " .. awesome.conffile) end }, ]]
    { name = "Edit config", command = apps.edit_config },
    { name = "Restart", command = awesome.restart },
    --[[ { name = "Quit", command = function() awesome.quit() end }, ]]
    { name = "Quit", command = apps.quit_awesome },
}

local popup = awful.popup {
    ontop = true,
    visible = false, -- should be hidden when created
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
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
--             {
--                 {
--                     image = ICON_DIR .. item.icon_name,
--                     forced_width = 22,
--                     forced_height = 22,
--                     widget = wibox.widget.imagebox
--                 },
                {
                    text = item.name,
                    widget = wibox.widget.textbox,
                    forced_width = dpi(150),
                    forced_height = dpi(30),
                    font = beautiful.font_base.." 13",
                },
--                 spacing = 12,
--                 layout = wibox.layout.fixed.horizontal,
--             },
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
                item.command()
            end)
        )
    )

    table.insert(rows, row)
end

-- add rows to the popup
popup:setup(rows)
--[[ click_to_hide(popup) ]]
-- Toggle popup visibility on mouse click:
awesomewidget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            if popup.visible then
                awesomewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal) 
                popup.visible = not popup.visible
            else
                awesomewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus) 
                popup:move_next_to(mouse.current_widget_geometry)
            end
    end))
)
-- Changes the background color on mouse enter
awesomewidget:connect_signal("mouse::enter", function()
    awesomewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus) 
end)
awesomewidget:connect_signal("mouse::leave", function()
    awesomewidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal) 
end)
return awesomewidget
