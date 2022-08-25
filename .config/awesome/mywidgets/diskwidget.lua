local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
--local mytheme = require("bimotheme")
-- local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
-- local click_to_hide = require("click_to_hide")
-- local constructors = require("extras.constructors")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/Pictures/Icons/'
--beautiful.init("~/.config/awesome/bimotheme.lua")

-- Bash commands
local free_mem_cmd = [[free -m | awk '/^Mem:/ {print $3 "/" $4}']]
local ten_mem_cmd = [[ps axch -o cmd,%mem --sort=-%mem | head | awk '{ $NF = "____"$NF; print }']]
--local ten_mem_cmd = [[ps axch -o cmd:20,%mem --sort=-%mem | head]]
local cpu_temp_cmd = [[sensors | awk '/^temp1/ {print $2}']]
local ten_cpu_cmd = [[ps axch -o cmd,%cpu --sort=-%cpu | head | awk '{ $NF = "____"$NF; print }']]

local memorywidget = wibox.widget {
    {
        {
            {
                id = "img",
                image = ICON_DIR .. "disk_icon.png",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            id = "mrgnin",
            margins = beautiful.widget_margin_inner,
            widget = wibox.container.margin,
        },
        id = "bckgrnd",
        shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
        end,
        bg = beautiful.bg_normal,
        shape_border_width = beautiful.widget_border_width,
        shape_border_color = beautiful.border_focus,
        widget = wibox.container.background,
    },
    id = "mrgnout",
    left = beautiful.widget_margin_outer,
    right = beautiful.widget_margin_outer,
    widget = wibox.container.margin,
}

local main_popup = awful.popup {
    ontop = true,
    visible = false, -- should be hidden when created
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.rounding_param)
    end,
    border_width = beautiful.border_width,
    border_color = beautiful.border_focus,
    maximum_width = dpi(800),
    offset = { y = 5 },
    widget = {}
}

main_popup:setup({
-- divide in 4 parts
    {
        {
            { --{{ top left, free_mem piechart
                {
                    id = "textpart",
                    markup = '<b><span foreground="'..beautiful.border_focus..'">Free and used memory</span></b>',
                    align = "left",
                    widget = wibox.widget.textbox,
                    color = beautiful.border_focus,
                    font = beautiful.font_base.." 16",
                },
                {
                    {
                        id = "usedmems",
                        widget = wibox.widget.textbox,
                        font = beautiful.font_base.." 12",
                        markup = "",
                    },
                    {
                        id = "freemems",
                        widget = wibox.widget.textbox,
                        font = beautiful.font_base.." 12",
                        markup = "",
                    },
                    id = "vertlayout",
                    layout = wibox.layout.flex.vertical,
                },
                {
                    id = "piechartpart",
                    widget = wibox.widget.piechart,
                    display_labels = false,
                    border_width = beautiful.widget_border_width,
                    border_color = beautiful.black,
                    forced_width = dpi(200), -- same as separator
                    forced_height = dpi(200),
                    opacity = 0.8,
                    colors = { beautiful.red_dark,
                        beautiful.green_dark }
                },
                id = "freememlayout",
                spacing = 10,
                layout = wibox.layout.fixed.vertical,
            },--}}
            {
                    id = "separatorbartop",
                    widget = wibox.widget.separator,
                    orientation = "vertical",
                    color = beautiful.bg_focus,
                    forced_width = dpi(30),
                    forced_height = beautiful.widget_border_width,
            },
            { --{{ top right, ten_mem
                {
                    id = "titlepart",
                    markup = '<b><span foreground="'..beautiful.border_focus..'">Highest Memory Usage</span></b>',
                    align = "left",
                    widget = wibox.widget.textbox,
                    font = beautiful.font_base.." 16",
                },
                {
                    {
                        id = "textpartl",
                        widget = wibox.widget.textbox,
                        font = beautiful.font_base.." 12",
                        forced_width = 280,
                        markup = "",
                    },
                    {
                        id = "textpartr",
                        widget = wibox.widget.textbox,
                        align = "center",
                        font = beautiful.font_base.." 12",
                        markup = "",
                   },
                   id = "horizcont",
                   --spacing = 12,
                   --layout = wibox.layout.fixed.horizontal,
                   layout = wibox.layout.flex.horizontal,
                },
                id = "tenmemlayout",
                spacing = 10,
                layout = wibox.layout.fixed.vertical,
            
            },--}}
            { --{{ bottom left, cpu_temp
                {
                    id = "titlepart",
                    markup =  '<b><span foreground="'..beautiful.border_focus..'">CPU Temperature</span></b>',
                    align = "left",
                    widget = wibox.widget.textbox,
                    font = beautiful.font_base.." 16",
                },
                {
                    id = "textpart",
                    widget = wibox.widget.textbox,
                    font = beautiful.font_base.." 15",
                    markup = ""
                },
                id = "cputemplayout",
                spacing = 10,
                layout = wibox.layout.fixed.vertical,
 
            },--}}
            {
                    id = "separatorbarbottom",
                    widget = wibox.widget.separator,
                    orientation = "vertical",
                    color = beautiful.bg_focus,
                    forced_width = dpi(30),
                    forced_height = beautiful.widget_border_width,
            },
            { --{{ bottom right, ten_cpu
                {
                    id = "titlepart",
                    markup =  '<b><span foreground="'..beautiful.border_focus..'">Highest CPU usage</span></b>',
                    align = "left",
                    widget = wibox.widget.textbox,
                    font = beautiful.font_base.." 16",
                },
                {
                    {
                        id = "textpartl",
                        widget = wibox.widget.textbox,
                        font = beautiful.font_base.." 12",
                        markup = "",
                    },
                    {
                        id = "textpartr",
                        widget = wibox.widget.textbox,
                        align = "center",
                        font = beautiful.font_base.." 12",
                        markup = "",
                    },
                    id = "horizcont",
                    --spacing = 12,
                    --layout = wibox.layout.fixed.horizontal,
                    layout = wibox.layout.flex.horizontal,
                },
                id = "tencpulayout",
                spacing = 10,
                layout = wibox.layout.fixed.vertical,
                
            },--}}
            id = "mainlayout",
            forced_num_cols = 3,
            forced_num_rows = 2,
            homogeneous = false,
            expand = true,
            layout = wibox.layout.grid,
        },
        id = "mrgnout",
        margins = beautiful.widget_margin_outer,
        widget = wibox.container.margin,
    },
    id = "bckgrnd",
    bg = beautiful.bg_normal,
    widget = wibox.container.background
})

