local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
-- local helpers = require("extras.helpers")
local beautiful = require("beautiful")
local mywidgets = require("mywidgets")
local keybindings = require("keybindings")
local helpers = require("extras.helpers")

--      _                       _             
--     | |                     | |            
--   __| | __ _ _   _ _ __ __ _| |_ _   _ ___ 
--  / _` |/ _` | | | | '__/ _` | __| | | / __|
-- | (_| | (_| | |_| | | | (_| | |_| |_| \__ \
--  \__,_|\__,_|\__,_|_|  \__,_|\__|\__,_|___/
--                                            

local capi = {screen = screen,
              client = client
} -- HACK: to detect focusing of screens, some capi stuff needs to be done

local function callback(s, c, index, objects)
    --[[
        s: the tasklist widget
        c: the client that responds to the widget
        index: the widget position in the list
        objects: the ordered list of clients

        This gets called by `update_callback` and `create_callback` in the tasklist widget
    ]]
    local bg  = s:get_children_by_id("mybackground_role")[1]
    -- local txt = s:get_children_by_id("mytext_role")[1]

    -- INFO: The next part is some trickery to detect if client is focused
    local focused = capi.client.focus == c
    if not focused and capi.client.focus and capi.client.focus.skip_taskbar and capi.client.focus:get_transient_for_watching(function (cl)
        return not cl.skip_taskbar
    end) == c then
        focused = true
    end

    -- local class = helpers.class_width_constrained(c, 4)
    if focused then
        -- txt:set_markup_silently(helpers.bold_text(class))
        bg:set_bg(beautiful.tasklist_bg_focus)
        -- bg:set_shape_border_color(beautiful.tasklist_border_focus)
        -- bg:set_fg(beautiful.tasklist_fg_focus)
    else
        -- txt:set_markup_silently(class)
        bg:set_bg(beautiful.tasklist_bg_normal)
        -- bg:set_fg(beautiful.tasklist_fg_normal)
    end
end

local task_template = {
    margins         = beautiful.widget_margin_outer,
    widget          = wibox.container.margin,
    create_callback = function (self, c, index, objects)
        callback(self, c, index, objects)
    end,
    update_callback = function (self, c, index, objects)
        callback(self, c, index, objects)
    end,
    {
        id                 = "mybackground_role",
        bg                 = beautiful.bg_normal,
        fg                 = beautiful.fg_normal,
        shape_border_width = 2,
        shape_border_color = beautiful.border_focus,
        widget             = wibox.container.background,
        shape              = function (cr, width, height)
            helpers.trapezoid(cr, width, height, 60, 60)
        end,
        {
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            {
            id = "text_margin_role",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
                {
                    id = "icon_margin_role",
                    margins = beautiful.widget_margin_inner,
                    widget = wibox.container.margin,
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                        forced_width = 60,
                    },
                },
            },
        },
    },
}


awful.screen.connect_for_each_screen(function (s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keybindings.taglist_buttons,
        style = {
            shape = function (cr, width, height)
                gears.shape.rectangle(cr, width, height)
            end,
            squares_resize = true,
            spacing        = 5,
        }, -- TODO: add layout
    })

    s.mytasklist = awful.widget.tasklist({
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = keybindings.tasklist_buttons,
        widget_template = task_template,
        layout = {
            spacing = 3,
            layout  = wibox.layout.fixed.horizontal,
        },
    })
    s.mywibox = awful.wibar({
        position     = beautiful.wibar_position,
        screen       = s,
        height       = beautiful.wibar_height,
        border_width = beautiful.widget_margin_inner,
        border_color = beautiful.fg_focus,
        visible      = true
    })
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            mywidgets.startwidget,
            s.mytaglist,
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            mywidgets.screenshotwidget,
            mywidgets.diskwidget,
            mywidgets.brightnesswidget,
            mywidgets.volumewidget,
            mywidgets.keyboardwidget,
            wibox.widget.systray(),
            mywidgets.clockwidget,
            s.mylayoutbox,
        },
    })

end)

