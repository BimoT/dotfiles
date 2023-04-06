local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
-- local helpers = require("extras.helpers")
local beautiful = require("beautiful")
local mywidgets = require("mywidgets")
local keybindings = require("keybindings")

local widget_template = {
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
                                                        id = "icon_role",
                                                        widget = awful.widget.clienticon,
                                                    },
                                                    id = "icon_margin_role",
                                                    margins = beautiful.widget_margin_inner,
                                                    widget = wibox.container.margin,
                                                },
                                                {
                                                    id = "text_role",
                                                    -- forced_width = dpi(50),
                                                    align = "left",
                                                    --font = "Ubuntu Nerd Font Complete 12",
                                                    widget = wibox.widget.textbox,
                                                },
                                                id = "lyout",
                                                spacing = beautiful.widget_margin_inner,
                                                layout = wibox.layout.fixed.horizontal,
                                            },
                                            id = "text_margin_role",
                                            margins = beautiful.widget_margin_inner,
                                            widget = wibox.container.margin,
                                        },
                                        id = "background_role",
                                        shape = gears.shape.rectangle,
                                        bg = beautiful.bg_normal,
                                        shape_border_width = beautiful.widget_border_width,
                                        shape_border_color = beautiful.border_focus,
                                        widget = wibox.container.background,
                                    },
                                    id = "mrgnout",
                                    right = beautiful.widget_margin_outer,
                                    bottom = beautiful.widget_margin_outer,
                                    widget = wibox.container.margin,
                                },
                                id = "bottomrightborder",
                                shape = gears.shape.rectangle,
                                bg = beautiful.inactive_color, -- INFO: Should be dark grey
                                shape_border_width = 0,
                                -- shape_border_color = beautiful.red_dark,
                                widget = wibox.container.background,
                            },
                            id = "mrgnout2",
                            left = beautiful.widget_margin_outer,
                            top = beautiful.widget_margin_outer,
                            widget = wibox.container.margin,
                        },
                        id = "topleftborder",
                        shape = gears.shape.rectangle,
                        bg = beautiful.bg_normal, -- INFO: Should be normal background color
                        shape_border_width = 0,
                        widget = wibox.container.background,
                    },
                    id = "mrgnout3",
                    right = beautiful.widget_margin_outer,
                    bottom = beautiful.widget_margin_outer,
                    widget = wibox.container.margin,
                },
                id = "bottomrightborderouter",
                shape = gears.shape.rectangle,
                bg = beautiful.fg_normal, -- INFO: Should be black
                shape_border_width = 0,
                -- shape_border_color = beautiful.red_dark,
                widget = wibox.container.background,
            },
            id = "mrgnout4",
            left = beautiful.widget_margin_outer,
            top = beautiful.widget_margin_outer,
            widget = wibox.container.margin,
        },
        id = "topleftborderouter",
        shape = gears.shape.rectangle,
        bg = beautiful.fg_focus, -- INFO: Should be white
        shape_border_width = 0,
        widget = wibox.container.background,
    },
    id = "mrgnout5",
    margins = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

local function custom_template(args)
    local l = wibox.widget.base.make_widget_from_value(args.widget_template)

    -- The template system requires being able to get children elements by ids.
    -- This is not optimal, but for now there is no way around it.
    assert(l.get_children_by_id,"The given widget template did not result in a"..
        "layout with a 'get_children_by_id' method")

    return {
        ib              = l:get_children_by_id( "icon_role"              )[1],
        tb              = l:get_children_by_id( "text_role"              )[1],
        bgb             = l:get_children_by_id( "background_role"        )[1],
        tbm             = l:get_children_by_id( "text_margin_role"       )[1],
        ibm             = l:get_children_by_id( "icon_margin_role"       )[1],
        brb             = l:get_children_by_id( "bottomrightborder"      )[1],
        bro             = l:get_children_by_id( "bottomrightborderouter" )[1],
        tlb             = l:get_children_by_id( "topleftborder"          )[1],
        tlo             = l:get_children_by_id( "topleftborderouter"     )[1],
        primary         = l,
        update_callback = l.update_callback,
        create_callback = l.create_callback,
    }
end

local function create_buttons(buttons, object)
    if buttons then
        local btns = {}
        for _, b in ipairs(buttons) do
            local btn = awful.button({
                modifiers = b.modifiers,
                button = b.button,
                on_press = function () b:emit_signal("press", object) end,
                on_release = function () b:emit_signal("release", object) end,
            })
            btns[#btns+1] = btn
        end
        return btns
    end
end

local function update(w, buttons, label, data, objects, args)
    --[[
        w      : the widget
        buttons: table (should be tasklist buttons)
        label  : func to generate label parameters from an object. This gets passed an object from `objects`, and has to return "text", "bg", "bg_image", "icon"
        data   : table, current data/cache, indexed by objects
        objects: table, objects to be displayed/updated
        args   : table, default {}
    ]]
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]

        -- allow the buttons to be replaced?
        if cache and cache._buttons ~= buttons then
            cache = nil
        end
        local ib, tb, bgb, tbm, ibm, brb, bro, tlb, tlo, primary, upd, cre
        if not cache then
            ib, tb, bgb, tbm, ibm, brb, bro, tlb, tlo, primary, upd, cre = custom_template(widget_template)
        end
    end
end
