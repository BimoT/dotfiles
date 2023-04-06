local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local apps = require("extras.apps")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("extras.helpers")

local startmenu_widget = wibox.widget{
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
                                                    id     = "theimage",
                                                    image  = beautiful.home_icon,
                                                    resize = true,
                                                    widget = wibox.widget.imagebox,
                                                },
                                                {
                                                    id     = "thetext",
                                                    align  = "right",
                                                    font   = "Helvetica Bold 15",
                                                    -- markup = '<b><span foreground="'..beautiful.fg_normal..'">Start</span></b>',
                                                    markup = helpers.bold_text(helpers.colored_text("Start", beautiful.fg_normal)),
                                                    --font = "Ubuntu Nerd Font Complete 12",
                                                    widget = wibox.widget.textbox,
                                                },
                                                id      = "lyout",
                                                spacing = beautiful.widget_margin_outer,
                                                layout  = wibox.layout.fixed.horizontal,
                                            },
                                            id      = "mrgnin",
                                            margins = beautiful.widget_margin_inner,
                                            widget  = wibox.container.margin,
                                        },
                                        id                 = "thebackground",
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
    id      = "mrgnout5",
    margins = beautiful.widget_margin_outer,
    widget  = wibox.container.margin,
}

startmenu_widget:connect_signal("mouse::enter", function(c)
    local text = helpers.bold_text(helpers.colored_text("Start", beautiful.fg_focus))
    c:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_focus)
    c:get_children_by_id("thetext")[1]:set_markup(text)
end)
startmenu_widget:connect_signal("mouse::leave", function(c)
    local text = helpers.bold_text(helpers.colored_text("Start", beautiful.fg_normal))
    c:get_children_by_id("thebackground")[1]:set_bg(beautiful.bg_normal)
    c:get_children_by_id("thetext")[1]:set_markup(text)
end)


-- Setup menu items
local menu_items = {
    { name = "Edit config"    , icon = beautiful.edit_icon    , command = apps.edit_config                           },
    { name = "Open manual"    , icon = beautiful.help_icon    , command = apps.awesome_manpages                      },
    { name = "Restart Awesome", icon = beautiful.restart_icon , command = awesome.restart                            },
    { name = "Hotkeys"        , icon = beautiful.hotkeys_icon , command = apps.hotkeys_popup                         },
    { name = "Quit Awesome"   , icon = beautiful.exit_icon    , command = apps.quit_awesome                          },
    { name = "Lock screen"    , icon = beautiful.lock_icon    , command = apps.lockscreen                            },
    { name = "Reboot"         , icon = beautiful.reboot_icon  , command = apps.reboot                                },
    { name = "Run..."         , icon = beautiful.run_icon     , command = apps.launch_applauncher, bar_at = "bottom" },
    { name = "Shut Down..."   , icon = beautiful.poweroff_icon, command = apps.poweroff          , bar_at = "top"    },
}

-- Create the main popup and rows to hold vertical layout, items will be added later
local main_popup = awful.popup {
    ontop               = true,
    visible             = false,
    shape               = gears.shape.rectangle,
    border_width        = 0,
    preferred_positions = "top",
    preferred_anchors   = {"front", "back"},
    widget              = {},
}

-- Set the layout to vertical
local rows = { layout = wibox.layout.fixed.vertical }

--[[ Function to hide popup ]]
local hide = function(widget)
    widget.visible = false
    startmenu_widget:get_children_by_id("bottomrightborder")[1]:set_bg(beautiful.inactive_color)
    startmenu_widget:get_children_by_id("bottomrightborderouter")[1]:set_bg(beautiful.fg_normal)
    startmenu_widget:get_children_by_id("topleftborder")[1]:set_bg(beautiful.bg_normal)
    startmenu_widget:get_children_by_id("topleftborderouter")[1]:set_bg(beautiful.fg_focus)
end

--[[ Function to show popup ]]
local show = function(widget, opts) -- FIX: make sure it always pops up in bottom left corner, above the start widget
    widget:move_next_to(mouse.current_widget_geometry)
    startmenu_widget:get_children_by_id("bottomrightborder")[1]:set_bg(beautiful.bg_normal)
    startmenu_widget:get_children_by_id("bottomrightborderouter")[1]:set_bg(beautiful.fg_focus)
    startmenu_widget:get_children_by_id("topleftborder")[1]:set_bg(beautiful.inactive_color)
    startmenu_widget:get_children_by_id("topleftborderouter")[1]:set_bg(beautiful.fg_normal)
end

