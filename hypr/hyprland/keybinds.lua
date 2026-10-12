local vars = require("variables")
local descs = require("descriptions")
local fn   = require("utils.functions")


-- Flags
local locked           = { locked = true }
local mouse            = { mouse = true }
local release          = { release = true }
local repeating        = { repeating = true }
local locked_repeating = { locked = true, repeating = true }

local function normalise_keybind(key)
    return key:gsub("%s+", ""):lower()
end

local function valid_keybind(key)
    return type(key) == "string" and key:match("%S") ~= nil
end

local function repeating_unless_mouse(key)
    return not normalise_keybind(key):find("mouse", 1, true) and repeating or nil
end

local function flatten_keybinds(keybinds, keys)
    keys = keys or {}

    if type(keybinds) == "table" then
        for _, keybind in pairs(keybinds) do
            flatten_keybinds(keybind, keys)
        end
    elseif valid_keybind(keybinds) then
        keys[#keys + 1] = keybinds
    end

    return keys
end

local function create_bind(keybinds, action, description, flags)
    if type(description) ~= "string" then
        -- Allow to create_bind without description
        if flags == nil then
            flags = description
        end
        description = nil
    end
    local get_flags = type(flags) == "function" and flags or function()
        return flags
    end
    local desc_opts = description and {description = description} or nil

    for _, key in ipairs(flatten_keybinds(keybinds)) do
        local final_flags = fn.merge(get_flags(key), desc_opts)
        hl.bind(key, action, final_flags)
    end
end

local function extend_keybind(base, suffix)
    return valid_keybind(base) and base .. " + " .. suffix or nil
end

local function kiite(ipc_call)
    local str = string.gsub("kiite ipc $call", "%$(%w+)", {call= ipc_call})
    return hl.dsp.exec_cmd(str)
end

-- Launcher
local launcher_default = normalise_keybind("SUPER + SUPER_L")
create_bind(
    vars.kbLauncher,
    kiite("launcher toggle"),
    descs.kbLauncher,
    function(key)
        return normalise_keybind(key) == launcher_default and release or nil
    end
)

-- Misc
create_bind(vars.kbSession, kiite("session toggle"), descs.kbSession)
create_bind(vars.kbShowSidebar, kiite("sidebarRight toggle"), descs.kbShowSidebar)
-- create_bind(vars.kbClearNotifs, hl.dsp.global("caelestia:clearNotifs"), locked)
create_bind(vars.kbShowPanels, function ()
    hl.dispatch(kiite("sidebarLeft toggle"))
    hl.dispatch(kiite("sidebarRight toggle"))
end, descs.kbShowPanels)
create_bind(vars.kbLock, kiite("lock activate"), descs.kbLock)

-- Restore lock
create_bind(vars.kbRestoreLock, function()
    hl.dispatch(hl.dsp.exec_cmd("kiite"))
    hl.dispatch(kiite("lock activate"))
end, descs.kbRestoreLock)

-- Kill/restart
-- create_bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("pkill kiite"), release)
create_bind(vars.kbKill, hl.dsp.exec_cmd("pkill kiite"), descs.kbKill, release)
create_bind(
    vars.kbReload,
    hl.dsp.exec_cmd("pkill kiite; sleep .1; kiite"),
    descs.kbReload,
    release
)

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    create_bind(extend_keybind(vars.kbGoToWs, key), fn.wsaction("focus", "", i), descs.kbGoToWs)
    create_bind(extend_keybind(vars.kbMoveWinToWs, key), fn.wsaction("move", "", i), descs.kbMoveWinToWs)
    create_bind(extend_keybind(vars.kbGoToWsGroup, key), fn.wsaction("focus", "group", i), descs.kbGoToWsGroup)
    create_bind(extend_keybind(vars.kbMoveWinToWsGroup, key), fn.wsaction("move", "group", i), descs.kbMoveWinToWsGroup)
end

