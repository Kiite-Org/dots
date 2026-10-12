local vars = require("variables")
require("hypr-unbinds")

-- Grayscale config
hl.config({
    decoration = {
        -- screen_shader = "~/.config/caelestia/grayscale.glsl",
        screen_shader = "",
    },
})

-- Custom execs
hl.on("hyprland.start", function()
    -- Auto-Start setup
    -- hl.exec_cmd("sleep 2 && caelestia shell lock lock")
    hl.exec_cmd("wluma -c ~/.config/wluma/config.toml")
    hl.exec_cmd("arch-update --tray")
    hl.exec_cmd("/home/chujo/.config/caelestia/scripts/launch_overview.sh")
    hl.exec_cmd("/home/chujo/.config/caelestia/scripts/copy.sh")
    hl.exec_cmd("hyprpm reload -n")
end)

-- Monitor Setup
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = "1.33",
})

hl.monitor({
    output = "DP-4",
    mode = "preferred",
    -- mode = "1680x1050@60",
    position = "auto-left",
    scale = 1,
    -- mirror = "eDP-1"
})

hl.monitor({
    output = "DP-3",
    mode = "preferred",
    position = "auto-left",
    scale = "1",
})

-- Gestures
hl.gesture({
    fingers = vars.gestureFingers,
    direction = "up",
    action = function()
        hl.exec_cmd("caelestia shell hypr cycleSpecialWorkspace prev")
    end,
})

hl.gesture({
    fingers = vars.gestureFingers,
    direction = "up",
    mods = "ALT + SHIFT",
    action = function()
        hl.dispatch(hl.dsp.window.move({ workspace = "special:special" }))
    end,
})

hl.gesture({
    fingers = vars.gestureFingers,
    direction = "down",
    mods = "ALT + SHIFT",
    action = function()
        hl.dispatch(hl.dsp.window.move({ workspace = "e+0" }))
    end,
})

hl.gesture({
    fingers = vars.gestureFingers,
    direction = "up",
    mods = "SUPER",
    action = function()
        hl.dispatch(hl.dsp.layout("cyclenext"))
    end,
})

hl.gesture({
    fingers = vars.gestureFingers,
    direction = "down",
    mods = "SUPER",
    action = function()
        hl.dispatch(hl.dsp.layout("cycleprev"))
    end,
})

hl.gesture({
    fingers = vars.gestureFingers,
    direction = "swipe",
    action = "move",
})

hl.gesture({
    fingers = vars.gestureFingersMore,
    direction = "pinchin",
    action = function()
        -- hl.exec_cmd("~/.config/caelestia/scripts/finger_gesture.sh outward")
        local active_win = hl.get_active_window()
        if active_win ~= nil then
            -- If not floating and not fullscreen already
            if active_win.fullscreen == 0 and not active_win.floating then
                hl.dispatch(hl.dsp.window.fullscreen({mode="fullscreen", action="toggle"}))
            -- If floating
            elseif active_win.floating then
                hl.dispatch(hl.dsp.window.float({action="toggle"}))
            end 
        end
    end,
})

hl.gesture({
    fingers = vars.gestureFingersMore,
    direction = "pinchout",
    action = function()
        -- hl.exec_cmd("~/.config/caelestia/scripts/finger_gesture.sh inward")
        local active_win = hl.get_active_window()
        if active_win ~= nil then
            -- If fullscreen in some way and not floating
            if active_win.fullscreen > 0 and not active_win.floating then
                hl.dispatch(hl.dsp.window.fullscreen({mode="fullscreen", action="unset"}))
            elseif active_win.fullscreen == 0 and not active_win.floating then
                hl.dispatch(hl.dsp.window.float({action="toggle"}))
            end
        end
    end,
})

hl.gesture({
    fingers = vars.gestureFingersMore,
    direction = "up",
    action = function()
        hl.exec_cmd("qs ipc -c overview call overview toggle")
        -- hl.exec_cmd("caelestia shell overview toggle")
    end,
})

hl.gesture({
    fingers = vars.gestureFingersMore,
    direction = "down",
    action = function()
        hl.exec_cmd("qs ipc -c overview call overview toggle")
        -- hl.exec_cmd("caelestia shell overview toggle")
    end,
})

-- Keyboard Input
hl.config({ input = {
    kb_layout = "us,ca",
    kb_options = "grp:win_space_toggle",
} })

-- Custom Keybinds
-- Closing lid
-- When the lid is CLOSED (Switch turns ON)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/lid-dpms.sh"), {
    locked = true,
})

-- When the lid is OPENED (Switch turns OFF)
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/lid-dpms.sh"), {
    locked = true,
})