local toggle = function(widget)
    if widget.visible then
        hide(widget)
    else
        show(widget)
    end
end

local create_row_in_popup = function(args, parent_popup)
    --[[
        args.icon = path to icon, string
        args.name      = display text, string
        args.command   = function to be executed on click (or table, in case of submenu)
        args.bar_at    = "top" or "bottom", for a thin line added at bottom or top
        mainpopup      = the popup where they are to be put into (by yourself)

        returns: table
    ]]
    local args = args or {}
    args.name = args.name or args[1]
    args.icon = args.icon or args[2]
    args.command = args.command or args[3]

    local parent_popup = parent_popup or main_popup
    local bottom_margin = 0
    local top_margin = 0
    local bar_color = beautiful.bg_normal

    if args.bar_at == "bottom" then
        bottom_margin = dpi(1)
        bar_color     = beautiful.inactive_color
    elseif args.bar_at == "top" then
        top_margin = dpi(1)
        bar_color  = beautiful.fg_focus
    end

    local row
    local icons_and_text = {
            {
                {
                    image         = args.icon,
                    forced_width  = 30,
                    forced_height = 30,
                    widget        = wibox.widget.imagebox
                },
                margins = beautiful.border_width * 2,
                widget  = wibox.container.margin,
            },
            {
                markup       = args.name,
                widget       = wibox.widget.textbox,
                forced_width = dpi(150),
                font         = "Helvetica Regular 13"
            },
            {
                {
                    image  = beautiful.submenu_icon,
                    widget = wibox.widget.imagebox,
                },
                margins = beautiful.border_width,
                widget  = wibox.container.margin,
            },
            spacing = 12,
            layout  = wibox.layout.fixed.horizontal,
        }
    local r = {
        {
            icons_and_text,
            margins = beautiful.widget_margin_inner,
            widget  = wibox.container.margin,
        },
        id     = "thebackground",
        bg     = beautiful.bg_normal,
        widget = wibox.container.background,
    }
    if args.bar_at == "top" or args.bar_at == "bottom" then
        row = wibox.widget{
            {
                r,
                left   = 0,
                right  = 0,
                top    = top_margin,
                bottom = bottom_margin,
                widget = wibox.container.margin,
            },
            shape  = gears.shape.rectangle,
            bg     = bar_color, -- INFO: Should be white
            widget = wibox.container.background,
        }
    else
        row = wibox.widget(r)
    end

    helpers.hover_bg(row, {
        background_id = "thebackground",
        color_after_entering = beautiful.bg_focus,
        color_after_leaving = beautiful.bg_normal
    })
    helpers.hover_fg(row, {
        background_id = "thebackground",
        color_after_entering = beautiful.fg_focus,
        color_after_leaving = beautiful.fg_normal
    })
    helpers.hover_cursor(row)

    -- Mouse click handler
    -- This handles the command that gets executed!
    row:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                hide(parent_popup)
                args.command()
            end)
        )
    )
    return row
end


-- Loops over the menu items, create a row, add row to the popup
for _, item in ipairs(menu_items) do
    local row = create_row_in_popup(item, main_popup)
    table.insert(rows, row)
end

-- Create the grey banner on the left of the popup
local grey_banner = wibox.widget{
    {
            {
                {
                    markup = helpers.bold_text(helpers.colored_text(" Awesome", beautiful.bg_normal)) .. "95",
                    font   = beautiful.font_base.." 20",
                    align  = "left",
                    -- TODO: set width and height?
                    widget = wibox.widget.textbox,
                },
                left   = beautiful.widget_margin_inner,
                top    = beautiful.widget_margin_inner * 2,
                bottom = beautiful.widget_margin_inner,
                widget = wibox.container.margin,
            },
            bg                 = beautiful.inactive_color, -- INFO: dark grey, should be "#808080"?
            fg                 = beautiful.fg_focus,
            shape              = gears.shape.rectangle,
            shape_border_width = dpi(0),
            widget             = wibox.container.background
        },
    direction = "east",
    widget    = wibox.container.rotate,
}

local popup_content = {
    id     = "mrgnin",
    top    = 1,
    left   = 1,
    bottom = 1,
    widget = wibox.container.margin,
    {
        grey_banner,
        rows,
        layout = wibox.layout.fixed.horizontal,
    }
}

-- add rows to the popup
main_popup:setup(
    helpers.addw95borders(popup_content, {
        margin = dpi(1)
    })
)

-- Toggle popup visibility on mouse click:
startmenu_widget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            toggle(main_popup)
    end))
)

return startmenu_widget
