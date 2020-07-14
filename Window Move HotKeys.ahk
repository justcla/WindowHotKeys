#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Author: Justin Clareburt (@justcla)
; Created: 26-May-2020

; Notes:
; WinGetPos, X, Y, W, H, A  ; "A" to get the active window's pos.
; MsgBox, The active window is at %X%`,%Y% with width and height [%W%, %H%]
; MsgBox, Screen_X(%Screen_X%) Screen_Y(%Screen_Y%) NewX(%NewX%)

; Hoy Key Symbols
; Symbol	#	= Win (Windows logo key)
; Symbol	!	= Alt
; Symbol	^	= Control
; Symbol	+	= Shift
; Symbol	& = An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.

; Global variables
TaskBarW = 0 ; This should be set >0 if the Taskbar is on the left or right.
TaskBarH = 50 ; Allow for the Windows Taskbar to be visible - Set this to 0 if Taskbar on AutoHide
; Maybe the best way to calculate the taskbar height is to maximize a window and then check its height.

Screen_X := A_ScreenWidth - TaskBarW
Screen_Y := A_ScreenHeight - TaskBarH

EdgeBuffer = 50
LimitX := Screen_X - EdgeBuffer
LimitY := Screen_Y - EdgeBuffer

MoveAmount = 50 ; The number of pixels to move when resizing windows
ResizeRatio := 3/4 ; The portion of the window to cover when resizing to Home

; ================================
; ==== Move Window commands ====
; ================================

; ---- Small window movements ----

!#Left::
; Block Move and Resize actions if the window is Maximized or Minimized
WinGet, ActiveWinState, MinMax, A ; Get the Maximized state of the active window (WinState: -1=Min,0=Restored,1=Max)
if (ActiveWinState != 0)
  return  ; Only resize a window that is in Restored mode
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := WinX - MoveAmount
; Stop the window from moving off the page
if (NewX < 0)
  NewX = 0
WinMove, A, , %NewX%, WinY, WinW, WinH
return

!#Right::
; Block Move and Resize actions if the window is Maximized or Minimized
WinGet, ActiveWinState, MinMax, A ; Get the Maximized state of the active window (WinState: -1=Min,0=Restored,1=Max)
if (ActiveWinState != 0)
  return  ; Only resize a window that is in Restored mode
; MsgBox Move window to the Right
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := WinX + MoveAmount
; Stop the window from moving off the page
if (NewX > LimitX)
  NewX := LimitX
WinMove, A, , %NewX%, WinY, WinW, WinH
return

!#Up::
; Block Move and Resize actions if the window is Maximized or Minimized
WinGet, ActiveWinState, MinMax, A ; Get the Maximized state of the active window (WinState: -1=Min,0=Restored,1=Max)
if (ActiveWinState != 0)
  return  ; Only resize a window that is in Restored mode
; MsgBox Move window Up
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewY := WinY - MoveAmount
; Stop the window from moving off the page
if (NewY < 0)
  NewY := 0
WinMove, A, , , %NewY%
return

!#Down::
; Block Move and Resize actions if the window is Maximized or Minimized
WinGet, ActiveWinState, MinMax, A ; Get the Maximized state of the active window (WinState: -1=Min,0=Restored,1=Max)
if (ActiveWinState != 0)
  return  ; Only resize a window that is in Restored mode
; MsgBox Move window Down
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewY := WinY + MoveAmount
; Stop the window from moving off the page
if (NewY > LimitY)
  NewY := LimitY
WinMove, A, , , %NewY%
return

; ------------------------------
; ---- Move to Screen Edges ----
; ------------------------------

!#PgUp::
!#Numpad8::
EnsureWindowIsRestored()
; MsgBox Move window to the Top
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinMove, A, , , %MonTop%
return

!#PgDn::
!#Numpad2::
EnsureWindowIsRestored()
; MsgBox Move window to the bottom of the screen (allow for Windows Taskbar)
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewY := MonBottom - WinH
WinMove, A, , , NewY
return

!#Home::
!#Numpad4::
EnsureWindowIsRestored()
; MsgBox Move window to the far left
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
;MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
WinMove, A, , %MonLeft%
return

!#End::
!#Numpad6::
EnsureWindowIsRestored()
; MsgBox Move window to the far right
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := MonRight - WinW
WinMove, A, , %NewX%,
return

; -- Center --

!#Numpad5::
!#Del::
MoveWindowToCenter()
return

MoveWindowToCenter() {
    ; Center the window
    EnsureWindowIsRestored() ; First, ensure the window is restored
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ; Set the screen variables
    ;MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
    ScreenW := MonLeft - MonRight
    if (ScreenW < 0)
        ScreenW := -ScreenW
    ScreenH := MonBottom - MonTop
    if (ScreenY < 0)
        ScreenY := -ScreenY
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    ; Check width and height are within screen dimension; else adjust
    NewW := WinW
    if (NewW > ScreenW)
      NewW := ScreenW
    NewH := WinH
    if (NewH > ScreenH)
      NewH := ScreenH
    ; Now set the position based on the (new) dimensions
    ;MsgBox ScreenW = %ScreenW%, NewW = %NewW%, MonLeft = %MonLeft%
    NewX := (ScreenW/2) - (NewW/2) + MonLeft ; Adjust for monitor offset
    NewY := (ScreenH/2) - (NewH/2) + MonTop ; Adjust for monitor offset
    ;MsgBox Move to: %NewX%, %NewY%, %NewW%, %NewH%
    WinMove, A, , %NewX%, %NewY%, NewW, NewH
    return
}

; -- Corners --

!#Numpad7::
EnsureWindowIsRestored()
; Move window to Top-Left
WinMove, A, , 0, 0
return

!#Numpad9::
EnsureWindowIsRestored()
; Move window to Top-Right
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := Screen_X - WinW
NewY := 0 ; Top of the screen
WinMove, A, , %NewX%, %NewY%
return

!#Numpad1::
EnsureWindowIsRestored()
; Move window to Bottom-Left
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := 0 ; Far left of screen
NewY := Screen_Y - WinH
WinMove, A, , %NewX%, %NewY%
return

!#Numpad3::
EnsureWindowIsRestored()
; Move window to Bottom-Right
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := Screen_X - WinW
NewY := Screen_Y - WinH
WinMove, A, , %NewX%, %NewY%
return


; ================================
; ==== Resize Window commands ====
; ================================

!+#Left::
; MsgBox, Resize window left
XDir := -1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := WinW + (MoveAmount * XDir)
WinMove, A, , , , NewW,
return

!+#Right::
; MsgBox, Resize window right
XDir := 1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := WinW + (MoveAmount * XDir)
WinMove, A, , , , NewW,
return

!+#Up::
; MsgBox, Resize window up
YDir := -1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := WinH + (MoveAmount * YDir)
WinMove, A, , , , , NewH
return

!+#Down::
; MsgBox, Resize window down
YDir := 1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := WinH + (MoveAmount * YDir)
WinMove, A, , , , , NewH
return

; ======================================
; ==== Special Move/Resize commands ====
; ======================================

!+#PgDn::
; Increase window size (both width and height)
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
XDir := 1
YDir := 1
NewW := WinW + (MoveAmount * XDir)
NewH := WinH + (MoveAmount * XDir)
WinMove, A, , , , NewW, NewH
return

!+#PgUp::
; Reduce window size (both width and height)
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
XDir := -1
YDir := -1
NewW := WinW + (MoveAmount * XDir)
NewH := WinH + (MoveAmount * XDir)
WinMove, A, , , , NewW, NewH
return

; Resize to three-quarters of the screen size
!+#Home::
EnsureWindowIsRestored()
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := Screen_X * ResizeRatio ; three-quarters of window width
NewH := Screen_Y * ResizeRatio ; three-quarters of window height
WinMove, A, , , , NewW, NewH
MoveWindowToCenter()
return

; Resize to half of the screen size
!+#Del::
EnsureWindowIsRestored()
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := Screen_X * (1/2) ; half of window width
NewH := Screen_Y * (1/2) ; half of window height
WinMove, A, , , , NewW, NewH
MoveWindowToCenter()
return

!#Enter::
!+#Enter::
; Move and Resize window to full screen
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := Screen_Y ; Set the window width equal to the width of the screen less the taskbar
NewW := Screen_X ; Set the window height equal to the height of the screen
WinMove, A, , 0, 0, NewW, NewH
return

!#Backspace::
EnsureWindowIsRestored()
; Restore to the previous position (Posn only - not size)
WinGetPos, , , , , A  ; "A" to get the active window's pos.
WinMove, A, , WinX, WinY
return

!+#Backspace::
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

!#V::
!+#V::
; Tile windows vertically
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return

!#H::
!+#H::
; Tile windows vertically
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return

!#F12::
!+#F12::
; Cascade windows
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
; Move to Column 1 of 4-column layout
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

; ========================
; ===== Functions ========
; ========================

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
    SysGet, Mon, MonitorWorkArea, GetWindowNumber()
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
