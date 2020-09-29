#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Author: Justin Clareburt (@justcla)
; Created: 26-May-2020

; Notes:
; WinGetPos, X, Y, W, H, A  ; "A" to get the active window's pos.
; MsgBox, The active window is at %X%`,%Y% with width and height [%W%, %H%]

; Hoy Key Symbols
; Symbol	#	= Win (Windows logo key)
; Symbol	!	= Alt
; Symbol	^	= Control
; Symbol	+	= Shift
; Symbol	& = An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.

; ==============================================
; ==== Initialization Section ====
; ==============================================

; #Persistent  ; Keep the script running until the user exits it.

; ====== Define Global variables ======

; Alternative keyboard layouts
SettingsFile = HotkeySettings.ini  ; Alt+Win shortcuts

; Read user-preference for shortcut combinations (each defined in a separate shortcutsDef INI file)
IniRead, ShortcutsFile, %SettingsFile%, General, ShortcutDefs, ShortcutDefs-CtrlWin.ini
; Global settings
IniRead, PixelsPerStep, %SettingsFile%, Settings, PixelsPerStep, 50

InitializeIcon()

InitializeMenu()

InitializeShortcuts(ShortcutsFile)

Return ; End initialization

; ===========================================

InitializeIcon() {
    ; Set the System tray icon
    Menu, Tray, Icon, AltWinHotKeys.ico
}

InitializeMenu() {

    ; Title - link to Help page
    Menu, Tray, Add, About Alt+Win HotKeys, ShowAboutDialog
    ; Settings
    Menu, Tray, Add, Settings, OpenSettings
    ; Edit shortcuts
    Menu, Tray, Add, Edit shortcuts, OpenCurrentShortSet
    Menu, Tray, Add ; separator

    ; HotKey Profiles
    ;       - [x] Alt+Win shortcuts
    Menu, Profiles, Add, Alt+Win shortcuts, SetAltKeysShortcuts
    ;       - [ ] Cltr+Win shortcuts
    Menu, Profiles, Add, Ctrl+Win shortcuts, SetCtrlKeysShortcuts
    Menu, Tray, Add, Shortcut &Profiles, :Profiles
    ; Mark the active profile with a Tick/Check
    Menu, Profiles, Check, Alt+Win shortcuts

    MoveStandardMenuToBottom()
}

SetAltKeysShortcuts() {
    InitializeShortcuts("ShortcutDefs-CtrlWin.ini", true)
    InitializeShortcuts("ShortcutDefs-AltWin.ini")
    Menu, Profiles, Check, Alt+Win shortcuts
    Menu, Profiles, Uncheck, Ctrl+Win shortcuts

    MsgBox Shortcuts profile now using Alt+Win keys
}

SetCtrlKeysShortcuts() {
    InitializeShortcuts("ShortcutDefs-AltWin.ini", true)
    InitializeShortcuts("ShortcutDefs-CtrlWin.ini")
    Menu, Profiles, Uncheck, Alt+Win shortcuts
    Menu, Profiles, Check, Ctrl+Win shortcuts

    MsgBox Shortcuts profile now using Ctrl+Win keys
}

ShowAboutDialog() {
    MsgBox 0, Alt+Win HotKeys, Alt+Win HotKeys - Utility to move and resize windows.`n`n Developed by Justin Clareburt
}

OpenSettings() {
    MsgBox "Open Settings"
}

OpenCurrentShortSet() {
    MsgBox "Open Shortcut definitions file"
}

MoveStandardMenuToBottom() {
    ; Move Standard menu items (ie. Pause/Exit) to the bottom
    Menu, Tray, Add ; Separator
    Menu, Tray, NoStandard
    Menu, Tray, Standard
}

; ------- End Menu Init -----------
; ---------------------------------

InitializeShortcuts(ShortcutsFile, bRemove := false) {

    ; ==== Define the shortcut key combinations ====
    ; Read the shortcut keys from the shortcuts file (or fall back on defaults)

    ;Move
    IniRead, Keys_MoveLeft, %ShortcutsFile%, Shortcuts, Keys_MoveLeft, !#Left
    IniRead, Keys_MoveRight, %ShortcutsFile%, Shortcuts, Keys_MoveRight, !#Right
    IniRead, Keys_MoveUp, %ShortcutsFile%, Shortcuts, Keys_MoveUp, !#Up
    IniRead, Keys_MoveDown, %ShortcutsFile%, Shortcuts, Keys_MoveDown, !#Down
    IniRead, Keys_MoveTop, %ShortcutsFile%, Shortcuts, Keys_MoveTop, !#PgUp
    IniRead, Keys_MoveTop2, %ShortcutsFile%, Shortcuts, Keys_MoveTop2, !#Numpad8
    IniRead, Keys_MoveBottom, %ShortcutsFile%, Shortcuts, Keys_MoveBottom, !#PgDn
    IniRead, Keys_MoveBottom2, %ShortcutsFile%, Shortcuts, Keys_MoveBottom2, !#Numpad2
    IniRead, Keys_MoveHardLeft, %ShortcutsFile%, Shortcuts, Keys_MoveHardLeft, !#Home
    IniRead, Keys_MoveHardLeft2, %ShortcutsFile%, Shortcuts, Keys_MoveHardLeft2, !#Numpad4
    IniRead, Keys_MoveHardRight, %ShortcutsFile%, Shortcuts, Keys_MoveHardRight, !#End
    IniRead, Keys_MoveHardRight2, %ShortcutsFile%, Shortcuts, Keys_MoveHardRight2, !#Numpad6
    IniRead, Keys_MoveTopLeft, %ShortcutsFile%, Shortcuts, Keys_MoveTopLeft, !#Numpad7
    IniRead, Keys_MoveTopRight, %ShortcutsFile%, Shortcuts, Keys_MoveTopRight, !#Numpad9
    IniRead, Keys_MoveBottomLeft, %ShortcutsFile%, Shortcuts, Keys_MoveBottomLeft, !#Numpad1
    IniRead, Keys_MoveBottomRight, %ShortcutsFile%, Shortcuts, Keys_MoveBottomRight, !#Numpad3
    IniRead, Keys_MoveCenter, %ShortcutsFile%, Shortcuts, Keys_MoveCenter, !#Del
    IniRead, Keys_MoveCenter2, %ShortcutsFile%, Shortcuts, Keys_MoveCenter2, !#Numpad5

    ;Resize (only)
    IniRead, Keys_ResizeLeft, %ShortcutsFile%, Shortcuts, Keys_ResizeLeft, !+#Left
    IniRead, Keys_ResizeRight, %ShortcutsFile%, Shortcuts, Keys_ResizeRight, !+#Right
    IniRead, Keys_ResizeUp, %ShortcutsFile%, Shortcuts, Keys_ResizeUp, !+#Up
    IniRead, Keys_ResizeDown, %ShortcutsFile%, Shortcuts, Keys_ResizeDown, !+#Down
    IniRead, Keys_ResizeLarger, %ShortcutsFile%, Shortcuts, Keys_ResizeLarger, !+#PgDn
    IniRead, Keys_ResizeSmaller, %ShortcutsFile%, Shortcuts, Keys_ResizeSmaller, !+#PgUp
    ;Resize and move
    IniRead, Keys_Grow, %ShortcutsFile%, Shortcuts, Keys_Grow, !+#=
    IniRead, Keys_Grow2, %ShortcutsFile%, Shortcuts, Keys_Grow2, !+#NumpadAdd
    IniRead, Keys_Grow3, %ShortcutsFile%, Shortcuts, Keys_Grow3, !#=
    IniRead, Keys_Grow4, %ShortcutsFile%, Shortcuts, Keys_Grow4, !#NumpadAdd
    IniRead, Keys_Grow5, %ShortcutsFile%, Shortcuts, Keys_Grow5, ^#+
    IniRead, Keys_Grow6, %ShortcutsFile%, Shortcuts, Keys_Grow6, ^#NumpadAdd
    IniRead, Keys_Shrink, %ShortcutsFile%, Shortcuts, Keys_Shrink, !+#-
    IniRead, Keys_Shrink2, %ShortcutsFile%, Shortcuts, Keys_Shrink2, !+#NumpadSub
    IniRead, Keys_Shrink3, %ShortcutsFile%, Shortcuts, Keys_Shrink3, !#-
    IniRead, Keys_Shrink4, %ShortcutsFile%, Shortcuts, Keys_Shrink4, !#NumpadSub
    IniRead, Keys_Shrink5, %ShortcutsFile%, Shortcuts, Keys_Shrink5, ^#-
    IniRead, Keys_Shrink6, %ShortcutsFile%, Shortcuts, Keys_Shrink6, ^#NumpadSub
    IniRead, Keys_ResizeHalfScreen, %ShortcutsFile%, Shortcuts, Keys_ResizeHalfScreen, !+#Del
    IniRead, Keys_ResizeThreeQuarterScreen, %ShortcutsFile%, Shortcuts, Keys_ResizeThreeQuarterScreen, !+#Home
    IniRead, Keys_ResizeFullScreen, %ShortcutsFile%, Shortcuts, Keys_ResizeFullScreen, !#Enter
    IniRead, Keys_ResizeFullScreen2, %ShortcutsFile%, Shortcuts, Keys_ResizeFullScreen2, !+#Enter

    IniRead, Keys_RestoreToPreviousPosn, %ShortcutsFile%, Shortcuts, Keys_RestoreToPreviousPosn, !#Backspace
    IniRead, Keys_RestoreToPreviousPosnAndSize, %ShortcutsFile%, Shortcuts, Keys_RestoreToPreviousPosnAndSize, !+#Backspace

    IniRead, Keys_SwitchToPreviousDesktop, %ShortcutsFile%, Shortcuts, Keys_SwitchToPreviousDesktop, "^#,"
    IniRead, Keys_SwitchToNextDesktop, %ShortcutsFile%, Shortcuts, Keys_SwitchToNextDesktop, ^#.
    IniRead, Keys_MoveToPreviousDesktop, %ShortcutsFile%, Shortcuts, Keys_MoveToPreviousDesktop, "^+#,"
    IniRead, Keys_MoveToPreviousDesktop2, %ShortcutsFile%, Shortcuts, Keys_MoveToPreviousDesktop2, ^+#Left
    IniRead, Keys_MoveToNextDesktop, %ShortcutsFile%, Shortcuts, Keys_MoveToNextDesktop, ^+#.
    IniRead, Keys_MoveToNextDesktop2, %ShortcutsFile%, Shortcuts, Keys_MoveToNextDesktop2, ^+#Right

    IniRead, Keys_TileWindowsVertically, %ShortcutsFile%, Shortcuts, Keys_TileWindowsVertically, !#V
    IniRead, Keys_TileWindowsVertically2, %ShortcutsFile%, Shortcuts, Keys_TileWindowsVertically2, !+#V
    IniRead, Keys_TileWindowsHorizontally, %ShortcutsFile%, Shortcuts, Keys_TileWindowsHorizontally, !#H
    IniRead, Keys_TileWindowsHorizontally2, %ShortcutsFile%, Shortcuts, Keys_TileWindowsHorizontally2, !+#H
    IniRead, Keys_CascadeWindows, %ShortcutsFile%, Shortcuts, Keys_CascadeWindows, !#C
    IniRead, Keys_CascadeWindows2, %ShortcutsFile%, Shortcuts, Keys_CascadeWindows2, !+#C

    ; Link the shortcuts with the corresponding actions

    ; "Move" commands
    SetHotkeyAction(Keys_MoveLeft, "MoveLeft", bRemove)
    SetHotkeyAction(Keys_MoveRight, "MoveRight", bRemove)
    SetHotkeyAction(Keys_MoveUp, "MoveUp", bRemove)
    SetHotkeyAction(Keys_MoveDown, "MoveDown", bRemove)
    SetHotkeyAction(Keys_MoveTop, "MoveTop", bRemove)
    SetHotkeyAction(Keys_MoveTop2, "MoveTop", bRemove)
    SetHotkeyAction(Keys_MoveBottom, "MoveBottom", bRemove)
    SetHotkeyAction(Keys_MoveBottom2, "MoveBottom", bRemove)
    SetHotkeyAction(Keys_MoveHardLeft, "MoveHardLeft", bRemove)
    SetHotkeyAction(Keys_MoveHardLeft2, "MoveHardLeft", bRemove)
    SetHotkeyAction(Keys_MoveHardRight, "MoveHardRight", bRemove)
    SetHotkeyAction(Keys_MoveHardRight2, "MoveHardRight", bRemove)
    SetHotkeyAction(Keys_MoveTopLeft, "MoveTopLeft", bRemove)
    SetHotkeyAction(Keys_MoveTopRight, "MoveTopRight", bRemove)
    SetHotkeyAction(Keys_MoveBottomLeft, "MoveBottomLeft", bRemove)
    SetHotkeyAction(Keys_MoveBottomRight, "MoveBottomRight", bRemove)
    SetHotkeyAction(Keys_MoveCenter, "MoveCenter", bRemove)
    SetHotkeyAction(Keys_MoveCenter2, "MoveCenter", bRemove)
    ; "Resize" commands
    SetHotkeyAction(Keys_ResizeLeft, "ResizeLeft", bRemove)
    SetHotkeyAction(Keys_ResizeRight, "ResizeRight", bRemove)
    SetHotkeyAction(Keys_ResizeUp, "ResizeUp", bRemove)
    SetHotkeyAction(Keys_ResizeDown, "ResizeDown", bRemove)
    SetHotkeyAction(Keys_ResizeLarger, "ResizeLarger", bRemove)
    SetHotkeyAction(Keys_ResizeSmaller, "ResizeSmaller", bRemove)
    ; Resize+Move commands
    SetHotkeyAction(Keys_Grow, "Grow", bRemove)
    SetHotkeyAction(Keys_Grow2, "Grow", bRemove)
    SetHotkeyAction(Keys_Grow3, "Grow", bRemove)
    SetHotkeyAction(Keys_Grow4, "Grow", bRemove)
    SetHotkeyAction(Keys_Grow5, "Grow", bRemove)
    SetHotkeyAction(Keys_Grow6, "Grow", bRemove)
    SetHotkeyAction(Keys_Shrink, "Shrink", bRemove)
    SetHotkeyAction(Keys_Shrink2, "Shrink", bRemove)
    SetHotkeyAction(Keys_Shrink3, "Shrink", bRemove)
    SetHotkeyAction(Keys_Shrink4, "Shrink", bRemove)
    SetHotkeyAction(Keys_Shrink5, "Shrink", bRemove)
    SetHotkeyAction(Keys_Shrink6, "Shrink", bRemove)
    SetHotkeyAction(Keys_ResizeHalfScreen, "ResizeHalfScreen", bRemove)
    SetHotkeyAction(Keys_ResizeThreeQuarterScreen, "ResizeThreeQuarterScreen", bRemove)
    SetHotkeyAction(Keys_ResizeFullScreen, "ResizeFullScreen", bRemove)
    SetHotkeyAction(Keys_ResizeFullScreen2, "ResizeFullScreen", bRemove)
    ; "Restore" commands
    SetHotkeyAction(Keys_RestoreToPreviousPosn, "RestoreToPreviousPosn", bRemove)
    ; Virtual Desktop commands
    SetHotkeyAction(Keys_SwitchToPreviousDesktop, "SwitchToPreviousDesktop", bRemove)
    SetHotkeyAction(Keys_SwitchToNextDesktop, "SwitchToNextDesktop", bRemove)
    SetHotkeyAction(Keys_MoveToPreviousDesktop, "MoveToPreviousDesktop", bRemove)
    SetHotkeyAction(Keys_MoveToPreviousDesktop2, "MoveToPreviousDesktop", bRemove)
    SetHotkeyAction(Keys_MoveToNextDesktop, "MoveToNextDesktop", bRemove)
    SetHotkeyAction(Keys_MoveToNextDesktop2, "MoveToNextDesktop", bRemove)
    ; Tile and Cascade windows
    SetHotkeyAction(Keys_TileWindowsVertically, "TileWindowsVertically", bRemove)
    SetHotkeyAction(Keys_TileWindowsVertically2, "TileWindowsVertically", bRemove)
    SetHotkeyAction(Keys_TileWindowsHorizontally, "TileWindowsHorizontally", bRemove)
    SetHotkeyAction(Keys_TileWindowsHorizontally2, "TileWindowsHorizontally", bRemove)
    SetHotkeyAction(Keys_CascadeWindows, "CascadeWindows", bRemove)
    SetHotkeyAction(Keys_CascadeWindows2, "CascadeWindows", bRemove)

    return ; end shortcuts init
}

SetHotkeyAction(Keys, KeyAction, bRemove := false) {
;    if (Keys = "^+#Left") {
;        MsgBox Setting %KeyAction% to %Keys% (Remove = %bRemove%)
;    }

    if (bRemove) {
        Hotkey, %Keys%, Off
    } else {
        Hotkey, %Keys%, %KeyAction%
    }
}

; ================================
; ==== Move Window commands ====
; ================================

; ---- Small window movements ----

MoveLeft:
DoMoveAndResize(-1, 0)
return

MoveRight:
DoMoveAndResize(1, 0)
return

MoveUp:
DoMoveAndResize(0, -1)
return

MoveDown:
DoMoveAndResize(0, 1)
return

; ------------------------------
; ---- Move to Screen Edges ----
; ------------------------------

MoveTop:
MoveToEdge("Top")
return

MoveBottom:
MoveToEdge("Bottom")
return

MoveHardLeft:
MoveToEdge("HardLeft")
return

MoveHardRight:
MoveToEdge("HardRight")
return

; -- Corners --

MoveTopLeft:
MoveToEdge("TopLeft")
return

MoveTopRight:
MoveToEdge("TopRight")
return

MoveBottomLeft:
MoveToEdge("BottomLeft")
return

MoveBottomRight:
MoveToEdge("BottomRight")
return

; -- Center --

MoveCenter:
MoveWindowToCenter()
return

; ================================
; ==== Resize Window commands ====
; ================================

ResizeLeft:
DoMoveAndResize( , , -1, 0)
return

ResizeRight:
DoMoveAndResize( , , 1, 0)
return

ResizeUp:
DoMoveAndResize( , , 0, -1)
return

ResizeDown:
DoMoveAndResize( , , 0, 1)
return

ResizeLarger:
; Increase window size (both width and height)
DoMoveAndResize( , , 1, 1)
return

ResizeSmaller:
; Reduce window size (both width and height)
DoMoveAndResize( , , -1, -1)
return

; ======================================
; ==== Special Move/Resize commands ====
; ======================================

Grow:
; Increase window size (both width and height) in both directions
DoMoveAndResize(-1, -1, 2, 2)
return

Shrink:
; Decrease window size (both width and height) in both directions
DoMoveAndResize(1, 1, -2, -2)
return

; Resize to half of the screen size
ResizeHalfScreen:
ResizeAndCenter(0.5)
return

; Resize to three-quarters of the screen size
ResizeThreeQuarterScreen:
ResizeAndCenter(0.75)
return

ResizeFullScreen:
; Move and Resize window to full screen
ResizeAndCenter(1)
return

; ======================
; ===== Restore ========
; ======================

RestoreToPreviousPosn:
EnsureWindowIsRestored()
; Restore to the previous position (Posn only - not size)
WinMove, WinX, WinY
return

RestoreToPreviousPosnAndSize:
EnsureWindowIsRestored()
; Restore to the previous window size and position
WinMove, A, , WinX, WinY, WinW, WinH
return

; ===============================
; ===== Tile and Cascade ========
; ===============================

; -----
; Credit to: https://autohotkey.com/board/topic/80580-how-to-programmatically-tile-cascade-windows/
; -----
; Tile windows vertically : DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
; Tile windows horizontally : DllCall( "TileWindows", uInt,0, Int,1, Int,0, Int,0, Int,0 )
; Cascade windows : DllCall( "CascadeWindows", uInt,0, Int,4, Int,0, Int,0, Int,0 )

TileWindowsVertically:
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return

TileWindowsHorizontally:
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return

CascadeWindows:
DllCall( "CascadeWindows", uInt,0, Int,4, Int,0, Int,0, Int,0 )
return

; ==============================
; ===== 4-column Layout ========
; ==============================

!#1::
; Move to Column 1 of 4-column layout
MoveToFourColumnLayout(1)
return

!#2::
; Move to Column 2 of 4-column layout
MoveToFourColumnLayout(2)
return

!#3::
; Move to Column 3 of 4-column layout
MoveToFourColumnLayout(3)
return

!#4::
; Move to Column 4 of 4-column layout
MoveToFourColumnLayout(4)
return

!#,::
; Move to the Column to the Left
GoToColNum := GetPrevColNum()
; MsgBox GoToColNum: %GoToColNum%
MoveToFourColumnLayout(GoToColNum)
return

!#.::
; Move to the Column to the Right
GoToColNum := GetNextColNum()
; MsgBox GoToColNum: %GoToColNum%
MoveToFourColumnLayout(GoToColNum)
return

;=== Move and Resize to fit 4-Column layout ==

!+#1::
; Resize to Column 1 of 4-column layout
ResizeToFourColumnLayout(1)
return

!+#2::
; Resize to Column 2 of 4-column layout
ResizeToFourColumnLayout(2)
return

!+#3::
; Resize to Column 3 of 4-column layout
ResizeToFourColumnLayout(3)
return

!+#4::
; Resize to Column 4 of 4-column layout
ResizeToFourColumnLayout(4)
return

!+#,::
; Move to the Column to the Left
GoToColNum := GetPrevColNum()
; MsgBox GoToColNum: %GoToColNum%
ResizeToFourColumnLayout(GoToColNum)
return

!+#.::
; Move to the Column to the Right
GoToColNum := GetNextColNum()
; MsgBox GoToColNum: %GoToColNum%
ResizeToFourColumnLayout(GoToColNum)
return

; ==============================
; ===== Switch desktops ========
; ==============================

; Credit to: https://www.autohotkey.com/boards/viewtopic.php?t=17941

SwitchToPreviousDesktop()
{
    send {LWin down}{LCtrl down}{Left}{LCtrl up}{LWin up}  ; switch to previous virtual desktop
    return
}

SwitchToNextDesktop()
{
    send {LWin down}{LCtrl down}{Right}{LCtrl up}{LWin up}   ; switch to next virtual desktop
    return
}

; ====================================================
; ===== Move window to other Virtual Desktops ========
; ====================================================

MoveToPreviousDesktop()
{
    ; Pre-conditons:
    ; Check current desktop is not Desktop 1; if on desktop one, abort
;    if (currentDesktop = 1) {
;        return
;    }

    MoveWindowToOtherDesktop(-1) ; Move 1 desktop to the left
}

MoveToNextDesktop()
{
    ; Pre-conditons:
    ; Check: Is there a desktop to the right? If not, can we create a new one?
;    if (currentDesktop = numDesktops) {
;        return
;    }

    MoveWindowToOtherDesktop(1) ; Move 1 desktop to the right
}

MoveWindowToOtherDesktop(direction)
{
;    ; Pre-conditons:
;    ; Check: Is there a desktop to the right? If not, can we create a new one?
;    currentDesktop = 2
;    numDesktops = 3

    ; Methodology
    ; 1. Hide the window
    ; 2. Move to the next/previous desktop
    ; 3. Unhide the window

    WinWait, A
    WinHide
    if (direction > 0) {
        ; If there is no desktop to the right, create one
;        if (currentDesktop == numDesktops) {
;            Send ^#d ; Will automatically take focus to the new desktop
;        } else {
            SwitchToNextDesktop()
;        }
    } else {
        SwitchToPreviousDesktop()
    }
    Sleep 100
    WinShow
    WinActivate
}

; ========================
; ===== Functions ========
; ========================

MoveToEdge(Edge)
{
    ; Get monitor and window dimensions
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.

    ; Set window coordinates
    if InStr(Edge, "Left")
        NewX := MonLeft
    if InStr(Edge, "Right")
        NewX := MonRight - WinW
    if InStr(Edge, "Top")
        NewY := MonTop
    if InStr(Edge, "Bottom")
        NewY := MonBottom - WinH

    ; MsgBox NewX/NewY = %NewX%,%NewY%
    RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
    return
}

DoMoveAndResize(MoveX:=0, MoveY:=0, GrowW:=0, GrowH:=0)
{
    GetMoveCoordinates(A, NewX, NewY, NewW, NewH, MoveX, MoveY, GrowW, GrowH)
    RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
}

DoResizeAndCenter(WinNum, NewW, NewH)
{
    GetCenterCoordinates(A, WinNum, NewX, NewY, NewW, NewH)
    RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
}

ResizeAndCenter(Ratio)
{
    WinNum := GetWindowNumber()
    CalculateSizeByWinRatio(NewW, NewH, WinNum, Ratio)
    DoResizeAndCenter(WinNum, NewW, NewH)
}

MoveWindowToCenter() {
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    DoResizeAndCenter(WinNum, WinW, WinH)
    return
}

CalculateSizeByWinRatio(ByRef NewW, ByRef NewH, WinNum, Ratio)
{
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    NewW := (MonRight - MonLeft) * Ratio
    NewH := (MonBottom - MonTop) * Ratio
}

RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
{
    EnsureWindowIsRestored() ; Always ensure the window is restored before any move or resize operation
;    MsgBox Move to: %NewX%, %NewY%, %WinW%, %WinH%
    WinMove, A, , NewX, NewY, NewW, NewH
}

GetMoveCoordinates(ByRef A, ByRef NewX, ByRef NewY, ByRef NewW, ByRef NewH, MovX:=0, MovY:=0, GrowW:=0, GrowH:=0)
{
    global PixelsPerStep ; The number of pixels to move/grow (multiplied by MovX,MovY,GrowW,GrowH)
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    NewW := WinW + (PixelsPerStep * GrowW)
    NewH := WinH + (PixelsPerStep * GrowH)
    NewX := WinX + (PixelsPerStep * MovX)
    NewY := WinY + (PixelsPerStep * MovY)
}

GetCenterCoordinates(ByRef A, WinNum, ByRef NewX, ByRef NewY, WinW, WinH)
{
    ; Set the screen variables
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ScreenW := MonRight - MonLeft
    ScreenH := MonBottom - MonTop

    ; Calculate the position based on the given dimensions [W|H]
    NewX := (ScreenW-WinW)/2 + MonLeft ; Adjust for monitor offset
    NewY := (ScreenH-WinH)/2 + MonTop ; Adjust for monitor offset
}

EnsureWindowIsRestored()
{
    WinGet, ActiveWinState, MinMax, A
    if (ActiveWinState != 0)
        WinRestore, A
}

GetWindowNumber()
{
    ; Get the Active window
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    SysGet, numMonitors, MonitorCount
    Loop %numMonitors% {
        SysGet, monitor, MonitorWorkArea, %A_Index%
        if (monitorLeft <= WinX && WinX <= monitorRight && monitorTop <= WinY && WinY <= monitorBottom){
            ; We have found the monitor that this window sits inside (at least the top-left corner)
            return %A_Index%
        }
    }
    return 1    ; If we can't find a matching window, just return 1 (Primary)
}

MoveToFourColumnLayout(ColNum) {
    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    TaskBarW = 0 ; This should be set >0 if the Taskbar is on the left or right.
    MonWorkingWidth := MonRight - MonLeft - TaskBarW
    ; Generate new co-ordinates
    ColWidth := MonWorkingWidth * (1/4) ; With 4-columns layout, width is one quarter of the screen
    AdjustX := 10 ; Adjustment amount to fix small window offset issue
    NewX := MonLeft + ((ColNum-1) * ColWidth) - AdjustX ; Should be monitor left + offset (colNum-1 * colWidth)
    ; Move window
    WinMove, A, , NewX, , ,
    return
}

ResizeToFourColumnLayout(ColNum) {
    ; MsgBox Moving to column #%ColNum%
    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ; MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
    TaskBarW = 0 ; This should be set >0 if the Taskbar is on the left or right.
    TaskBarH = 50 ; Allow for the Windows Taskbar to be visible - Set this to 0 if Taskbar on AutoHide
    ; MonWorkingWidth := A_ScreenWidth - TaskBarW
    MonWorkingHeight := A_ScreenHeight - TaskBarH
    MonWorkingWidth := MonRight - MonLeft - TaskBarW
    ; MonWorkingHeight := MonTop - MonBottom - TaskBarH
    ; Generate new co-ordinates
    ColWidth := MonWorkingWidth * (1/4) ; With 4-columns layout, width is one quarter of the screen
    AdjustX := 10 ; Adjustment amount to fix small window offset issue
    NewX := MonLeft + ((ColNum-1) * ColWidth) - AdjustX ; Should be monitor left + offset (colNum-1 * colWidth)
    NewY := MonTop   ; Should be monitor top
    NewW := (MonWorkingWidth / 4) + (AdjustX * 2) ; Set to 1/4 mon width for 4-column layout
    NewH := MonWorkingHeight    ; full window height
    ; MsgBox, Moving to X,Y = %NewX%,%NewY% and W,H = %NewW%,%NewH%
    WinMove, A, , NewX, NewY, NewW, NewH
    return
}

GetPrevColNum() {
    return GetCurrentColNum(true)
}
GetNextColNum() {
    return GetCurrentColNum(false)
}

GetCurrentColNum(bGetPrevious)
{
    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ; MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
    TaskBarW = 0 ; This should be set >0 if the Taskbar is on the left or right.
    TaskBarH = 50 ; Allow for the Windows Taskbar to be visible - Set this to 0 if Taskbar on AutoHide
    ; MonWorkingWidth := A_ScreenWidth - TaskBarW
    MonWorkingHeight := A_ScreenHeight - TaskBarH
    MonWorkingWidth := MonRight - MonLeft - TaskBarW
    ; MonWorkingHeight := MonTop - MonBottom - TaskBarH
    ; Generate new co-ordinates
    ColWidth := MonWorkingWidth * (1/4) ; With 4-columns layout, width is one quarter of the screen
    AdjustX := 10 ; Adjustment amount to fix small window offset issue

    ; Where is the current top corner of the active window?
    DistanceFromLeft := WinX - MonLeft
    Col1X := MonLeft
    Col2X := MonLeft + ColWidth
    Col3X := MonLeft + (ColWidth * 2)
    Col4X := MonLeft + (ColWidth * 3)
    ; MsgBox ColEdges: %Col1X%, %Col2X%, %Col3X%, %Col4X%
    ; MsgBox WinX = %WinX%
    AdjustedWinX := WinX + AdjustX
    ; MsgBox AdjustedWinX = %AdjustedWinX%
    ; If WinX is currently on a column boundary, return ColNum based on bGetPrevious
    if (AdjustedWinX == Col1X) {
        CurrentCol := (bGetPrevious ? 1 : 2)   ; Note: Effective no-op on move-prev when already hard left
    } else if (AdjustedWinX == Col2X) {
        CurrentCol := (bGetPrevious ? 1 : 3)
    } else if (AdjustedWinX == Col3X) {
        CurrentCol := (bGetPrevious ? 2 : 4)
    } else if (AdjustedWinX == Col4X) {
        CurrentCol := (bGetPrevious ? 3 : 4)   ; Note: Effective no-op on move-next when already hard right
    }
    ; Now handle the window in between column boundaries
    else if (AdjustedWinX < Col2X) {
        CurrentCol := (bGetPrevious ? 1 : 2)
    } else if (AdjustedWinX < Col3X) {
        CurrentCol := (bGetPrevious ? 2 : 3)
    } else if (AdjustedWinX < Col4X) {
        CurrentCol := (bGetPrevious ? 3 : 4)
    } else {
        CurrentCol := 4  ; Snap into 4th column if WinX already partly in 4th column
    }
    ; MsgBox Current column = %CurrentCol%
    return CurrentCol
}