-- Go to workspace -1/+1
create_bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), descs.kbPrevWs, repeating_unless_mouse)
create_bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), descs.kbNextWs, repeating_unless_mouse)

-- Go to workspace group -1/+1
create_bind(vars.kbPrevWsGroup, hl.dsp.focus({ workspace = "-10" }), descs.kbPrevWsGroup, repeating_unless_mouse)
create_bind(vars.kbNextWsGroup, hl.dsp.focus({ workspace = "+10" }), descs.kbNextWsGroup, repeating_unless_mouse)

-- Move window to workspace -1/+1
create_bind(vars.kbMoveWinToWsNext, hl.dsp.window.move({ workspace = "+1" }), descs.kbMoveWinToWsNext, repeating_unless_mouse)
create_bind(vars.kbMoveWinToWsPrev, hl.dsp.window.move({ workspace = "-1" }), descs.kbMoveWinToWsPrev, repeating_unless_mouse)

-- Move window to/from special workspace
create_bind(vars.kbMoveWinToWsSpecial, hl.dsp.window.move({ workspace = "special:special" }), descs.kbMoveWinToWsSpecial)
create_bind(vars.kbMoveWinFromWsSpecial, hl.dsp.window.move({ workspace = "e+0" }), descs.kbMoveWinFromWsSpecial)

-- Window groups
create_bind(vars.kbWindowCycleNext, hl.dsp.window.cycle_next(), descs.kbWindowCycleNext, repeating)
create_bind(vars.kbWindowCyclePrev, hl.dsp.window.cycle_next({ next = false }), descs.kbWindowCyclePrev, repeating)
create_bind(vars.kbWindowGroupCycleNext, hl.dsp.group.next(), descs.kbWindowGroupCycleNext, repeating)
create_bind(vars.kbWindowGroupCyclePrev, hl.dsp.group.prev(), descs.kbWindowGroupCyclePrev, repeating)
create_bind(vars.kbToggleGroup, hl.dsp.group.toggle(), descs.kbToggleGroup)
create_bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }), descs.kbUngroup)
create_bind(vars.kbGroupLockActive, hl.dsp.group.lock_active(), descs.kbGroupLockActive)

-- Window actions
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    create_bind(extend_keybind(vars.kbFocus, dir), hl.dsp.focus({ direction = dir }), descs.kbFocus)
    create_bind(extend_keybind(vars.kbMove, dir), hl.dsp.window.move({ direction = dir }))
end

create_bind(vars.kbWindowDecreaseWidth, fn.resize_active_window(-10, 0), descs.kbWindowDecreaseWidth, repeating)
create_bind(vars.kbWindowIncreaseWidth, fn.resize_active_window(10, 0), descs.kbWindowIncreaseWidth, repeating)
create_bind(vars.kbWindowDecreaseHeight, fn.resize_active_window(0, -10), descs.kbWindowDecreaseHeight, repeating)
create_bind(vars.kbWindowIncreaseHeight, fn.resize_active_window(0, 10), descs.kbWindowIncreaseHeight, repeating)

create_bind({ vars.kbMoveWindow, "SUPER + mouse:272" }, hl.dsp.window.drag(), descs.kbMoveWindow, mouse)
create_bind({ vars.kbResizeWindow, "SUPER + mouse:273" }, hl.dsp.window.resize(), descs.kbResizeWindow, mouse)
create_bind(vars.kbCenterWindow, hl.dsp.window.center(), descs.kbCenterWindow)
create_bind(vars.kbNormalizeWindow, function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
    hl.dispatch(hl.dsp.window.center())
end, descs.kbNormalizeWindow)
create_bind(vars.kbWindowPip, function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end, descs.kbWindowPip)
create_bind(vars.kbPinWindow, hl.dsp.window.pin(), descs.kbPinWindow)
create_bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }), descs.kbWindowFullscreen)
create_bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }), descs.kbWindowBorderedFullscreen)
create_bind(vars.kbToggleWindowFloating, hl.dsp.window.float())
create_bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Special workspace toggles
create_bind(vars.kbSpecialWs, fn.toggle("specialws"), descs.kbSpecialWs)
create_bind(vars.kbSystemMonitorWs, fn.toggle("sysmon"), descs.kbSystemMonitorWs)
create_bind(vars.kbMusicWs, fn.toggle("music"), descs.kbMusicWs)
create_bind(vars.kbCommunicationWs, fn.toggle("communication"), descs.kbCommunicationWs)
create_bind(vars.kbTodoWs, fn.toggle("todo"), descs.kbTodoWs)

