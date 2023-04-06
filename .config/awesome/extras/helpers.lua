---Helper functions
---Many of these functions are from Elenapan's dotfiles
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
---@diagnostic disable-next-line
local mouse = mouse


local M = {}


---Sets widget visibility to 0 when left mouse button is pressed
---@param w any the widget that you add the signal to
function M.close_popup_click(w)
    w:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                w.visible = not w.visible
            end )
        )
    )
end


---Gets the class name from a client.
---If it is "alacrittyfloat" then it returns "Alacritty"
---@param c any the client
---@return string
function M.getclass(c)
    local class = c.class
    if class == "alacrittyfloat" then -- Needed to fix issue with spawning floating terminals
        class = "Alacritty"
    end
    return class
end

---Replace some underscores with spaces, and makes the first letter uppercase
---@param c any client
---@return string
function M.getcleanclass(c)
    local class = M.getclass(c)
    local out
    if type(class) == "string" then
        out =  string.gsub(class, "_", " ")
        out = out:gsub("^%l", string.upper)
        return out
    else
        return ""
    end
end

---Used for in taskwidget
---gets only the first couple of letters from the classname
---@param c any client
---@param length integer the length of the substring
---@return string
function M.class_width_constrained(c, length)
    local class = M.getcleanclass(c)
    class = M.pango_escape(class)
    local capped_length = math.max(0, length)
    if class:len() > capped_length then -- TODO: check if this actually implements the correct formatting
        return class:sub(1, capped_length)
    else
        return class
    end
end

---Adds `<span foreground='[COLOR]'>` tags around the text
---@param text string The text that you want to display as colored
---@param color string the color of the text
---@return string
function M.colored_text(text, color)
    return "<span foreground='"..color.."'>"..text.."</span>"
end

---Adds `<b>` tags around text
---@param text string the text that you want to present as bold
---@return string
function M.bold_text(text)
    return "<b>"..text.."</b>"
end

---Returns `true` if the mouse is inside the widget, else `false`
---@param widget any the widget
---@return boolean
function M.mouseinside(widget)
    --[[ Returns true if mouse is inside widget, else false ]]
    local geo  = widget:geometry()
    local x1   = geo["x"]
    local x2   = geo["width"] + geo["x"]
    local y1   = geo["y"]
    local y2   = geo["height"] + geo["y"]
    local pos  = mouse.coords()
    local posx = pos["x"]
    local posy = pos["y"]
    if posx > x1 and posx < x2 and posy > y1 and posy < y2 then
        return true
    else
        return false
    end
end


---Create a trapezoid.
---@param cr any A cairo context
---@param width number The shape width
---@param height number The shape height
---@param bottom_left_angle number The inner angle of the bottom left corner (between 0 and 90 degrees)
---@param bottom_right_angle number The inner angle of the bottom right corner (between 0 and 90 degrees)
function M.trapezoid(cr, width, height, bottom_left_angle, bottom_right_angle)
    local bla, bra = bottom_left_angle or 0, bottom_right_angle or 0
    local min, max = math.min, math.max
    bla = min(bla, 90)
    bla = max(bla, 0)

    bra = min(bra, 90)
    bra = max(bra, 0)
    -- Calculate the horizontal offsets for the trapezoid
    local r_offset = height / math.tan(math.rad(bra))
    local l_offset = height / math.tan(math.rad(bla))
    -- Makes sure that if the result would be an "hourglass shape", the offsets are set to 0 to form a rectangle
    if r_offset + l_offset > width then
        l_offset = 0
        r_offset = 0
    end

    -- (0,0) = upper left corner
    cr:move_to(0               , height)
    cr:line_to(width           , height)
    cr:line_to(width - r_offset, 0     )
    cr:line_to(l_offset        , 0     )
    cr:close_path()
end

---Formats a string so that it can be displayed inside Pango markup tags
---@param text string the text that you want to clean up for Pango markup
---@return string
function M.pango_escape(text)
    return (string.gsub(text, "[&<>]", {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;"
    }))
end

--TODO: delete? unused
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

---Adds an empty widget for extra vertical padding
---@param height number the height of the padding
---@return wibox.widget
function M.vertical_pad(height)
    --[[ Adds an empty widget for some extra padding space ]]
    return wibox.widget({
        forced_height = height,
        layout        = wibox.layout.fixed.vertical,
    })
