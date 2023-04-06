local client, awesome = client, awesome

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local signaling = require("signaling")
local apps = require("extras.apps")
local helpers = require("extras.helpers")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

local keys = {}

local superkey = "Mod4"
local altkey = "Mod1"

--[[ Mouse buttons for the desktop]]
keys.desktopbuttons = gears.table.join(
    awful.button({ }, 3, naughty.destroy_all_notifications()),
    --[[ Scrolling ]]
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)

--[[ Mouse buttons on the whole client ]]
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),
    awful.button({ superkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),
    awful.button({ superkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end),
    --[[ super + scroll: change opacity ]]
    awful.button({ superkey }, 4,
        function (c)
            c.opacity = c.opacity + 0.1
        end),
    awful.button({ superkey }, 5,
        function (c)
            c.opacity = c.opacity - 0.1
        end)
)

keys.smalltag_buttons = gears.table.join(
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

--[[ Mouse buttons for the taglist ]]
keys.taglist_buttons = gears.table.join(
    awful.button({ }, 1,
        function(t)
            helpers.tag_back_and_forth(t.index)
        end),
    awful.button({ superkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({ }, 3,
        -- awful.tag.viewtoggle),
        function (t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({ superkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
    awful.button({ }, 4,
        function(t)
            awful.tag.viewnext(t.screen)
        end),
    awful.button({ }, 5,
        function(t)
            awful.tag.viewprev(t.screen)
        end)
)

--[[ Mouse buttons on tasklist ]]
keys.tasklist_buttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end),
    --[[ Middle mouse button click ]]
    awful.button({ }, 2,
        function (c)
            c:kill()
        end
    ),
    awful.button({ }, 3,
        function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
    awful.button({ }, 4,
        function ()
            awful.client.focus.byidx(1)
        end),
    awful.button({ }, 5,
        function ()
            awful.client.focus.byidx(-1)
    end)
)

--[[ Buttons for the titlebar ]]
keys.titlebar_buttons = gears.table.join(
     --[[ Left mouse button: Move ]]
    awful.button({ }, 1, function()
        local c = mouse.object_under_pointer()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
    end),
    --[[ Middle mouse button: Close ]]
    awful.button({ }, 2, function()
        local c = mouse.object_under_pointer()
        c:kill()
    end),
    --[[ Right mouse button: Resize ]]
    awful.button({ }, 3, function()
        local c = mouse.object_under_pointer()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end),
    --[[ Shift + Right mouse button: Resize ]]
    awful.button({ "Shift" }, 3, function()
        local c = mouse.object_under_pointer()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        if not c.floating then c.floating = true end
        awful.mouse.client.resize(c)
    end),
    --[[Shift + Left mouse button: Move + float ]]
    awful.button({ "Shift" }, 1, function ()
        local c = mouse.object_under_pointer()
        client.focus = c
        if not c.floating then c.floating = true end
        awful.mouse.client.move(c)
    end)
)

--[[ Key bindings ]]
keys.globalkeys = gears.table.join(
    --[[ hjkl: focus windows ]]
    awful.key({ superkey }, "h",
        function()
            awful.client.focus.bydirection("left")
        end,
        {description = "focus left window", group = "client"}),
    awful.key({ superkey }, "j",
        function ()
            awful.client.focus.bydirection("down")
        end,
        {description = "focus down window", group = "client"}),
    awful.key({ superkey }, "k",
        function ()
            awful.client.focus.bydirection("up")
        end,
        {description = "focus up window", group = "client"}),
    awful.key({ superkey }, "l",
        function ()
            awful.client.focus.bydirection("right")
        end,
        {description = "focus right window", group = "client"}),

    --[[ Shift + hjkl: swap clients or change number of master clients ]]
    awful.key({ superkey, "Shift" }, "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}),
    awful.key({ superkey, "Shift" }, "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}),
    awful.key({ superkey, "Shift" }, "h",
        function()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({ superkey, "Shift" }, "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}),

    --[[ Ctrl + hjkl: change number of columns or change master width ]]
    awful.key({ superkey, "Control" }, "j",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}),
    awful.key({ superkey, "Control" }, "k",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ superkey, "Control" }, "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}),
    awful.key({ superkey, "Control" }, "l",
        function()
            awful.tag.incmwfact( 0.05)
        end,
        {description = "increase master width factor", group = "layout"}),

    --[[ Audio keys: ]]
    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            signaling.volume.change_volume("up")
        end,
        {description = "volume up 5%", group = "screen"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function()
            signaling.volume.change_volume("down")
        end,
        {description = "volume down 5%", group = "screen"}),
    awful.key({ }, "XF86AudioMute",
        function()
            signaling.volume.toggle_mute()
        end,
        {description = "mute the volume", group = "screen"}),

    --[[ Brightness keys: ]]
    awful.key({ }, "XF86MonBrightnessUp",
        function()
            signaling.brightness.change_brightness("up")
        end,
        {description = "brightness up 5%", group = "screen"}),
    awful.key({ }, "XF86MonBrightnessDown",
        function()
            signaling.brightness.change_brightness("down")
        end,
        {description = "brightness down 5%", group = "screen"}),

    --[[ PrintScreen: takes screenshot ]]
    awful.key({ }, "Print",
        function()
            apps.flameshot_fullscreen()
        end,
        {description = "screenshot", group = "screen"}
    ),

    --[[ Built-in awesomewm functions ]]
    awful.key({ superkey, "Control" }, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ superkey, "Shift" }, "q",
        awesome.quit,
        {description = "quit awesome", group = "awesome"}),
    awful.key({ superkey }, "s",
        function ()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
        {description = "show help", group = "awesome"}),

    --[[ left and right keys: previous/next tag]]
    awful.key({ superkey }, "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ superkey }, "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}),

    --[[ control + left/right: resize client ]]
    awful.key({ superkey, "Control" }, "Left",
        function(c)
            helpers.resize_dwim(client.focus, "left")
        end,
        {description = "resize left", group = "client"}),
    awful.key({ superkey, "Control" }, "Right",
        function(c)
            helpers.resize_dwim(client.focus, "right")
        end,
        {description = "resize right", group = "client"}),
    awful.key({ superkey, "Control" }, "Down",
        function(c)
            helpers.resize_dwim(client.focus, "down")
        end,
        {description = "resize down", group = "client"}),
    awful.key({ superkey, "Control" }, "Up",
        function(c)
            helpers.resize_dwim(client.focus, "up")
        end,
        {description = "resize up", group = "client"}),
    --[[ Escape: previously viewed tag]]
    --TODO: remove? doesn't make sense to bind this to escape
    awful.key({ superkey }, "Escape",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}),

    --[[ u: urgent (or back to last tag) ]]
    awful.key({ superkey }, "u",
        function()
            local uc = awful.client.urgent.get()
            if uc == nil then
                awful.tag.history.restore()
            else
                awful.client.urgent.jumpto()
            end
        end,
        {description = "jump to urgent client", group = "client"}),
    --[[ tab: previously focused window ]]
    awful.key({ superkey }, "Tab",
        -- Switches back and forth, doesn't cycle
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    --[[ space: next layout style ]]
    awful.key({ superkey }, "space",
        function()
            awful.layout.inc( 1)
        end,
        {description = "select next", group = "layout"}),
    --[[ shift + space: previous layout style ]]
    awful.key({ superkey, "Shift" }, "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}),

    awful.key({ superkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "restore minimized", group = "client"}),

    --[[ return: spawn terminal ]]
    awful.key({ superkey }, "Return",
        function()
            apps.launch_terminal()
        end,
        {description = "open a terminal", group = "launcher"}),
    --[[ shift + return: floating terminal ]]
    awful.key({ superkey, "Shift" }, "Return",
        function ()
            apps.launch_floating_terminal()
        end,
        {description = "open a floating terminal", group = "launcher"}),
    --[[ r: launch application ]]
    awful.key({ superkey }, "r",
        function()
            apps.launch_applauncher()
        end,
        {description = "rofi drun", group = "launcher"}),
    --[[ x: lock the screen ]]
    awful.key({ superkey }, "x",
        function ()
            apps.lockscreen()
        end,
        {description = "lock the screen", group = "screen"}),
    --[[ e: file explorer ]]
    awful.key({ superkey }, "e",
        function ()
            apps.launch_filemanager_gui()
        end,
        {description = "open file manager", group = "launcher"}),
    --[[ shift + e: terminal file explorer ]]
    awful.key({ superkey, "Shift" }, "e",
        function ()
            apps.launch_filemanager_tui()
        end,
        {description = "open terminal file manager", group = "launcher"}),
    --[[ b: webbrowser ]]
    awful.key({ superkey }, "b",
        function()
            apps.launch_webbrowser()
        end,
        {description = "open internet browser", group = "launcher"})
)

for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        --[[ View tag only ]]
        awful.key({ superkey }, "#" .. i + 9,
            function ()
                helpers.tag_back_and_forth(i)
                -- local screen = awful.screen.focused()
                -- local tag = screen.tags[i]
                -- if tag then
                --    tag:view_only()
                -- end
            end,
            {description = "view tag #"..i, group = "tag"}),
        --[[ Toggle tag display ]]
        awful.key({ superkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
        --[[ Move client to tag ]]
        awful.key({ superkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),
        --[[ Move all visible clients to tag and focus that tag ]]
        awful.key({ superkey, altkey }, "#" .. i + 9,
            function ()
                local tag = client.focus.screen.tags[i]
                local clients = awful.screen.focused().clients
                if tag then
                    for _, c in pairs(clients) do
                        c:move_to_tag(tag)
                    end
                    tag:view_only()
                end
            end,
            {description = "move all visible clients to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ superkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end
--[[ Clientkeys]]
keys.clientkeys = gears.table.join(
    --[[ Basic client operations (float, maximize, etc.) ]]

    --[[ shift + keypad: move to edge/swap by direction ]]
    awful.key({ superkey, "Shift" }, "Down",
        function (c)
            helpers.move_client_dwim(c, "down")
        end,
        {description = "move client down", group = "client"}),
    awful.key({ superkey, "Shift" }, "Up",
        function (c)
            helpers.move_client_dwim(c, "up")
        end,
        {description = "move client up", group = "client"}),
    awful.key({ superkey, "Shift" }, "Left",
        function (c)
            helpers.move_client_dwim(c, "left")
        end,
        {description = "move client left", group = "client"}),
    awful.key({ superkey, "Shift" }, "Right",
        function (c)
            helpers.move_client_dwim(c, "right")
        end,
        {description = "move client right", group = "client"}),
    --[[ f: fullscreen ]]
    awful.key({ superkey, }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    --[[ shift + f: float]]
    awful.key({ superkey, "Shift" }, "f",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
    --[[ c: center if float ]]
    awful.key({ superkey }, "c",
        function (c)
            awful.placement.centered(c, {honor_workarea = true, honor_padding = true})
        end,
        {description = "center if floating", group = "client"}),
    --[[ shift + c: close ]]
    awful.key({ superkey, "Shift" }, "c",
        function (c)
            c:kill()
        end,
        {description = "close", group = "client"}),
    --[[ ctrl + return: swap current client with master ]]
    awful.key({ superkey, "Control" }, "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}),
    --[[ t: ontop ]]
    awful.key({ superkey }, "t",
        function (c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}),
    --[[ n: minimize ]]
    awful.key({ superkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    --[[ m: maximize ]]
    awful.key({ superkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    --[[ ctrl + m: maximize vertically ]]
    awful.key({ superkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    --[[ shift + m: maximize horizontally]]
    awful.key({ superkey, "Shift" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    --[[ o: opacity ]]
    awful.key({ superkey }, "o",
        function (c)
            c.opacity = c.opacity - 0.1
        end,
        {description = "decrease client opacity", group = "client"}),
    awful.key({ superkey, "Shift" }, "o",
        function (c)
            c.opacity = c.opacity + 0.1
        end,
        {description = "increase client opacity", group = "client"})
)

return keys
