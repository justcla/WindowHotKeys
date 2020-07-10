﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Author: Justin Clareburt (@justcla)
; Created: 26-May-2020

; Notes:
; WinGetPos, X, Y, W, H, A  ; "A" to get the active window's pos.
; MsgBox, The active window is at %X%`,%Y% with width and height [%W%, %H%]
; MsgBox, Screen_X(%Screen_X%) Screen_Y(%Screen_Y%) NewX(%NewX%)

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

; ================================
; ==== Move Window commands ====
; ================================

; Diagnostics
^#/::
; Show current window information (X,Y,Width,Height)
ShowWindowInfo()
return

^+#/::
; Display screen information
ShowScreenInfo()
return

; ---- Small window movements ----

^#Left::
; Block Move and Resize actions if the window is Maximized or Minimized
WinGet, ActiveWinState, MinMax, A ; Get the Maximized state of the active window (WinState: -1=Min,0=Restored,1=Max)
if (ActiveWinState != 0)
  return  ; Only resize a window that is in Restored mode
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
newX := WinX - MoveAmount

; Is the window moving off the current monitor?
currentMonLeftEdge := GetCurrentLeftWorkingEdge()
;MsgBox Current Left Edge: %currentMonLeftEdge%
; If the newX is < the TopLeft of the current monitor,
if (newX < currentMonLeftEdge) {
    ; then it's moving to the monitor to the left - if one exists
;    MsgBox Moving off the monitor
    ; Is there a monitor on the left?
    currentMon := GetWindowNumber()
    if (currentMon > 1) {
        ; Find the right-most working edge of the monitor to the left
        newMon := currentMon - 1
        rightEdge := GetRightWorkingEdge(newMon)
;        MsgBox New edge: %rightEdge%
        ; Set the new X to be one movement less than the right edge
        newX := rightEdge - MoveAmount
    }
}

;currentMon := GetWindowNumber()
;newMon := GetMonForXY(WinX, WinY)
;MsgBox CurrentMon:`t%currentMon%`nNewMon:`t%newMon%
;if (newMon < currentMon)
;    MsgBox Moving off the monitor

; Stop the window auto-expanding if it hits the left edge
;MsgBox Left edge = %newX%
;if (newX >= -100 && newX <= 100) {
;  newX = -2000
;  MsgBox Too close to edge 'n Setting left edge = %newX%
;}

WinMove, A, , %newX%
return

^#Right::
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

^#Up::
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

^#Down::
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

^#PgUp::
^#Numpad8::
EnsureWindowIsRestored()
; MsgBox Move window to the Top
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinMove, A, , , %MonTop%
return

^#PgDn::
^#Numpad2::
EnsureWindowIsRestored()
; MsgBox Move window to the bottom of the screen (allow for Windows Taskbar)
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewY := MonBottom - WinH
WinMove, A, , , NewY
return

^#Home::
^#Numpad4::
EnsureWindowIsRestored()
; MsgBox Move window to the far left
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
;MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
WinMove, A, , %MonLeft%
return

^#End::
^#Numpad6::
EnsureWindowIsRestored()
; MsgBox Move window to the far right
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := MonRight - WinW
WinMove, A, , %NewX%,
return

; -- Center --

^#Numpad5::
^#Del::
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

; -- Corners --

^#Numpad7::
EnsureWindowIsRestored()
; Move window to Top-Left
WinMove, A, , 0, 0
return

^#Numpad9::
EnsureWindowIsRestored()
; Move window to Top-Right
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := Screen_X - WinW
NewY := 0 ; Top of the screen
WinMove, A, , %NewX%, %NewY%
return

^#Numpad1::
EnsureWindowIsRestored()
; Move window to Bottom-Left
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewX := 0 ; Far left of screen
NewY := Screen_Y - WinH
WinMove, A, , %NewX%, %NewY%
return

^#Numpad3::
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

^+#Left::
; MsgBox, Resize window left
XDir := -1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := WinW + (MoveAmount * XDir)
WinMove, A, , , , NewW,
return

^+#Right::
; MsgBox, Resize window right
XDir := 1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := WinW + (MoveAmount * XDir)
WinMove, A, , , , NewW,
return

