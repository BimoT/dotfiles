local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local mouse = mouse


local M = {}

function M.close_popup_click(widgt)
    widgt:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                widgt.visible = not widgt.visible
            end )
        )
    )
end

function M.mouseinside(widget)
    --[[ Returns true if mouse is inside widget, else false ]]
    local geo = widget:geometry()
    local x1 = geo["x"]
    local x2 = geo["width"] + geo["x"]
    local y1 = geo["y"]
    local y2 = geo["height"] + geo["y"]
    local pos = mouse.coords()
    local posx = pos["x"]
    local posy = pos["y"]
    if posx > x1 and posx < x2 and posy > y1 and posy < y2 then
        return true
    else
        return false
    end
end

function M.pango_escape(s)
    --[[ Escapes a string so that it can be displayed inside pango markup tags ]]
    return (string.gsub(s, "[&<>]", {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;"
    }))
end

local double_tap_timer = nil
function M.single_double_tap(single_tap_function, double_tap_function)
    if double_tap_timer then
        double_tap_timer:stop()
        double_tap_timer = nil
        double_tap_function()
        -- naughty.notify({text = "we got a double tap" })
        return
    end
    double_tap_timer = gears.timer.start_new(0.20, function ()
        double_tap_timer = nil
        -- naughty.notify({text = "we got a single tap" })
        if single_tap_function then
            single_tap_function()
        end
        return false
    end)
end

function M.vertical_pad(height)
    --[[ Adds an empty widget for some extra padding space ]]
    return wibox.widget({
        forced_height = height,
        layout = wibox.layout.fixed.vertical,
    })
end

function M.horizontal_pad(width)
    --[[ Adds an empty widget for some extra padding space ]]
    return wibox.widget({
        forced_width = width,
        layout = wibox.layout.fixed.horizontal,
    })
end

function M.hover_cursor(widget)
    --[[ Changes the cursor when hovering over a widget ]]
    local old_cursor, old_wibox
    widget:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    widget:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
end

function M.hover_bg(widget, color_after_entering, color_after_leaving)
    --[[ Changes the background color of the widget when hovering over a widget ]]
    widget:connect_signal("mouse::enter", function(c)
        c:set_bg(color_after_entering)
    end)
    widget:connect_signal("mouse::leave", function(c)
        c:set_bg(color_after_leaving)
    end)
    end

--TODO: needs extra work!
function M.construct_popup_widget(menu_items, layout_table, row_widget, function_on_click, popup_widget)
    --[[ Basic constructor for a popup widget.
         menu_items should be a nested table with the items that should appear in your popup widget, one table representing one row.
         layout_table should be something like { layout = wibox.layout.fixed.vertical } for a vertical dropdown menu.
         row_widget should be the widget that will represent each row. This can have icons, text, whatever you want for your row.
         function_on_click gets called whenever you click on the row.
         popup_widget is the big popup that gets populated with the rows.
         returns: layout_table
    --]]

    local layout_table = layout_table
    if type(menu_items) ~= "table" or type(layout_table) ~= "table" then
        return false
    else
        for _, item in ipairs(menu_items) do
            local row = row_widget
            M.hover_bg(row, beautiful.bg_focus, beautiful.bg_normal)
            M.hover_cursor(row)
            row:buttons(
                gears.table.join(
                    awful.button({}, 1, function ()
                        popup_widget.visible = not popup_widget.visible
                        function_on_click()
                    end)
                )
            )
            table.insert(layout_table, row)
        end
        return layout_table
    end

end
function M.set_wallpaper(s)
    --[[ Sets the wallpaper ]]
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

function M.resize_dwim(c, direction)
    -- From Elenapan's dotfiles
    -- resizes the client or increments with a factor
    local floating_resize_amount = dpi(20)
    local tiling_resize_factor = 0.05

    if c and c.floating then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    elseif awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
        if direction == "up" then
            awful.client.incmwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incmwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end

function M.tag_back_and_forth(tag_index)
    --[[ If you try to focus the tag that you're already at, then go back to the previous tag. ]]
    local s = mouse.screen
    local tag = s.tags[tag_index]
    if tag then
        if tag == s.selected_tag then
            awful.tag.history.restore()
        else
            tag:view_only()
        end
    end
end

function M.move_to_edge(c, direction)
    local direction_translate = {
        ["up"] = "top",
        ["down"] = "bottom",
        ["left"] = "left",
        ["right"] = "right",
    }
    local old = c:geometry()
    local new = awful.placement[direction_translate[direction]](c, {
        honor_padding = true,
        honor_workarea = true,
        margins = beautiful.useless_gap * 2,
        pretend = true,
    })
    if direction == "up" or direction == "down" then
        c:geometry({ x = old.x, y = new.y })
    else
        c:geometry({ x = new.x, y = old.y })
    end
end

function M.move_client_dwim(c, direction)
    if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
        M.move_to_edge(c, direction)
    elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
        if direction == "up" or direction == "left" then
            awful.client.swap.byidx(-1, c)
        elseif direction == "down" or direction == "right" then
            awful.cient.swap.byidx(1, c)
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end

function M.float_and_edge_snap(c, direction)
    --[[ Make client floating and snap to the desired edge ]]
    local axis_translate = {
        ["up"] = "horizontally",
        ["down"] = "horizontally",
        ["left"] = "vertically",
        ["right"] = "vertically",
    }
    local direction_translate = {
        ["up"] = "top",
        ["down"] = "bottom",
        ["left"] = "left",
        ["right"] = "right",
    }
    c.maximized = false
    c.maximized_vertical = false
    c.maximized_horizontal = false
    c.floating = true
    local f = awful.placement.scale
        + awful.placement[direction_translate[direction]]
        + awful.placement["maximize_"..axis_translate[direction]]
    f(c, {
        honor_padding = true,
        honor_workarea = true,
        to_percent = 0.5,
        margins = beautiful.useless_gap * 2,
    })
end

function M.round(number, decimals)
    --[[ Rounds a number to any number of decimals ]]
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end

return M
-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent

