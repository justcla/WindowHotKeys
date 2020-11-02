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

; SettingsFile holds program settings and defaults
SettingsFile = HotkeySettings.ini

; Configure shortcut profiles
class ShortcutsProfile {
    __New(profileName, profileFile) {
        this.Name := profileName
        this.File := profileFile
    }
}
class Profiles {
    ; Shortcut Profiles
    static AltWin := new ShortcutsProfile("Alt+Win shortcuts", "ShortcutDefs-AltWin.ini")
    static CtrlWin := new ShortcutsProfile("Ctrl+Win shortcuts", "ShortcutDefs-CtrlWin.ini")
    static Custom := new ShortcutsProfile("Custom shortcuts", "ShortcutDefs-Custom.ini")

    ; Global var for storing the profile currently in use
    static Current := AltWin
}
; Set the current shortcuts profile based on profile defined in settings file
; Read user-preference for shortcut combinations (each defined in a separate shortcutsDef INI file)
IniRead, InitialShortcutsProfileName, %SettingsFile%, General, InitialShortcutsProfile
InitialShortcutsProfile := GetShortcutsProfileFromName(InitialShortcutsProfileName)

; PixelsPerStep - Defines the number of pixels used by each move or resize action
IniRead, PixelsPerStep, %SettingsFile%, Settings, PixelsPerStep, 50

; Initialize the System Tray icon and menu
InitializeIcon()
InitializeMenu()

; Initialize the shortcuts
KeysInUse := []   ; Stores all keys currently in use. Used when clearing all shortcuts. 
SetShortcutsProfile(InitialShortcutsProfile)

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
    Menu, Tray, Add, Edit Custom shortcuts, OpenCurrentShortSet
    Menu, Tray, Add ; separator

    ; HotKey Profiles
    Menu, Profiles, Add, % Profiles.AltWin.Name, SetAltKeyShortcuts
    Menu, Profiles, Add, % Profiles.CtrlWin.Name, SetCtrlKeyShortcuts
    Menu, Profiles, Add, % Profiles.Custom.Name, SetCustomShortcuts
    Menu, Tray, Add, Shortcut &Profiles, :Profiles

    MoveStandardMenuToBottom()
}

GetShortcutsProfileFromName(ShortcutsProfileName) {
    switch ShortcutsProfileName {
        case Profiles.CtrlWin.Name: return Profiles.CtrlWin
        case Profiles.Custom.Name: return Profiles.Custom
        default: return Profiles.AltWin   ; fall back to Alt+Win profile as a default
    }
}

SetAltKeyShortcuts() {
    ChangeShortcutsProfile(Profiles.AltWin)
}

SetCtrlKeyShortcuts() {
    ChangeShortcutsProfile(Profiles.CtrlWin)
}

SetCustomShortcuts() {
    ChangeShortcutsProfile(Profiles.Custom)
}

ChangeShortcutsProfile(ShortcutsProfile) {
    ; First remove all shortcuts and uncheck all profiles in the menu
    ClearAllShortcuts()
    UncheckAllProfiles()

    ; Now set the new shortcuts profile
    SetShortcutsProfile(ShortcutsProfile)
    MsgBox % "Move and Resize Windows is now configured for " Profiles.Current.Name
}

ClearAllShortcuts() {
    global KeysInUse
    For index, Keys in KeysInUse {
        Hotkey, %Keys%, Off
    }
    ; Reset the KeysInUse array
    KeysInUse := []
}

UncheckAllProfiles() {
    Menu, Profiles, Uncheck, % Profiles.AltWin.Name
    Menu, Profiles, Uncheck, % Profiles.CtrlWin.Name
    Menu, Profiles, Uncheck, % Profiles.Custom.Name
}

SetShortcutsProfile(ShortcutsProfile) {
    ; MsgBox % "Setting shortcuts profile: " ShortcutsProfile.Name " - from file: " ShortcutsProfile.File
    Profiles.Current := ShortcutsProfile
    SetShortcutsFromFile(ShortcutsProfile.File)
    Menu, Profiles, Check, % ShortcutsProfile.Name
}

ShowAboutDialog() {
    MsgBox 0, Alt+Win HotKeys, Alt+Win HotKeys - Utility to move and resize windows.`n`n Developed by Justin Clareburt
}

OpenSettings() {
    global SettingsFile
    Run, % "edit " SettingsFile
}

OpenCurrentShortSet() {
    Run, % "edit " Profiles.Custom.File
}

MoveStandardMenuToBottom() {
    ; Move Standard menu items (ie. Pause/Exit) to the bottom
    Menu, Tray, Add ; Separator
    Menu, Tray, NoStandard
    Menu, Tray, Standard
}

; ------- End Menu Init -----------
; ---------------------------------

