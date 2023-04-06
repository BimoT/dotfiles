-- Wibar module for awesome95
--                                               ___  _____
--                                              / _ \| ____|
--   __ ___      _____  ___  ___  _ __ ___   __| (_) | |__
--  / _` \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \__, |___ \
-- | (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/ / / ___) |
--  \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|/_/ |____/
-- 
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local mywidgets = require("mywidgets")
local keybindings = require("keybindings")
local helpers = require("extras.helpers")

---@diagnostic disable-next-line
local capi = {screen = screen, client = client
} -- HACK: to detect focusing of screens, some capi stuff needs to be done

-- This gets called by `update_callback` and `create_callback` in the tasklist widget
---@param s any The tasklist widget
---@param c any the client that responds to the widget
---@param index nil unused, but needed by parent function
---@param objects nil unused, but needed by parent function
---@diagnostic disable-next-line: unused-local
local function callback(s, c, index, objects)

    local bg  = s:get_children_by_id("mybackground_role")[1]
    local brb = s:get_children_by_id("bottomrightborder")[1]
    local bro = s:get_children_by_id("bottomrightborderouter")[1]
    local tlb = s:get_children_by_id("topleftborder")[1]
    local tlo = s:get_children_by_id("topleftborderouter")[1]
    local txt = s:get_children_by_id("mytext_role")[1]

    -- INFO: The next part is some trickery to detect if client is focused
    local focused = capi.client.focus == c
    if not focused and capi.client.focus and capi.client.focus.skip_taskbar and capi.client.focus:get_transient_for_watching(function (cl)
        return not cl.skip_taskbar
    end) == c then
        focused = true
    end

    local class = helpers.class_width_constrained(c, 25)
    if focused then
        txt:set_markup_silently(helpers.bold_text(class))

        bg:set_bg(beautiful.tasklist_bg_focus)
        brb:set_bg(beautiful.tasklist_bg_focus)
        bro:set_bg(beautiful.fg_focus)
        tlb:set_bg(beautiful.inactive_color)
        tlo:set_bg(beautiful.fg_normal)
    else
        txt:set_markup_silently(class)

        bg:set_bg(beautiful.tasklist_bg_normal)
        brb:set_bg(beautiful.inactive_color)
        bro:set_bg(beautiful.fg_normal)
        tlb:set_bg(beautiful.bg_normal)
        tlo:set_bg(beautiful.fg_focus)
    end
end

local task_template = {
    {
        {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            {
                                                {
                                                    {
                                                        id     = "icon_role",
                                                        widget = wibox.widget.imagebox,
                                                    },
                                                    id     = "icon_margin_role",
                                                    left   = 1,
                                                    widget = wibox.container.margin,
                                                },
                                                {
                                                    id           = "mytext_role",
                                                    forced_width = 200,
                                                    align        = "left",
                                                    font         = beautiful.font_base .. " 14",
                                                    widget       = wibox.widget.textbox,
                                                },
                                                id      = "lyout",
                                                spacing = beautiful.widget_margin_inner,
                                                layout  = wibox.layout.fixed.horizontal,
                                            },
                                            id      = "text_margin_role",
                                            margins = beautiful.widget_margin_inner,
                                            widget  = wibox.container.margin,
                                        },
                                        id                 = "mybackground_role",
                                        shape              = gears.shape.rectangle,
                                        bg                 = beautiful.bg_normal,
                                        shape_border_width = beautiful.widget_border_width,
                                        shape_border_color = beautiful.border_focus,
                                        widget             = wibox.container.background,
                                    },
                                    id     = "mrgnout",
                                    right  = beautiful.widget_margin_outer,
                                    bottom = beautiful.widget_margin_outer,
                                    widget = wibox.container.margin,
                                },
                                id                 = "bottomrightborder",
                                shape              = gears.shape.rectangle,
                                bg                 = beautiful.inactive_color, -- INFO: Should be dark grey
                                shape_border_width = 0,
                                widget             = wibox.container.background,
                            },
                            id     = "mrgnout2",
                            left   = beautiful.widget_margin_outer,
                            top    = beautiful.widget_margin_outer,
                            widget = wibox.container.margin,
                        },
                        id                 = "topleftborder",
                        shape              = gears.shape.rectangle,
                        bg                 = beautiful.bg_normal, -- INFO: Should be normal background color
                        shape_border_width = 0,
                        widget             = wibox.container.background,
                    },
                    id     = "mrgnout3",
                    right  = beautiful.widget_margin_outer,
                    bottom = beautiful.widget_margin_outer,
                    widget = wibox.container.margin,
                },
                id                 = "bottomrightborderouter",
                shape              = gears.shape.rectangle,
                bg                 = beautiful.fg_normal, -- INFO: Should be black
                shape_border_width = 0,
                widget             = wibox.container.background,
            },
            id     = "mrgnout4",
            left   = beautiful.widget_margin_outer,
            top    = beautiful.widget_margin_outer,
            widget = wibox.container.margin,
        },
        id                 = "topleftborderouter",
        shape              = gears.shape.rectangle,
        bg                 = beautiful.fg_focus, -- INFO: Should be white
        shape_border_width = 0,
        widget             = wibox.container.background,
    },
    id              = "mrgnout5",
    margins         = beautiful.widget_margin_outer,
    widget          = wibox.container.margin,
    create_callback = function(self, c, index, objects)
        callback(self, c, index, objects)
    end,
    update_callback = function(self, c, index, objects)
        callback(self, c, index, objects)
    end,
}

-- Contains the widgets on the right side of the screen
local widget_box = wibox.widget{
    margins = beautiful.widget_margin_outer,
    widget  = wibox.container.margin,
    {
        bg     = beautiful.lighter_white,
        widget = wibox.container.background,
        {
            bottom = beautiful.widget_margin_inner,
            right  = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
            {
                bg     = beautiful.inactive_color,
                widget = wibox.container.background,
                {
                    top    = beautiful.widget_margin_inner,
                    left   = beautiful.widget_margin_inner,
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.bg_normal,
                        widget = wibox.container.background,
                        {
                            margins = beautiful.widget_margin_inner,
                            widget  = wibox.container.margin,
                            {
                                layout = wibox.layout.fixed.horizontal,
                                mywidgets.screenshotwidget,
                                mywidgets.diskwidget,
                                mywidgets.brightnesswidget,
                                mywidgets.volumewidget,
                                mywidgets.keyboardwidget,
                                wibox.widget.systray(),
                                mywidgets.clockwidget,
                            }
                        }
                    }
                }
            }
        }
    }
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
            squares_resize = true,
            spacing        = 5,
            shape          = function (cr, width, height)
                gears.shape.rectangle(cr, width, height)
            end,
        }, -- TODO: add layout
    })
    s.mysmalltag = mywidgets.smalltag
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

    --[[ The actual wibar ]]
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
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mywidgets.startwidget,
            s.mysmalltag,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            widget_box,
            s.mylayoutbox,
        },
    })
end)
