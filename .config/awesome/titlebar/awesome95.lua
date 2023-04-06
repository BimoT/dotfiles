local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("extras.helpers")
local keybindings = require("keybindings")

--                                               ___  _____
--                                              / _ \| ____|
--   __ ___      _____  ___  ___  _ __ ___   __| (_) | |__
--  / _` \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \__, |___ \
-- | (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/ / / ___) |
--  \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|/_/ |____/
-- 

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    --[[ Buttons for the titlebar ]]
    local buttons = keybindings.titlebar_buttons

    --[[ Use the same width for all pseudo-borders ]]
    local border_width = beautiful.border_width / 2

    --[[ Left titlebar ]]
    local left_titlebar = awful.titlebar(c, {
        size           = border_width * 4,
        enable_tooltip = false,
        position       = "left",
        -- bg             = beautiful.lighter_grey,
    })
    left_titlebar:setup({
        bg     = beautiful.lighter_grey,
        widget = wibox.container.background,
        {
            left   = border_width,
            widget = wibox.container.margin,
            {
                bg     = beautiful.white,
                widget = wibox.container.background,
                {
                    left   = border_width,
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.bg_normal,
                        widget = wibox.container.background,
                        {
                            layout = wibox.layout.align.vertical,
                            {
                                widget = wibox.widget.textbox,
                                text   = "",
                                height = border_width * 2,
                            }
                        }
                    }
                }
            }
        }
    })

    --[[ Right titlebar ]]
    local right_titlebar = awful.titlebar(c, {
        size           = border_width * 4,
        enable_tooltip = false,
        position       = "right",
    })
    right_titlebar:setup({
        bg     = beautiful.black,
        widget = wibox.container.background,
        {
            widget = wibox.container.margin,
            right  = border_width,
            {
                bg     = beautiful.inactive_color,
                widget = wibox.container.background,
                {
                    right  = border_width,
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.bg_normal,
                        widget = wibox.container.background,
                        {
                            widget = wibox.widget.textbox,
                            text   = "",
                            height = border_width * 2,
                            layout = wibox.layout.align.vertical,
                        }
                    }
                }
            }
        }
    })

    --[[ Bottom titlebar ]]
    local bottom_titlebar = awful.titlebar(c, {
        size           = border_width * 4,
        enable_tooltip = false,
        position       = "bottom",
        bg             = beautiful.black,
    })
    bottom_titlebar:setup({
        bg     = beautiful.black,
        widget = wibox.container.background,
        {
            widget = wibox.container.margin,
            bottom = border_width,
            right  = border_width,
            {
                bg     = beautiful.inactive_color,
                widget = wibox.container.background,
                {
                    bottom = border_width,
                    right  = border_width,
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.bg_normal,
                        widget = wibox.container.background,
                        {
                            layout = wibox.layout.flex.horizontal,
                            {
                                widget = wibox.widget.textbox,
                                text   = "",
                                align  = "left",
                                height = border_width * 2,
                            }
                        }
                    }
                }
            }
        }
    })

    --[[ Top titlebar ]]
    local bg_98 = gears.color({
        type  = "linear",
        from  = {0, 0},
        to    = {c.width, 0},
        stops = {{0, beautiful.bg_focus}, {1, beautiful.bg_focus2}},
    })
    local bg_98_inactive = gears.color({
        type  = "linear",
        from  = {0, 0},
        to    = {c.width, 0},
        stops = {{0, beautiful.inactive_color}, {1, beautiful.inactive_color2}},
    })
    local top_titlebar = awful.titlebar(c, {
        size           = beautiful.titlebar_height + (border_width * 3),
        enable_tooltip = false,
        position       = "top",
    })
    top_titlebar:setup({
        --[[
            You can uncomment the blocks for "Left" and "Middle" to have icons or text there.
            If you want nothing at all, just have {nil, nil, nil} as the argument for the :setup() function.
            However, having the positions be nil also disables the mouse button functionality for draggin and
            resizing, so that is a negative.
            The best option is to replace it with {buttons=buttons, widget=wibox.widget.textbox(""), align="center"}.
        --]]
        bg     = beautiful.black,
        widget = wibox.container.background,
        {
            right  = border_width,
            widget = wibox.container.margin,
            {
                bg     = beautiful.lighter_grey,
                widget = wibox.container.background,
                {
                    left   = border_width,
                    top    = border_width,
                    widget = wibox.container.margin,
                    {
                        bg     = beautiful.inactive_color,
                        widget = wibox.container.background,
                        {
                            right  = border_width,
                            widget = wibox.container.margin,
                            {
                                bg     = beautiful.white,
                                widget = wibox.container.background,
                                {
                                    left   = border_width,
                                    top    = border_width,
                                    widget = wibox.container.margin,
                                    {
                                        bg     = beautiful.bg_normal,
                                        widget = wibox.container.background,
                                        {
                                            margins = border_width * 2,
                                            widget  = wibox.container.margin,
                                            {
                                                id     = "background",
                                                -- bg  = bg_98,
                                                bg     = beautiful.bg_normal,
                                                fg     = beautiful.fg_normal,
                                                widget = wibox.container.background,
                                                {
                                                    layout = wibox.layout.align.horizontal,
                                                    { --[[ Left widgets ]]
                                                        buttons = buttons,
                                                        layout  = wibox.layout.fixed.horizontal,
                                                        {
                                                            -- left = border_width * 2,
                                                            -- right = border_width * 2,
                                                            -- top = border_width,
                                                            -- bottom = border_width,
                                                            margins = border_width * 2,
                                                            widget  = wibox.container.margin,
                                                            {
                                                                awful.titlebar.widget.iconwidget(c),
                                                                layout = wibox.layout.fixed.horizontal,
                                                            }
                                                        }
                                                    },
                                                    { --[[ Middle widgets ]]
                                                        buttons = buttons,
                                                        layout  = wibox.layout.flex.horizontal,
                                                        {
                                                            id     = "title_widget",
                                                            markup = helpers.bold_text(helpers.getcleanclass(c)),
                                                            widget = wibox.widget.textbox,
                                                            align  = "left",
                                                            font   = beautiful.font_base .. " 15"
                                                        }
                                                    },
                                                    { --[[ Right widgets ]]
                                                        top    = border_width,
                                                        right  = border_width,
                                                        bottom = - border_width,
                                                        widget = wibox.container.margin,
                                                        {
                                                            layout = wibox.layout.fixed.horizontal,
                                                            awful.titlebar.widget.minimizebutton(c),
                                                            awful.titlebar.widget.maximizedbutton(c),
                                                            awful.titlebar.widget.closebutton(c),
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    })

    c:connect_signal("property::class", function (q)
        local txt   = top_titlebar:get_children_by_id("title_widget")[1]
        local class = helpers.bold_text(helpers.getcleanclass(c))
        txt:set_markup(class)
    end)

    c:connect_signal("focus", function (q)
        local bg = top_titlebar:get_children_by_id("background")[1]
        -- bg:set_bg(bg_98)
        bg:set_bg(beautiful.bg_focus)
        bg:set_fg(beautiful.fg_focus)
    end)

    c:connect_signal("unfocus", function (q)
        local bg = top_titlebar:get_children_by_id("background")[1]
        -- bg:set_bg(bg_98_inactive)
        bg:set_bg(beautiful.bg_minimize)
        bg:set_fg(beautiful.bg_normal)
    end)
end)
