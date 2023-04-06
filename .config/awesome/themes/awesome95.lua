--                                               ___  _____
--                                              / _ \| ____|
--   __ ___      _____  ___  ___  _ __ ___   __| (_) | |__
--  / _` \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \__, |___ \
-- | (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/ / / ___) |
--  \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|/_/ |____/
-- 

-- Follow the instructions for installing Chicago95
-- Have the themes in ./themes, and the icons in ./icons
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()


local theme = {}

local BUTTONS_DIR = os.getenv('HOME') .. "/.themes/Chicago95/gtk-3.0/buttons/"
theme.ICON_DIR = os.getenv('HOME') .. "/.icons/chicago95/Chicago95/"

-- theme.font          = "Ubuntu Nerd Font Complete 12" -- TODO: change to better font
theme.font          = "Helvetica Bold 12" -- TODO: change to better font
-- theme.font_base     = "Ubuntu Nerd Font Complete" -- TODO: change to better font
theme.font_base     = "Helvetica" -- TODO: change to better font
theme.font_bold     = "Helvetica Bold" -- TODO: change to better font

--[[ Background colors ]]
theme.bg_normal     = "#c0c0c0"
-- theme.bg_normal     = "#dfdfdf"
theme.bg_focus      = "#000080"
theme.bg_focus2     = "#1084d0"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
-- theme.bg_systray    = "#dfdfdf"
-- theme.bg_systray    = "#c0c0c0"
theme.inactive_color = "#808080"
theme.inactive_color2= "#b5b5b5"
theme.lighter_white = "#dfdfdf"
theme.lighter_grey = "#dfdfdf"

--[[ Foreground colors ]]
theme.fg_normal     = "#000000"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

--[[ Border colors ]]
theme.border_normal = "#000000"
theme.border_focus  = "#c0c0c0"
theme.border_marked = "#91231c"

--[[ Tooltip colors ]]
theme.tooltip_bg           = "#ffffe1"
theme.tooltip_fg           = "#000000"
theme.tooltip_border_width = 2
theme.tooltip_border_color = "#000000"

--[[ Hotkeys colors ]]
theme.hotkeys_bg           = "#ffffe1"
theme.hotkeys_fg           = "#000000"
theme.hotkeys_border_width = 2
theme.hotkeys_border_color = "#000000"
theme.hotkeys_shape        = gears.shape.rectangle

--[[ Other colors ]]
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

--[[ Wallpapers ]]
theme.wallpaper            = theme.ICON_DIR .. "Chicago95_wallpaper.png"
theme.lockscreen_wallpaper = theme.ICON_DIR .. "Chicago95_wallpaper.png"

--[[ true/false ENV variables ]]
theme.want_client_borders = false
theme.want_icon_widgets   = true

--[[ Titlebar options ]]
theme.titlebar_height    = dpi(35)
-- theme.titlebar_bg_normal = theme.inactive_color
-- theme.titlebar_bg_focus  = theme.bg_focus

--[[ Tasklist colors ]]
theme.tasklist_bg_focus  = theme.lighter_white
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_focus  = theme.black
theme.tasklist_fg_normal = theme.black

theme.border_width        = dpi(4)
theme.menu_height         = dpi(30)
theme.menu_width          = dpi(150)
theme.rounding_param      = 0
theme.useless_gap         = dpi(0)
theme.widget_border_width = dpi(1)
theme.widget_margin_inner = dpi(2)
theme.widget_margin_outer = dpi(2)

theme.wibar_position = "bottom"
theme.wibar_height = dpi(40)

--[[ button: maximize ]]
theme.titlebar_maximized_button_normal_inactive       = BUTTONS_DIR.."maximize_normal.png"
theme.titlebar_maximized_button_focus_inactive        = BUTTONS_DIR.."maximize_normal.png"
theme.titlebar_maximized_button_normal_inactive_press = BUTTONS_DIR.."maximize_pressed.png"
theme.titlebar_maximized_button_focus_inactive_press  = BUTTONS_DIR.."maximize_pressed.png"

--[[ button: un-maximize ]]
theme.titlebar_maximized_button_normal_active         = BUTTONS_DIR.."restore_normal.png" -- TODO: fix path
theme.titlebar_maximized_button_focus_active          = BUTTONS_DIR.."restore_normal.png" -- TODO: fix path
theme.titlebar_maximized_button_normal_active_press   = BUTTONS_DIR.."restore_pressed.png"
theme.titlebar_maximized_button_focus_active_press    = BUTTONS_DIR.."restore_pressed.png"

--[[ button: minimize ]]
theme.titlebar_minimize_button_normal                 = BUTTONS_DIR.."minimize_normal.png"
theme.titlebar_minimize_button_focus                  = BUTTONS_DIR.."minimize_normal.png"
theme.titlebar_minimize_button_normal_press           = BUTTONS_DIR.."minimize_normal.png"
theme.titlebar_minimize_button_focus_press            = BUTTONS_DIR.."minimize_normal.png"

--[[ button: close ]]
theme.titlebar_close_button_normal                    = BUTTONS_DIR.."close_normal.png"
theme.titlebar_close_button_focus                     = BUTTONS_DIR.."close_normal.png"
theme.titlebar_close_button_focus_press               = BUTTONS_DIR.."close_pressed.png"
theme.titlebar_close_button_normal_press              = BUTTONS_DIR.."close_pressed.png"


--[[ Icons that are used in widgets ]]
-- TODO: Add clippy icon to use with Rofi!
theme.awesome_icon        = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.brightness_icon     = theme.ICON_DIR.."notifications/48/notification-display-brightness-full.png"
theme.brightness_icon_red = theme.ICON_DIR.."notification-display-brightness-red.png" -- TODO: maybe move to better location?
theme.camera_icon         = theme.ICON_DIR.."devices/scalable/camera-photo.svg" -- INFO: Check if svg are accepted, or if png is needed
theme.disk_icon           = theme.ICON_DIR.."devices/scalable/drive-harddisk.svg"
theme.edit_icon           = theme.ICON_DIR.."actions/scalable/gtk-edit.svg"
theme.error_icon          = theme.ICON_DIR.."status/scalable/dialog-error.svg"
theme.exit_icon           = theme.ICON_DIR.."actions/scalable/application-exit.svg"
theme.help_icon           = theme.ICON_DIR.."apps/48/help-browser.png"
theme.home_icon           = theme.ICON_DIR.."misc/windows.png"
theme.hotkeys_icon        = theme.ICON_DIR.."actions/scalable/document-properties.svg"
theme.info_icon           = theme.ICON_DIR.."status/scalable/dialog-information.svg"
theme.lock_icon           = theme.ICON_DIR.."actions/scalable/system-lock-screen.svg"
theme.poweroff_icon       = theme.ICON_DIR.."actions/scalable/system-shutdown.svg" -- TODO: find a more suitable icon
theme.question_icon       = theme.ICON_DIR.."status/scalable/dialog-question.svg"
theme.reboot_icon         = theme.ICON_DIR.."actions/scalable/system-reboot.svg"
theme.restart_icon        = theme.ICON_DIR.."actions/scalable/view-refresh.svg"
theme.run_icon            = theme.ICON_DIR.."actions/scalable/system-run.svg"
theme.search_icon         = theme.ICON_DIR.."actions/scalable/system-search.svg"
theme.sound_icon          = theme.ICON_DIR.."status/scalable/audio-volume-high.svg"
theme.sound_icon_mute     = theme.ICON_DIR.."status/scalable/audio-volume-muted.svg"
theme.submenu_icon        = theme.ICON_DIR.."notifications/48/notification-icon-play.png"
theme.warning_icon        = theme.ICON_DIR.."status/scalable/dialog-warning.svg"


-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path.."default/layouts/fairh.png"
theme.layout_fairv      = themes_path.."default/layouts/fairv.png"
theme.layout_floating   = themes_path.."default/layouts/floating.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifier.png"
theme.layout_max        = themes_path.."default/layouts/max.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreen.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottom.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleft.png"
theme.layout_tile       = themes_path.."default/layouts/tile.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletop.png"
theme.layout_spiral     = themes_path.."default/layouts/spiral.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindle.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernw.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornerne.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersw.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornerse.png"


--[[ Generate taglist squares ]]
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_shape_border_width_focus = dpi(1)
theme.taglist_shape_border_color_focus = theme.border_focus

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
                gears.shape.rectangle(cr, width, height)
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
