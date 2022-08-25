local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local naughty = require("naughty")

local function padding(width) return wibox.widget({forced_width = dpi(50), layout = wibox.layout.fixed.horizontal }) end
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        -- Left mouse button
        awful.button({ }, 1, function()
            -- moves the window
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        -- Middle mouse button
        awful.button({ }, 2, function()
            -- closes the window
            c:kill()
        end), 
        -- Right mouse button
        awful.button({ }, 3, function()
            -- resizes the window
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    awful.titlebar(c, {size=beautiful.titlebar_height, position="top"}) : setup {
        --[[
            You can uncomment the blocks for "Left" and "Middle" to have icons or text there.
            If you want nothing at all, just have {nil, nil, nil} as the argument for the :setup() function.
            However, having the positions be nil also disables the mouse button functionality for draggin and
            resizing, so that is a negative.
            The best option is to replace it with {buttons=buttons, widget=wibox.widget.textbox(""), align="center"}.
        --]]
        nil,
        {
            buttons = buttons,
            widget = wibox.widget.textbox(""),
            align = "center"
        },

        --[[ { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        --]]
        --[[ { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        --]]
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            wibox.widget({forced_width = dpi(10), layout = wibox.layout.fixed.horizontal }),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal,
    }
end)

