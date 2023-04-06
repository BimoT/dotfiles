local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi

--[[ Lists some common default applications ]]

local A = {}

A.webbrowser      = "firefox"
A.editor          = "nvim"
A.filemanager_gui = "thunar"
A.filemanager_tui = "lf"
A.terminal        = "alacritty"
A.home_dir        = os.getenv("HOME")
A.SCREENSHOT_DIR = "~/Pictures/Screenshots/"


A.launch_terminal = function ()
    awful.spawn(A.terminal .. " --working-directory " .. A.home_dir)
end

--HACK: Alacritty does not accept setting floating property here, so we have to do it in awful.rules
A.launch_floating_terminal = function ()
    local class = A.terminal .. "float"
    awful.spawn(A.terminal .. " --working-directory " .. A.home_dir .. " --class ".. class)
end


---Spawns an application, using your home directory as the working directory
--- 
---Useful for spawning file managers
---@param app string the application that you want to spawn
A.spawn_in_terminal_homedir = function (app)
    awful.spawn(A.terminal .. " --working-directory " .. A.home_dir .. " -e " .. app)
end

---Spawns an application in a new terminal
---@param app string the application that you want to spawn
A.spawn_in_terminal = function (app)
    awful.spawn(A.terminal .. " -e " .. app)
end

A.launch_editor = function ()
    awful.spawn(A.editor)
end

A.launch_filemanager_gui = function ()
    awful.spawn(A.filemanager_gui)
end

A.launch_filemanager_tui = function ()
    A.spawn_in_terminal_homedir(A.filemanager_tui)
end

A.launch_webbrowser = function ()
    awful.spawn(A.webbrowser)
end

A.launch_applauncher = function ()
    awful.spawn("rofi -show drun")
end

A.poweroff = function()
    awful.spawn("poweroff")
end

A.reboot = function ()
    awful.spawn("reboot")
end

A.lockscreen = function ()
    local background = beautiful.lockscreen_wallpaper
    if (background == nil) or (background == "") then
        naughty.notify({title = "Lockscreen error!", text = "Cannot find the lockscreen wallpaper", bg = "#f00"})
    else
        awful.spawn.with_shell([[i3lock -i "]] ..  background ..[[" --fill --pointer=default --show-failed-attempts --clock --ignore-empty-password --indicator --ring-width 10 --inside-color=ffffff --ring-color=5e1900 --insidever-color=cb6500 --ringver-color=cb6500]])
    end
end

A.awesome_manpages = function()
    awful.spawn(A.terminal .. " -e man awesome")
end

A.edit_config = function()
    A.spawn_in_terminal(A.editor .. " " .. awesome.conffile)
end

A.hotkeys_popup = function()
    hotkeys_popup.show_help(nil, awful.screen.focused())
end

A.quit_awesome = function ()
    awesome.quit()
end

---Captures a part of the screen, using a GUI interface
A.flameshot_gui = function()
    awful.spawn.with_shell("flameshot gui -p "..A.SCREENSHOT_DIR)
end

---Captures the whole screen
A.flameshot_fullscreen = function()
    awful.spawn.with_shell("flameshot screen -p "..A.SCREENSHOT_DIR)
    gears.timer({
        timeout     = 1.5,
        autostart   = false,
        call_now    = false,
        single_shot = true,
        callback    = function ()
            naughty.notify({
                title        = "Screenshot taken",
                text         = A.SCREENSHOT_DIR,
                font         = beautiful.font_base.." 18",
                margin       = dpi(20),
                shape        = function(cr, width, height )
                    gears.shape.infobubble(cr, width, height, 8, 15, 20)
                end,
                timeout      = 2,
                position     = "top_right",
                border_color = beautiful.border_focus,
                border_width = 2,
                icon         = beautiful.camera_icon,
                icon_size    = dpi(48),
            })
        end
    })
end

A.launch_gimp = function ()
    awful.spawn("gimp")
end

A.launch_inkscape = function ()
    awful.spawn("inkscape")
end

A.launch_emacs = function ()
    awful.spawn("emacs")
end

A.launch_mgba = function ()
    awful.spawn("mgba")
end

A.launch_color_picker = function ()
    awful.spawn("gcolor3")
end

return A
