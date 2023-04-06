local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("extras.helpers")
local keybindings = require("keybindings")


client.connect_signal("request::titlebars", function(c)
    local buttons = keybindings.titlebar_buttons
    local border_width = beautiful.border_width / 2
    --[[ Left titlebar ]]
    local left_titlebar = awful.titlebar(c, {
        size            = border_width,
        enable_tooltip  = false,
        position        = "left",
        bg              = beautiful.border_focus,
    })
    local right_titlebar = awful.titlebar(c, {
        size             = border_width,
        enable_tooltip   = false,
        position         = "right",
        bg               = beautiful.border_focus,
    })
    local bottom_titlebar = awful.titlebar(c, {
        size              = border_width,
        enable_tooltip    = false,
        position          = "bottom",
        bg                = beautiful.border_focus,
    })
    local top_titlebar = awful.titlebar(c, {
        size              = beautiful.titlebar_height,
        enable_tooltip    = false,
        position          = "top",
        bg                = beautiful.border_focus,
    })
    top_titlebar:setup({
        id     = "borders",
        bg     = beautiful.border_focus,
        widget = wibox.container.background,
        {
            top    = border_width,
            right  = border_width,
            left   = border_width,
            widget = wibox.container.margin,
            {
                id    = "background",
                bg    = beautiful.bg_normal,
                fg    = beautiful.fg_normal,
                widget = wibox.container.background,
                {
                    layout = wibox.layout.align.horizontal,
                    { -- [[ Left widgets ]]
                        buttons = buttons,
                        layout = wibox.layout.fixed.horizontal,
                        {
                            margins = border_width,
                            widget = wibox.container.margin,
                            {
                                awful.titlebar.widget.iconwidget(c),
                                layout = wibox.layout.fixed.horizontal,
                            }
                        }
                    },
                    { --[[ Middle widgets ]]
                        buttons = buttons,
                        layout = wibox.layout.flex.horizontal,
                        {
                            id = "title_widget",
                            markup = helpers.bold_text(helpers.getcleanclass(c)),
                            widget = wibox.widget.textbox,
                            align = "left",
                            font = beautiful.font_base .. " 15"
                        }
                    },
                    { --[[ Right widgets ]]
                        margins = border_width / 2,
                        widget = wibox.container.margin,
                        {
                            layout = wibox.layout.fixed.horizontal,
                            -- awful.titlebar.widget.floatingbutton(c),
                            awful.titlebar.widget.minimizebutton(c),
                            awful.titlebar.widget.maximizedbutton(c),
                            awful.titlebar.widget.closebutton(c),
                        }
                    }
                },
            },
        },
    })

    c:connect_signal("property::class", function (q)
        local txt = top_titlebar:get_children_by_id("title_widget")[1]
        local class = helpers.bold_text(helpers.getcleanclass(c))
        txt:set_markup(class)
    end)

    c:connect_signal("focus", function (q)
        local bg = top_titlebar:get_children_by_id("background")[1]
        -- bg:set_bg(bg_98)
        bg:set_bg(beautiful.bg_normal)
        bg:set_fg(beautiful.fg_focus)
    end)

    c:connect_signal("unfocus", function (q)
        local bg = top_titlebar:get_children_by_id("background")[1]
        -- bg:set_bg(bg_98_inactive)
        bg:set_bg(beautiful.bg_normal)
        bg:set_fg(beautiful.bg_normal)
    end)
    
end)