-- hl.bind("CTRL + ALT + SUPER + R", hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/reload_caelestia.sh"))

hl.bind("SUPER + ALT + RIGHT", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + ALT + LEFT", hl.dsp.window.move({ workspace = "-1" }))

hl.bind("SUPER + TAB", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))
-- hl.bind("SUPER + TAB", hl.dsp.exec_cmd("caelestia shell overview toggle"))

hl.bind("CTRL + SUPER + UP", hl.dsp.exec_cmd("caelestia shell hypr cycleSpecialWorkspace prev"))
hl.bind("CTRL + SUPER + DOWN", hl.dsp.exec_cmd("caelestia shell hypr cycleSpecialWorkspace next"))

-- Bind for the grayscale toggle
hl.bind("SUPER + F12", function()
    local shader = hl.get_config("decoration.screen_shader")
    if shader == "" or shader == "[[EMPTY]]" then
        hl.exec_cmd(
            [[hyprctl eval 'hl.config({ decoration = { screen_shader = "]]
                .. os.getenv("HOME")
                .. [[/.config/caelestia/grayscale.glsl" } })']]
        )
    else
        hl.exec_cmd([[hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })']])
    end
end)

-- Scrolling layout fit active window
hl.bind("SUPER + ALT + X", hl.dsp.layout("fit active"))

-- Monocle keybinds
hl.bind("SUPER + UP", hl.dsp.layout("cyclenext"))
hl.bind("SUPER + DOWN", hl.dsp.layout("cycleprev"))

-- Workspace keybinds
hl.bind(vars.kbSteamWs, hl.dsp.exec_cmd("caelestia toggle steam"))
hl.bind(vars.kbOnTogetherWs, hl.dsp.exec_cmd("caelestia toggle on_together"))
hl.bind(vars.kbCalendar, hl.dsp.exec_cmd("caelestia toggle google"))

-- Utilities keybinds
hl.bind(vars.kbSettings, hl.dsp.exec_cmd("caelestia shell nexus open"))
hl.bind(vars.kbKeepAwake, hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/toggle_keepawake.sh"))
hl.bind(vars.kbRandomWallpaper, hl.dsp.exec_cmd("caelestia wallpaper -r"))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/snip_to_search.sh"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("/home/chujo/.config/caelestia/scripts/snip_to_select.sh"))
hl.bind("SUPER + SHIFT + CTRL + S", hl.dsp.global("caelestia:screenshotFreezeClip"))
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))

hl.bind(vars.kbClipboard, hl.dsp.exec_cmd("stowaway --toggle"))
hl.bind(vars.kbEmoji, hl.dsp.exec_cmd("stowaway --emoji"))
-- Workspace Rules
hl.workspace_rule({ workspace = "special:special", layout = "scrolling" })
hl.workspace_rule({ workspace = "special:communication", layout = "monocle" })
hl.workspace_rule({ workspace = "special:music", layout = "monocle" })
hl.workspace_rule({ workspace = "special:sysmon", layout = "monocle" })

-- Window Rules
hl.window_rule({ match = { class = "^kitty$" }, fullscreen = false, fullscreen_state = 0 })
hl.window_rule({ match = { class = "^(Zoom)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^Chat$" }, float = true })

hl.window_rule({ match = { class = "^(slack|com.rtosta.zapzap)$" }, workspace = "special:communication" })
hl.window_rule({ match = { class = "(thunar|atlas)", workspace = "special:communication" }, float = true, size = { 1200, 800 } })

hl.window_rule({ match = { class = "Todoist|cohesion|obsidian" }, workspace = "special:todo" })

hl.window_rule({ match = { initial_title = "On-Together" }, workspace = "special:on_together" })
hl.window_rule({
    match = {
        class = "steam_app_3707400",
    },
    float = true,
    fullscreen = false,
    fullscreen_state = 0,
    suppress_event = "fullscreen fullscreenoutput",
    size = { 800, 600 },
    no_blur = true,
    opaque = false,
    rounding = 0,
    border_size = 0,
    no_anim = true,
    tag = "+hyprglass_disabled",
})

hl.window_rule({
    match = {
        class = "Routine"
    },
    fullscreen = true,
    fullscreen_state = "0 2",
    workspace = "special:google"
})


hl.window_rule({
    match = { title = ".*Atlas File Picker.*" },
    float = true,
    center = true,
    size = {1000, 620},
})

hl.window_rule({
    match = {class = "wormhole"},
    float = true,
    center = true,
    size = {1000, 620}
})

hl.layer_rule({
    match = {
        namespace = "stowaway",
    },
    no_anim = true,
})

-- Plugins
if hl.plugin.dynamic_cursors then
    hl.config({ plugin = { dynamic_cursors = {
        enabled = true,
        mode = "none",
    } } })

    -- Add a keybind to zoom into the mouse
    hl.bind(vars.kbZoomMouse, hl.plugin.dynamic_cursors.dsp_magnify({ duration = 2000, size = 5.0 }))
end

if hl.plugin.seam then
hl.config({
    -- general = { gaps_in = 0, gaps_out = 0 },
    decoration = { rounding = 0 },
    plugin = {
        seam = {
            enabled = true,
            rounding = vars.windowSeamRounding,
            rounding_power = vars.windowRoundingPower,
            round_borders = true,
            round_shadows = true,
            seam_radius = 2,
            animate = true,
            animation_speed = 300,
            force_round_risky_surfaces = true
        },
    },
})
hl.plugin.seam.rule({class="^(discord|slack|com.rtosta.zapzap)$", seam=false})
-- hl.plugin.seam.rule({class="discord", seam=false})
end