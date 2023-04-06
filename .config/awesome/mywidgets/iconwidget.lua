-- iconwidget: a simple widget that displays an icon, and runs a command when clicked
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local iconwidget = { mt = {} }

local function update_template(widget, image_path)
    local image_role = widget:get_children_by_id("image_role")
    if image_role == nil then
        error("cannot find the `image_role` in the template, which is needed when providing a template", 1)
    end
    image_role[1]:set_image(image_path)
end

---Creates a new icon widget
---@param args {image_path: string, cmd: function, template?: table}
function iconwidget.new(args)
    assert(type(args.image_path) == "string", "`image_path` needs to be a string and is required!")
    assert(type(args.cmd) == "function", "`cmd` needs to be a function, and is required!")

    local template = args.template or {
        id     = "margins",
        top    = 8,
        bottom = 8,
        left   = 4,
        right  = 4,
        widget = wibox.container.margin,
        {
            id     = "background_role",
            bg     = beautiful.bg_normal,
            widget = wibox.container.background,
            {
                id     = "image_role",
                image  = args.image_path,
                -- image = beautiful.ICON_DIR .. "apps/48/firefox.png",
                resize = true,
                widget = wibox.widget.imagebox,
            }
        }
    }

    local w = wibox.widget.base.make_widget_declarative(template)
    update_template(w, args.image_path)

    w:buttons(awful.button({}, 1,
        function ()
            args.cmd()
        end)
    )
    if args.hover_text and type(args.hover_text) == "string" then
        local tooltip = awful.tooltip({
            objects = { w },
            text    = args.hover_text,
        })
    end
    return w
end

function iconwidget.mt:__call(a)
    return iconwidget.new(a)
end

return setmetatable(iconwidget, iconwidget.mt)
