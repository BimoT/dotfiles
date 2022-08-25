local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

--[[
    Some apps don't have a clienticon, such as Inkscape and Gcolor.
    This should fix that and allow these apps to find an icon anyways.
    UNFINISHED
--]]

local function getmeanicon(nameofapp)
    local ICON_DIR = os.getenv("home") .. "/.config/awesome/Icons/App_icons"
    -- Returns either nothing or 

end
