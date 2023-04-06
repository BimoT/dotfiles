--      _                       _             
--     | |                     | |            
--   __| | __ _ _   _ _ __ __ _| |_ _   _ ___ 
--  / _` |/ _` | | | | '__/ _` | __| | | / __|
-- | (_| | (_| | |_| | | | (_| | |_| |_| \__ \
--  \__,_|\__,_|\__,_|_|  \__,_|\__|\__,_|___/
--                                            
-- A green and black theme for AwesomeWM

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

theme.font      = "Helvetica Bold 12"
theme.font_base = "Helvetica"
theme.font_bold = "Helvetica Bold"

theme.bg_normal   = "#000000"
theme.bg_focus    = "#008000"
theme.bg_urgent   = "#000000"
theme.bg_minimize = "#000000"
theme.bg_systray  = "#000000"

theme.fg_normal   = "#008000"
theme.fg_focus    = "#000000"
theme.fg_urgent   = "#ff0000"
theme.fg_minimize = "#000000"

theme.border_normal = "#000000"
theme.border_focus  = "#008000"
theme.border_marked = "#008000"
theme.border_urgent = "#ff0000"

--[[ true/false ENV variables ]]
theme.want_client_borders = false
theme.want_icon_widgets = true

--[[ Tasklist colors ]]
theme.tasklist_bg_focus  = theme.bg_focus
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_focus  = theme.fg_focus
theme.tasklist_fg_normal = theme.fg_normal

theme.border_width        = dpi(4)
theme.menu_height         = dpi(30)
theme.menu_width          = dpi(150)
theme.rounding_param      = 0
theme.useless_gap         = dpi(2)
theme.widget_border_width = dpi(1)
theme.widget_margin_inner = dpi(2)
theme.widget_margin_outer = dpi(2)
theme.wibar_height        = dpi(35)
theme.wibar_position      = "top"
theme.titlebar_height     = dpi(30)

theme.wallpaper = "~/Pictures/dauratus_wallpaper.png"
theme.lockscreen_wallpaper = "" -- TODO: create new wallpaper for lockscreen

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