--{{{Functions:

--{{ free_mem
local display_free_mem = function() 
    local get_mb_gb = function(num)
        -- this assumes that the number is actually a string, because "num" will be
        -- the output of a bash command
        if tonumber(num) > 1024 then
            local gib = tonumber(num) / 1024
            return tostring(math.floor(gib * 100 + 0.5)/100).." Gib"
        else
            return num.." Mib"
        end
    end
    awful.spawn.easy_async_with_shell(free_mem_cmd,
        function(stdout)
            usedmem, freemem  = stdout:match("(%d+)/(%d+)")
            main_popup.bckgrnd.mrgnout.mainlayout.freememlayout.vertlayout.freemems.markup = "Free: "..get_mb_gb(freemem)
            main_popup.bckgrnd.mrgnout.mainlayout.freememlayout.vertlayout.usedmems.markup = "Used: "..get_mb_gb(usedmem)
            main_popup.bckgrnd.mrgnout.mainlayout.freememlayout.piechartpart.data = { ["Used: "..get_mb_gb(usedmem)] = usedmem,
                                                                                      ["Free: "..get_mb_gb(freemem)] = freemem }
        end)
end
--}}
--{{ ten_mem
local display_ten_mem = function()
    awful.spawn.easy_async_with_shell(ten_mem_cmd, 
        function(stdout)
            -- use string matching to split the stdout into the programname and percentage used memory
            local progname = "" -- Store the program name
            local percentage = "" -- Store the percentage
            for line in string.gmatch(stdout, "[^\n]+") do -- Loop over the stdout line by line
                local progname_i, percentage_i = string.match(line, "([^____]+)____([^____]+)")
                if percentage_i ~= "0.0" then -- Only take non-zero percentages
                    progname = progname .. progname_i .. "\n" 
                    percentage = percentage .. percentage_i .. "\n"
                end
            end
            main_popup.bckgrnd.mrgnout.mainlayout.tenmemlayout.horizcont.textpartl.markup = progname
            main_popup.bckgrnd.mrgnout.mainlayout.tenmemlayout.horizcont.textpartr.markup = percentage
        end)
end

--}}
--{{ cpu_temp
local function display_cpu_temp()
    awful.spawn.easy_async_with_shell(cpu_temp_cmd,
    function(stdout)
        main_popup.bckgrnd.mrgnout.mainlayout.cputemplayout.textpart.markup = stdout
    end)

end
--}}
--{{ten cpu
local display_ten_cpu = function()
    awful.spawn.easy_async_with_shell(ten_cpu_cmd,
        function(stdout)
            local progname = "" -- Store the program name
            local percentage = "" -- Store the percentage
            for line in string.gmatch(stdout, "[^\n]+") do -- Loop over the stdout line by line
                local progname_i, percentage_i = string.match(line, "([^____]+)____([^____]+)")
                if percentage_i ~= "0.0" then -- Only take percentages that are not 0.0
                    progname = progname .. progname_i .. "\n"
                    percentage = percentage .. percentage_i .. "\n"
                end
            end
            main_popup.bckgrnd.mrgnout.mainlayout.tencpulayout.horizcont.textpartl.markup = progname
            main_popup.bckgrnd.mrgnout.mainlayout.tencpulayout.horizcont.textpartr.markup = percentage
        end)
end
--}}
--{{ Main function
local fill_main_popup = function()
    display_free_mem()
    display_ten_mem()
    display_cpu_temp()
    display_ten_cpu()
end
--}}
--}}} end of functions

memorywidget:buttons(
    gears.table.join(
        awful.button({}, 1, function()
            if main_popup.visible then
                main_popup.visible = not main_popup.visible
            else
                fill_main_popup()
                main_popup:move_next_to(mouse.current_widget_geometry)

            end
    end))
)

memorywidget:connect_signal("mouse::enter", function()
    memorywidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_focus) 
end)
memorywidget:connect_signal("mouse::leave", function()
    memorywidget:get_children_by_id("bckgrnd")[1]:set_bg(beautiful.bg_normal) 
end)


return memorywidget
--vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:autoindent