end


---Adds an empty widget for extra horizontal padding
---@param width number the height of the padding
---@return wibox.widget
function M.horizontal_pad(width)
    --[[ Adds an empty widget for some extra padding space ]]
    return wibox.widget({
        forced_width = width,
        layout       = wibox.layout.fixed.horizontal,
    })
end

---Changes the cursor when hovering over a widget
---@param widget any The widget that you're hovering over
function M.hover_cursor(widget)
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


---Changes the background color of the widget when hovering over a widget
---@param widget table the widget that takes this signal
---@param args {background_id: string, color_after_entering: string, color_after_leaving: string} table with required arguments
function M.hover_bg(widget, args)
    args = args or {}
    assert(type(args.background_id) == "string", "`args.background_id` needs to be a string, and is required")
    assert(type(args.color_after_entering) == "string", "`args.color_after_entering` needs to be a string, and is required")
    assert(type(args.color_after_leaving) == "string", "`args.color_after_leaving` needs to be a string, and is required")

    widget:connect_signal("mouse::enter", function(c)
        c:get_children_by_id(args.background_id)[1]:set_bg(args.color_after_entering)
    end)
    widget:connect_signal("mouse::leave", function(c)
        c:get_children_by_id(args.background_id)[1]:set_bg(args.color_after_leaving)
    end)
end


---Changes the foreground color of the widget when hovering over a widget
---@param widget any the wibox.widget that takes this signal
---@param args {background_id: string, color_after_entering: string, color_after_leaving: string} table with required arguments
function M.hover_fg(widget, args )
    args = args or {}
    assert(type(args.background_id) == "string", "`args.background_id` needs to be a string, and is required")
    assert(type(args.color_after_entering) == "string", "`args.color_after_entering` needs to be a string, and is required")
    assert(type(args.color_after_leaving) == "string", "`args.color_after_leaving` needs to be a string, and is required")
    widget:connect_signal("mouse::enter", function(c)
        c:get_children_by_id(args.background_id)[1]:set_fg(args.color_after_entering)
    end)
    widget:connect_signal("mouse::leave", function(c)
        c:get_children_by_id(args.background_id)[1]:set_fg(args.color_after_leaving)
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

---Sets the wallpaper
---@param s any The screen for which you set the wallpaper
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

---Either spawns a new process, or raises it
--- 
--- If one is found, then either moves the process to the current tag, or jumps to the tag that has the process
---@param match table the rule to check
---@param move boolean true => move to tag, false => jump to tag
---@param spawn_cmd string the command that get passed into `awful.spawn()`
---@param spawn_args table the args that get passed into `awful.spawn()`
function M.run_or_raise(match, move, spawn_cmd, spawn_args)
    local matcher = function (c)
        return awful.rules.match(c, match)
    end
    -- find and raise
    local found = false
    for c in awful.client.iterate(matcher) do
        found = true
        c.minimized = false
        if move then
            c:move_to_tag(mouse.screen.selected_tag)
            client.focus = c
        else
            c:jump_to()
        end
        break
    end
    -- spawn if not found
    if not found then
        awful.spawn(spawn_cmd, spawn_args)
    end
end


---Resizes the client window, or increments with a factor
--- 
---If the window is floating, this will move the window
---If the window is not floating, then it will resize the stack
---@param c any the client window
---@param direction string
---|"up"
---|"down"
---|"left"
---|"right"
function M.resize_dwim(c, direction)
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


---Shifts the focus to a tag
---If you are already on the tag that you shift focus to, then this will shift focus to the last focused tag
---@param tag_index integer|string the tag index
function M.tag_back_and_forth(tag_index)
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


---Moves the client window to a desired edge
---@param c any the client window
---@param direction string
---|"up"
---|"down"
---|"left"
---|"right"
function M.move_to_edge(c, direction)
    local direction_translate = {
        ["up"]    = "top",
        ["down"]  = "bottom",
        ["left"]  = "left",
        ["right"] = "right",
    }
    local old = c:geometry()
    local new = awful.placement[direction_translate[direction]](c, {
        honor_padding  = true,
        honor_workarea = true,
        margins        = beautiful.useless_gap * 2,
        pretend        = true,
    })
    if direction == "up" or direction == "down" then
        c:geometry({ x = old.x, y = new.y })
    else
        c:geometry({ x = new.x, y = old.y })
    end
end

---Moves the client window
--- 
---If the window is floating, then moves it to the edge specified by the direction
---If the window isn't floating, then it swaps the window with the one specified by the direction
---@param c any the client window
---@param direction string
---|"up"
---|"down"
---|"left"
---|"right"
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

---Makes the client window floating and snap to the specified edge
---@param c any the client window
---@param direction string
---|"up"
---|"down"
---|"left"
---|"right"
function M.float_and_edge_snap(c, direction)
    --[[ Make client floating and snap to the desired edge ]]
    local axis_translate = {
        ["up"]    = "horizontally",
        ["down"]  = "horizontally",
        ["left"]  = "vertically",
        ["right"] = "vertically",
    }
    local direction_translate = {
        ["up"]    = "top",
        ["down"]  = "bottom",
        ["left"]  = "left",
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
        honor_padding  = true,
        honor_workarea = true,
        to_percent     = 0.5,
        margins        = beautiful.useless_gap * 2,
    })
