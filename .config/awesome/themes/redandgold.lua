--               _                 _             _     _
--              | |               | |           | |   | |
--  _ __ ___  __| | __ _ _ __   __| | __ _  ___ | | __| |
-- | '__/ _ \/ _` |/ _` | '_ \ / _` |/ _` |/ _ \| |/ _` |
-- | | |  __/ (_| | (_| | | | | (_| | (_| | (_) | | (_| |
-- |_|  \___|\__,_|\__,_|_| |_|\__,_|\__, |\___/|_|\__,_|
--                                    __/ |
--                                   |___/

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
-- local ICON_DIR = os.getenv('HOME') .. "/.config/awesome/Icons/titlebar_icons/"
-- local ICON_DIR = gfs.get_configuration_dir() .. "icons/titlebar_icons/"
-- local ICON_DIR = HOME .. '/Pictures/Icons/'


local theme = {}
theme.ICON_DIR = os.getenv('HOME') .. '/.icons/redandgold/'

theme.font          = "Ubuntu Nerd Font Complete 12"
theme.font_base     = "Ubuntu Nerd Font Complete"
--theme.font_base     = "Overpass Nerd Font"

theme.bg_normal     = "#000000"
--theme.bg_focus      = "#535d6c" -- old standard rc version
theme.bg_focus      = "#5e1900"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.black         = "#000000"
theme.white         = "#ffffff"
theme.grey_light    = "#353535"
theme.grey_purple   = "#5b5259"
theme.purple_dark   = "#522573"
theme.purple_light  = "#892df4"
theme.blue_dark     = "#181d85"
theme.blue_light    = "#5bc5b9"
theme.pink_dark     = "#651f4d"
theme.pink_light    = "#de57af"
theme.red_dark      = "#800f0e"
--theme.red_light     = "#ea5150"
theme.red_light     = "#ca3f56"
theme.green_dark    = "#175f21"
theme.green_light   = "#85e365"
theme.orange_dark   = "#8c3610"
theme.orange_light  = "#f68f3f"


--[[ true/false ENV variables ]]
theme.want_client_borders = true
theme.want_icon_widgets   = false

theme.border_width        = dpi(3)
theme.menu_height         = dpi(30)
theme.menu_width          = dpi(150)
theme.rounding_param      = 8
theme.useless_gap         = dpi(5)
theme.widget_border_width = dpi(2) -- for widgets in the wibar
theme.widget_margin_inner = 4 -- for widgets in the wibar
theme.widget_margin_outer = 4 -- for widgets in the wibar


theme.border_normal = "#000000"
--theme.border_focus  = "#ca3f56"
theme.border_focus  = "#cb6500"
theme.border_marked = "#91231c"

--[[ button: close ]]
theme.titlebar_close_button_normal = theme.ICON_DIR.."Close_button.svg"
theme.titlebar_close_button_focus  = theme.ICON_DIR.."Close_button.svg"

--[[ button: minimize ]]
theme.titlebar_minimize_button_normal = theme.ICON_DIR.."Minimize_button.svg"
theme.titlebar_minimize_button_focus  = theme.ICON_DIR.."Minimize_button.svg"

--[[ button: ontop ]]
theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

--[[ button: floating ]]
theme.titlebar_floating_button_normal_inactive = theme.ICON_DIR.."Floating_button.svg"
theme.titlebar_floating_button_focus_inactive = theme.ICON_DIR.."Floating_button.svg"
theme.titlebar_floating_button_normal_active = theme.ICON_DIR.."Anchor_button.svg"
theme.titlebar_floating_button_focus_active = theme.ICON_DIR.."Anchor_button.svg"

--[[ button: maximize ]]
theme.titlebar_maximized_button_normal_inactive = theme.ICON_DIR.."Maximize_button.svg"
theme.titlebar_maximized_button_focus_inactive = theme.ICON_DIR.."Maximize_button.svg"

--[[ button: un-maximize ]]
theme.titlebar_maximized_button_normal_active = theme.ICON_DIR.."Maximized_button.svg"
theme.titlebar_maximized_button_focus_active = theme.ICON_DIR.."Maximized_button.svg"

--theme.wallpaper = "~/Pictures/pexels-travis-blessing-1363876.jpg"
--[[ Wallpapers ]]
theme.wallpaper            = theme.ICON_DIR .. "pexels-emmet-712490.jpg"
theme.lockscreen_wallpaper = theme.ICON_DIR .. "emmet_blurred.png"

theme.titlebar_height = dpi(30)

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- -- Generate home icon:
-- theme.home_icon = theme.ICON_DIR.."home_icon2.png"
-- -- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.awesome_icon        = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.brightness_icon     = theme.ICON_DIR .. "bright_white.png"
theme.brightness_icon_red = theme.ICON_DIR .. "bright_red.png"
theme.camera_icon         = theme.ICON_DIR.."camera_icon.png"
theme.disk_icon           = theme.ICON_DIR.."disk_icon.png"
theme.home_icon           = theme.ICON_DIR.."home_icon2.png"
theme.lock_icon           = theme.ICON_DIR.."lock_icon.png"
theme.poweroff_icon       = theme.ICON_DIR.."poweroff_icon.png"
theme.reboot_icon         = theme.ICON_DIR.."reboot_icon.png"
theme.sound_icon          = theme.ICON_DIR .. "sound_icon.png"
theme.sound_icon_mute     = theme.ICON_DIR.."sound_icon_mute.png"

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_shape_border_width_focus = dpi(1)
theme.taglist_shape_border_color_focus = theme.border_focus

theme.wibar_position = "top"
theme.wibar_height = 40

theme.create_icon_widget = function(icon)
    wibox.widget {
        {
            {
                {
                    id = "img",
                    image = icon,
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                id = "mrgnin",
                margins = theme.widget_margin_inner,
                widget = wibox.container.margin,
            },
            id = "bckgrnd",
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, theme.rounding_param)
            end,
            bg = theme.bg_normal,
            shape_border_width = theme.widget_border_width,
            shape_border_color = theme.border_focus,
            widget = wibox.container.background,
        },
        id = "mrgnout",
        left = theme.widget_margin_outer,
        right = theme.widget_margin_outer,
        widget = wibox.container.margin,
    }
end

return theme
