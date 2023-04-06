-- Smalltag: a small taglist
--  
-- Instead of displaying all tags, it shows just the active tag, like this: [1]
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local helpers = require("extras.helpers")
-- local capi = {
--     screen  = screen,
--     awesome = awesome,
--     client  = client,
-- }

local smalltag = wibox.widget({
    id = "margin_role",
    left = 3,
    right = 3,
    widget = wibox.container.margin,
    {
        id = "background_role",
        widget = wibox.container.background,
        bg = beautiful.taglist_bg or beautiful.bg_normal or "#000000",
        fg = beautiful.taglist_fg or beautiful.fg_normal or "#FFFFFF",
        {
            id = "text_margin_role",
            margins = beautiful.taglist_margins or 2,
            widget = wibox.container.margin,
            {
                id = "text_role",
                widget = wibox.widget.textbox,
                font = beautiful.taglist_font or beautiful.font or "Helvetica 10",
                markup = "",
            }
        }
    }
}
)

local function smalltag_format(num)
    if type(num) == "number" then
        return "["..tostring(num).."]"
    elseif type(num) == "string" then
        return "["..num.."]"
    end
end

local function smalltag_update()
    local currtag = awful.screen.focused().selected_tag
    if currtag then
        local a = smalltag_format(currtag.index)
        smalltag:get_children_by_id("text_role")[1]:set_markup(a)
    end
end

awful.tag.attached_connect_signal(nil, "property::selected", function (t)
        smalltag_update()
end)

smalltag:buttons(
    gtable.join(
        --[[ left mouse click ]]
        awful.button({ }, 1,
            function (t)
                awful.tag.viewnext(t.screen)
            end),
        --[[ right mouse click ]]
        awful.button({ }, 3,
            function (t)
                awful.tag.viewprev(t.screen)
            end),
        --[[ scroll up ]]
        awful.button({ }, 4,
            function (t)
                awful.tag.viewnext(t.screen)
            end),
        --[[ scroll down ]]
        awful.button({ }, 5,
            function (t)
                awful.tag.viewprev(t.screen)
            end)
    )
)

helpers.hover_bg(smalltag, {
    background_id = "background_role",
    color_after_entering = beautiful.bg_focus,
    color_after_leaving = beautiful.bg_normal,
})
helpers.hover_fg(smalltag, {
    background_id = "background_role",
    color_after_entering = beautiful.fg_focus,
    color_after_leaving = beautiful.fg_normal,
})
helpers.hover_cursor(smalltag)

return smalltag