^+#Up::
; MsgBox, Resize window up
YDir := -1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := WinH + (MoveAmount * YDir)
WinMove, A, , , , , NewH
return

^+#Down::
; MsgBox, Resize window down
YDir := 1
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := WinH + (MoveAmount * YDir)
WinMove, A, , , , , NewH
return

; ======================================
; ==== Special Move/Resize commands ====
; ======================================

^+#PgUp::
; Increase window size (both width and height)
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
XDir := 1
YDir := 1
NewW := WinW + (MoveAmount * XDir)
NewH := WinH + (MoveAmount * XDir)
WinMove, A, , , , NewW, NewH
return

^+#PgDn::
; Reduce window size (both width and height)
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
XDir := -1
YDir := -1
NewW := WinW + (MoveAmount * XDir)
NewH := WinH + (MoveAmount * XDir)
WinMove, A, , , , NewW, NewH
return

; Resize to a quarter of the screen size
^+#Del::
EnsureWindowIsRestored()
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewW := Screen_X / 2 ; Half window width
NewH := Screen_Y / 2 ; Half window height
WinMove, A, , , , NewW, NewH
return

^#Enter::
^+#Enter::
; Move and Resize window to full screen
WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
NewH := Screen_Y ; Set the window width equal to the width of the screen less the taskbar
NewW := Screen_X ; Set the window height equal to the height of the screen
WinMove, A, , 0, 0, NewW, NewH
return

^#Backspace::
EnsureWindowIsRestored()
; Restore to the previous position (Posn only - not size)
WinGetPos, , , , , A  ; "A" to get the active window's pos.
WinMove, A, , WinX, WinY
return

^+#Backspace::
EnsureWindowIsRestored()
; Restore to the previous window size and position
WinMove, A, , WinX, WinY, WinW, WinH
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
    return GetMonForXY(WinX, WinY)
;    SysGet, numMonitors, MonitorCount
;    Loop %numMonitors% {
;        SysGet, monitor, MonitorWorkArea, %A_Index%
;        if (monitorLeft <= WinX && WinX <= monitorRight && monitorTop <= WinY && WinY <= monitorBottom){
;            ; We have found the monitor that this window sits inside (at least the top-left corner)
;            return %A_Index%
;        }
;    }
;    return 1    ; If we can't find a matching window, just return 1 (Primary)
}

GetMonForXY(WinX, WinY)
{
    SysGet, numMonitors, MonitorCount
    Loop %numMonitors% {
        SysGet, mon, Monitor, %A_Index%
        if (monLeft <= WinX && WinX <= monRight && monTop <= WinY && WinY <= monBottom){
            ; We have found the monitor for the given X/Y co-ords
            return %A_Index%
        }
    }
    return 1    ; If we can't find a matching window, just return 1 (Primary)
}

ShowWindowInfo()
{
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    MsgBox Window info (X,Y,W,H): %WinX%, %WinY%, %WinW%, %WinH%
    return
}

ShowScreenInfo()
{
    SysGet, MonitorCount, MonitorCount
    SysGet, MonitorPrimary, MonitorPrimary
    MsgBox, Monitor Count:`t%MonitorCount%`nPrimary Monitor:`t%MonitorPrimary%
    Loop, %MonitorCount%
    {
        SysGet, MonitorName, MonitorName, %A_Index%
        SysGet, Monitor, Monitor, %A_Index%
        SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
        MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
    }
    return
}

OtherScreenInfo()
{
    ; Print info for each monitor
    SysGet, numMonitors, MonitorCount
    Loop %numMonitors% {
        ; Get the info for this monitor
        SysGet, mon, MonitorWorkArea, %A_Index%
        ; Print out the co-ordinates of the screen
        MsgBox Monitor: %A_Index% Top corner: [%monLeft%, %monTop%] Bottom corner: [%monRight%, %monBottom%]
    }
    return
}

GetCurrentLeftWorkingEdge()
{
    return GetLeftWorkingEdge(GetWindowNumber())
}

GetLeftWorkingEdge(windowNum)
{
    SysGet, mon, MonitorWorkArea, %windowNum%
    return %monLeft%
}

GetRightWorkingEdge(windowNum)
{
    SysGet, mon, MonitorWorkArea, %windowNum%
    return %monRight%
}