-- Apps
create_bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal), descs.kbTerminal)
create_bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser), descs.kbBrowser)
create_bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor), descs.kbEditor)
create_bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer), descs.kbFileExplorer)
create_bind(vars.kbAudioSettings, hl.dsp.exec_cmd(vars.audioSettings), descs.kbAudioSettings)

-- Utilities
create_bind(vars.kbScreenshot, kiite("region screenshot"), descs.kbScreenshot, locked)
create_bind(vars.kbScreenshotFreeze, kiite("region screenshot"), descs.kbScreenshotFreeze)
create_bind(vars.kbScreenshotRegion, kiite("region screenshot"), descs.kbScreenshotRegion)
create_bind(vars.kbRecord, kiite("recorder screen"), descs.kbRecord)
create_bind(vars.kbRecordSound, kiite("recorder screenWithSound"), descs.kbRecordSound)
create_bind(vars.kbRecordRegion, kiite("recorder region"), descs.kbRecordRegion)
create_bind(vars.kbColorPicker, hl.dsp.exec_cmd("hyprpicker -a"), descs.kbColorPicker)
create_bind(vars.kbOverview, kiite("overview toggle"), descs.kbOverview)
create_bind(vars.kbCheatSheet, kiite("cheatsheet toggle"), descs.kbCheatSheet)
create_bind(vars.kbSettings, kiite("settings open"), descs.kbSettings)

-- Brightness
create_bind("XF86MonBrightnessUp", kiite("brightness increment"), descs.kbBrightnessUp, locked)
create_bind("XF86MonBrightnessDown", kiite("brightness decrement"), descs.kbBrightnessDown, locked)

-- Media
create_bind({ vars.kbMediaToggle, "XF86AudioPlay", "XF86AudioPause" }, kiite("mpris playPause"), descs.kbMediaToggle, locked)
create_bind({ vars.kbMediaNext, "XF86AudioNext" }, kiite("mpris next"), descs.kbMediaNext, locked)
create_bind({ vars.kbMediaPrev, "XF86AudioPrev" }, kiite("mpris previous"), descs.kbMediaPrev, locked)
create_bind({ vars.kbMediaStop, "XF86AudioStop" }, kiite("mpris pauseAll"), descs.kbMediaStop, locked)

-- Volume
create_bind({ vars.kbVolumeMute, "XF86AudioMute" }, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), descs.kbVolumeMute, locked)
create_bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
create_bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l " ..
        (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
    ),
    locked_repeating
)
create_bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%-"
    ),
    locked_repeating
)

-- Sleep
create_bind(vars.kbSleep, hl.dsp.exec_cmd(vars.sleepGestureCmd), descs.kbSleep, locked)

-- Clipboard and emoji picker
create_bind(vars.kbClipboard, kiite("picker clipboard"), descs.kbClipboard)
-- create_bind(vars.kbClipboardDel, hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
create_bind(vars.kbEmoji, kiite("picker emoji"), descs.kbEmoji)
-- create_bind(
--     vars.kbClipboardPasteLatest,
--     hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
--     locked
-- )

-- Testing
create_bind(
    "SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "notify-send -u low -i dialog-information-symbolic 'Test notification' " ..
        [["Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]] ..
        " -a 'Shell' -A 'Test1=I got it!' -A 'Test2=Another action'"
    ),
    "Test: Send notification"
)