end

---Rounds a number to a number of decimals
---@param num number
---@param decimals integer
---@return number
function M.round(num, decimals)
    local power = 10 ^ decimals
    return math.floor(num * power) / power
end


---Adds W-95/W-98 style borders to a widget
---@param w any the widget that you want borders around
---@param opts? {shape: gears.shape, margin: number, color_bg: string, color_bottomright: string, color_bottomrightouter: string, color_topleft: string, color_topleftouter: string}
---|"shape" # the gears.shape that you want for the borders (default: rectangle)
---|"margin" # the width of the W-95 borders
---|"color_bg" # main color
---|"color_bottomright" # dark grey bottom right border color
---|"color_bottomrightouter" # black bottom rigth outer border color
---|"color_topleft" # white upper left border color
---|"color_topleftouter" # grey upper left outer border color
---@return table
function M.addw95borders(w, opts)
    opts = opts or {}
    return {
        id                 = "bottomrightborderouter",
        shape              = opts.shape or gears.shape.rectangle,
        bg                 = opts.color_bottomrightouter or beautiful.fg_normal or "#000000",
        shape_border_width = 0,
        widget             = wibox.container.background,
        {
            id     = "mrgnout4",
            right  = opts.margin or beautiful.widget_margin_outer or dpi(2),
            bottom = opts.margin or beautiful.widget_margin_outer or dpi(2),
            widget = wibox.container.margin,
            {
                id                 = "topleftborderouter",
                shape              = opts.shape or gears.shape.rectangle,
                bg                 = opts.color_topleftouter or beautiful.lighter_grey or "#dfdfdf",
                shape_border_width = 0,
                widget             = wibox.container.background,
                {
                    id     = "mrgnout3",
                    left   = opts.margin or beautiful.widget_margin_outer or dpi(2),
                    top    = opts.margin or beautiful.widget_margin_outer or dpi(2),
                    widget = wibox.container.margin,
                    {
                        id                 = "bottomrightborder",
                        shape              = opts.shape or gears.shape.rectangle,
                        bg                 = opts.color_bottomright or beautiful.inactive_color or "#808080",
                        shape_border_width = 0,
                        widget             = wibox.container.background,
                        {
                            id     = "mrgnout2",
                            right  = opts.margin or beautiful.widget_margin_outer or dpi(2),
                            bottom = opts.margin or beautiful.widget_margin_outer or dpi(2),
                            widget = wibox.container.margin,
                            {
                                id                 = "topleftborder",
                                shape              = opts.shape or gears.shape.rectangle,
                                bg                 = opts.color_topleft or beautiful.fg_focus or "#ffffff",
                                shape_border_width = 0,
                                widget             = wibox.container.background,
                                {
                                    id     = "mrgnout1",
                                    left  = opts.margin or beautiful.widget_margin_outer or dpi(2),
                                    top = opts.margin or beautiful.widget_margin_outer or dpi(2),
                                    widget = wibox.container.margin,
                                    {
                                        w,
                                        id                 = "thebackground",
                                        shape              = opts.shape or gears.shape.rectangle,
                                        bg                 = opts.color_bg or beautiful.bg_normal or "#c0c0c0",
                                        shape_border_width = 0,
                                        widget             = wibox.container.background,
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    }
end

return M