SetShortcutsFromFile(ShortcutsFile) {

    ; MsgBox % "Setting shortcuts from file: " ShortcutsFile

    ; ==== Define the shortcut key combinations ====
    ; Read the shortcut keys from the shortcuts file (or fall back on defaults)

    ;Move
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveLeft", "MoveLeft", "!#Left")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveRight", "MoveRight", "!#Right")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveUp", "MoveUp", "!#Up")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveDown", "MoveDown", "!#Down")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTop", "MoveTop", "!#PgUp")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTop2", "MoveTop", "!#Numpad8")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottom", "MoveBottom", "!#PgDn")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottom2", "MoveBottom", "!#Numpad2")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardLeft", "MoveHardLeft", "!#Home")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardLeft2", "MoveHardLeft", "!#Numpad4")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardRight", "MoveHardRight", "!#End")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardRight2", "MoveHardRight", "!#Numpad6")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTopLeft", "MoveTopLeft", "!#Numpad7")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTopRight", "MoveTopRight", "!#Numpad9")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottomLeft", "MoveBottomLeft", "!#Numpad1")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottomRight", "MoveBottomRight", "!#Numpad3")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveCenter", "MoveCenter", "!#Del")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveCenter2", "MoveCenter", "!#Numpad5")

    ;Resize (only)
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeLeft", "ResizeLeft", "!+#Left")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeRight", "ResizeRight", "!+#Right")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeUp", "ResizeUp", "!+#Up")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeDown", "ResizeDown", "!+#Down")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeLarger", "ResizeLarger", "!+#PgDn")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeSmaller", "ResizeSmaller", "!+#PgUp")
    ;Resize and move
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow", "Grow", "!+#=")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow2", "Grow", "!+#NumpadAdd")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow3", "Grow", "!#=")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow4", "Grow", "!#NumpadAdd")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow5", "Grow", "^#+")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Grow6", "Grow", "^#NumpadAdd")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink", "Shrink", "!+#-")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink2", "Shrink", "!+#NumpadSub")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink3", "Shrink", "!#-")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink4", "Shrink", "!#NumpadSub")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink5", "Shrink", "^#-")
    ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink6", "Shrink", "^#NumpadSub")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeHalfScreen", "ResizeHalfScreen", "!+#Del")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeThreeQuarterScreen", "ResizeThreeQuarterScreen", "!+#Home")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeFullScreen", "ResizeFullScreen", "!#Enter")
    ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeFullScreen2", "ResizeFullScreen", "!+#Enter")
    ; "Restore" commands
    ReadAndStoreHotKeyAction(ShortcutsFile, "RestoreToPreviousPosn", "RestoreToPreviousPosn", "!#Backspace")
    ReadAndStoreHotKeyAction(ShortcutsFile, "RestoreToPreviousPosnAndSize", "RestoreToPreviousPosnAndSize", "!+#Backspace")
    ; Virtual Desktop commands
    ReadAndStoreHotKeyAction(ShortcutsFile, "SwitchToPreviousDesktop", "SwitchToPreviousDesktop", "^#,")
    ReadAndStoreHotKeyAction(ShortcutsFile, "SwitchToNextDesktop", "SwitchToNextDesktop", "^#.")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToPreviousDesktop", "MoveToPreviousDesktop", "^+#,")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToPreviousDesktop2", "MoveToPreviousDesktop", "^+#Left")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToNextDesktop", "MoveToNextDesktop", "^+#.")
    ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToNextDesktop2", "MoveToNextDesktop", "^+#Right")
    ; Tile and Cascade windows
    ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsVertically", "TileWindowsVertically", "!#V")
    ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsVertically2", "TileWindowsVertically", "!+#V")
    ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsHorizontally", "TileWindowsHorizontally", "!#H")
    ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsHorizontally2", "TileWindowsHorizontally", "!+#H")
    ReadAndStoreHotKeyAction(ShortcutsFile, "CascadeWindows", "CascadeWindows", "!#C")
    ReadAndStoreHotKeyAction(ShortcutsFile, "CascadeWindows2", "CascadeWindows", "!+#C")

    return ; end shortcuts init
}

ReadAndStoreHotKeyAction(ShortcutsFile, KeyCode, KeyAction, DefaultKeys) {
    ; Read the KeyCombo from the shortcuts definition file. Should be stored in the [Shortcuts] category.
    IniRead, KeyCombo, %ShortcutsFile%, Shortcuts, %KeyCode%, %DefaultKeys%
    ; Set the action to trigger when the key-combo is pressed.
    SetHotkeyAction(KeyCombo, KeyAction)
}

SetHotkeyAction(Keys, KeyAction) {
    global KeysInUse
    Hotkey, %Keys%, %KeyAction%, On
    ; Add the Hotkey to the KeysInUse array (so it can be removed later)
    KeysInUse.Push(Keys)
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
