return {
    -- Modifier only, the actual binds will be mod + 0-9. These should be strings and not arrays.
    kbGoToWs                   = "Modifier: Go to workspace",
    kbGoToWsGroup              = "Modifier: Go to workspace group",
    kbMoveWinToWs              = "Modifier: Move window to workspace",
    kbMoveWinToWsGroup         = "Modifier: Move window to workspace group",

    -- All the following binds can be either an array of binds to bind multiple keys, or a single string.

    -- Workspaces
    kbMoveWinToWsSpecial       = "Workspace: Move window to special workspace",
    kbMoveWinFromWsSpecial     = "Workspace: Remove window from special workspace",
    kbMoveWinToWsNext          = "Workspace: Move window to the next workspace",
    kbMoveWinToWsPrev          = "Workspace: Move window to the previous workspace",
    kbNextWs                   = "Workspace: Go to next workspace",
    kbPrevWs                   = "Workspace: Go to previous workspace",
    kbNextWsGroup              = "Workspace: Go to next workspace group",
    kbPrevWsGroup              = "Workspace: Go to previous workspace group",

    -- Window Group
    kbWindowCycleNext          = "Window Groups: Cycle to next window",
    kbWindowCyclePrev          = "Window Groups: Cycle to previous window",
    kbWindowGroupCycleNext     = "Window Groups: Cycle to next window in group",
    kbWindowGroupCyclePrev     = "Window Groups: Cycle to previous window in group",
    kbUngroup                  = "Window Groups: Ungroup windows",
    kbToggleGroup              = "Window Groups: Group windows",
    kbGroupLockActive          = "Window Groups: Lock active window group",

    -- Window Actions
    kbWindowDecreaseWidth      = "Window Actions: Decrease window width",
    kbWindowIncreaseWidth      = "Window Actions: Increase window width",
    kbWindowDecreaseHeight     = "Window Actions: Decrease window height",
    kbWindowIncreaseHeight     = "Window Actions: Increase window height",

    kbMoveWindow               = "Window Actions: Grab and move window",
    kbResizeWindow             = "Window Actions: Resize window",
    kbCenterWindow             = "Window Actions: Center active window",
    kbNormalizeWindow          = "Window Actions: Normalize active window size",
    kbWindowPip                = "Window Actions: Enable Picture-in-Picture mode",
    kbPinWindow                = "Window Actions: Pin window on top",
    kbWindowFullscreen         = "Window Actions: Toggle bordered fullscreen window",
    kbWindowBorderedFullscreen = "Window Actions: Toggle fullscreen window",
    kbToggleWindowFloating     = "Window Actions: Toggle floating window",
    kbCloseWindow              = "Window Actions: Close active window",

    -- Special workspaces toggles
    kbSpecialWs                = "Special Workspaces: Open special workspace",
    kbSystemMonitorWs          = "Special Workspaces: Open system monitor",
    kbMusicWs                  = "Special Workspaces: Open music workspace",
    kbCommunicationWs          = "Special Workspaces: Open communication workspace",
    kbTodoWs                   = "Special Workspaces: Open todo workspace",

    -- Apps
    kbTerminal                 = "Apps: Open terminal",
    kbBrowser                  = "Apps: Open browser",
    kbEditor                   = "Apps: Open editor",
    kbFileExplorer             = "Apps: Open file explorer",
    kbAudioSettings            = "Apps: Open audio settings",

    -- Utilities
    kbScreenshot               = "Screenshot & Recording: Take fullscreen screenshot",
    kbScreenshotFreeze         = "Screenshot & Recording: Take screenshot",
    kbScreenshotRegion         = "Screenshot & Recording: Take region screenshot",
    kbRecord                   = "Screenshot & Recording: Record",
    kbRecordSound              = "Screenshot & Recording: Record with sound",
    kbRecordRegion             = "Screenshot & Recording: Record region",
    kbColorPicker              = "Utilities: Open color picker",
    kbOverview                 = "Utilities: Open overview",
    kbCheatSheet               = "Utilities: Open the cheatsheet",
    kbBrightnessUp             = "Brightness: Increase",
    kbBrightnessDown           = "Brightness: Decrease",

    -- Media
    kbMediaToggle              = "Media: Toggle music player",
    kbMediaNext                = "Media: Skip to next song",
    kbMediaPrev                = "Media: Rewind to previous song",
    kbMediaStop                = "Media: Stop music player",
    kbVolumeMute               = "Media: Mute music player",

    -- Misc
    kbLauncher                 = "General: Open launcher",
    kbSession                  = "General: Show session controls",
    kbShowSidebar              = "General: Open notification panel",
    kbClearNotifs              = "General: Clear all notifications",
    kbShowPanels               = "General: Show all panels",
    kbLock                     = "General: Lock session",
    kbRestoreLock              = "General: Restore lock session",
    kbSleep                    = "General: Sleep",
    kbKill                     = "General: Kills the shell",
    kbReload                   = "General: Reload the shell",
    kbFocus                    = "General: Focus window",
    kbMove                     = "General: Move window",

    -- Clipboard and emoji picker
    kbClipboard                = "Utilities: Open clipboard",
    kbClipboardDel             = "Utilities: Delete from clipboard",
    kbClipboardPasteLatest     = "Utilities: Paste latest from clipboard",
    kbEmoji                    = "Utilities: Open emoji picker",

}