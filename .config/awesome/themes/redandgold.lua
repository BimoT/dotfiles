---------------------------
-- Custom awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
-- local ICON_DIR = os.getenv('HOME') .. "/.config/awesome/Icons/titlebar_icons/"
local ICON_DIR = gfs.get_configuration_dir() .. "icons/titlebar_icons/"
-- local ICON_DIR = HOME .. '/Pictures/Icons/'


local theme = {}

theme.font          = "Ubuntu Nerd Font Complete 12"
theme.font_base     = "Ubuntu Nerd Font Complete"
--theme.font_base     = "Overpass Nerd Font"

theme.bg_normal     = "#000000"
--theme.bg_focus      = "#535d6c" -- old standard rc version
theme.bg_focus      = "#5e1900"--"#3d0d60" --"#522573" -- "#7c55a7"
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

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(3)
theme.rounding_param = 8
theme.widget_border_width = dpi(2) -- for widgets in the wibar
theme.widget_margin_inner = 4 -- for widgets in the wibar
theme.widget_margin_outer = 4 -- for widgets in the wibar
theme.border_normal = "#000000"
--theme.border_focus  = "#ca3f56"
theme.border_focus  = "#cb6500"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_shape_border_width_focus = dpi(1)
theme.taglist_shape_border_color_focus = theme.border_focus

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(150)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
-- theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_close_button_normal = ICON_DIR.."Close_button.svg"
theme.titlebar_close_button_focus = ICON_DIR.."Close_button.svg"

-- theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_normal = ICON_DIR.."Minimize_button.svg"
theme.titlebar_minimize_button_focus  = ICON_DIR.."Minimize_button.svg"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

-- theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

-- theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_floating_button_normal_inactive = ICON_DIR.."Floating_button.svg"
theme.titlebar_floating_button_focus_inactive = ICON_DIR.."Floating_button.svg"
theme.titlebar_floating_button_normal_active = ICON_DIR.."Anchor_button.svg"
theme.titlebar_floating_button_focus_active = ICON_DIR.."Anchor_button.svg"

-- theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = ICON_DIR.."Maximize_button.svg"
theme.titlebar_maximized_button_focus_inactive = ICON_DIR.."Maximize_button.svg"
theme.titlebar_maximized_button_normal_active = ICON_DIR.."Maximized_button.svg"
theme.titlebar_maximized_button_focus_active = ICON_DIR.."Maximized_button.svg"

--theme.wallpaper = "~/Pictures/pexels-travis-blessing-1363876.jpg"
theme.wallpaper = "~/Pictures/pexels-emmet-712490.jpg"
theme.titlebar_height = dpi(30)

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.home_icon = ICON_DIR.."home_icon2.png" 
-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
