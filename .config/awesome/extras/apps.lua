local user = user
local awful = require("awful")
local gears = require("gears")

--[[ List some default applications ]]

local A = {}
-- This is used later as the default terminal and editor to run.
A.terminal = "alacritty"
-- A.editor = os.getenv("EDITOR") or "vim"
A.launch_terminal = function ()
    awful.spawn(user.terminal .. " --working-directory " .. os.getenv("HOME"))
end
A.launch_floating_terminal = function ()
    awful.spawn(user.terminal .. " --working-directory " .. os.getenv("HOME") .. " --class startasfloat" )
end
A.spawn_in_terminal = function (app) awful.spawn(user.terminal .. " --working-directory " .. os.getenv("HOME") .. " -e " .. app) end
-- A.editor_cmd = A.terminal .. " -e " .. A.editor
A.launch_editor = function () awful.spawn(user.editor) end
A.launch_filemanager_gui = function () awful.spawn(user.filemanager_gui) end
A.launch_filemanager_tui = function () A.spawn_in_terminal(user.filemanager_tui) end
A.launch_webbrowser = function () awful.spawn(user.webbrowser) end
A.launch_applauncher = function () awful.spawn("rofi -show drun") end
A.lockscreen = function ()
    local background = gears.filesystem.get_configuration_dir() .. "pictures/emmet_blurred.png"
    awful.spawn.with_shell([[i3lock -i "]] ..  background ..[[" --fill --pointer=default --show-failed-attempts --clock --ignore-empty-password --indicator --ring-width 10 --inside-color=ffffff --ring-color=5e1900 --insidever-color=cb6500 --ringver-color=cb6500]])
end

return A
