; ==============================
; ===== 4-column Layout ========
; ==============================

; ===== 4-column Key Bindings ========

; !#1::
; ; Move to Column 1 of 4-column layout
; MoveToFourColumnLayout(1)
; return
;
; !#2::
; ; Move to Column 2 of 4-column layout
; MoveToFourColumnLayout(2)
; return
;
; !#3::
; ; Move to Column 3 of 4-column layout
; MoveToFourColumnLayout(3)
; return
;
; !#4::
; ; Move to Column 4 of 4-column layout
; MoveToFourColumnLayout(4)
; return
;
; !#,::
; ; Move to the Column to the Left
; GoToColNum := GetPrevColNum()
; ; MsgBox GoToColNum: %GoToColNum%
; MoveToFourColumnLayout(GoToColNum)
; return

; !#.::
; ; Move to the Column to the Right
; GoToColNum := GetNextColNum()
; ; MsgBox GoToColNum: %GoToColNum%
; MoveToFourColumnLayout(GoToColNum)
; return

ResizeTo3Column() {
    ResizeToMultiColumn(3)
}
ResizeTo4Column() {
    ResizeToMultiColumn(4)
}
ResizeTo5Column() {
    ResizeToMultiColumn(5)
}

MoveLeftOneQuarter() {
    ; Move to the Quarter-Column to the Left
    GoToColNum := GetPrevColNum(4)
    SnapToQuarterScreen(GoToColNum)
}

MoveRightOneQuarter() {
    ; Move to the Quarter-Column to the Right
    GoToColNum := GetNextColNum(4)
    SnapToQuarterScreen(GoToColNum)
}

;=== Move and Resize to fit 4-Column layout ==

; ===== Multi-column Layout functions ========

ResizeToMultiColumn(ColCount) {
    ; Make window fit one column (based on ColCount) and full height

    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ; MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.

    ; Generate new co-ordinates
    MonWorkingWidth := MonRight - MonLeft
    MonWorkingHeight := MonBottom - MonTop
    WinPaddingX := 0 ; Adjustment amount to fix small window offset issue (Note: Not using WinPadding)
    NewY := MonTop   ; Should be monitor top
    NewW := (MonWorkingWidth / ColCount) + (WinPaddingX * 2) ; ie. Set to 1/4 mon width for 4-column layout
    NewH := MonWorkingHeight    ; full window height

    ; Resize window
    ; MsgBox, Moving to X,Y = %NewX%,%NewY% and W,H = %NewW%,%NewH%
    RestoreMoveAndResize(A, WinX, NewY, NewW, NewH)
}

SnapToQuarterScreen(ColNum) {
    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    MonWorkingWidth := MonRight - MonLeft

    ; Generate new co-ordinates
    ColWidth := MonWorkingWidth * (1/4) ; With 4-columns layout, width is one quarter of the screen
    WinPaddingX := 0 ; Adjustment amount to fix small window offset issue
    NewX := MonLeft + ((ColNum-1) * ColWidth) - WinPaddingX

    ; Move window
    RestoreMoveAndResize(A, NewX, WinY, WinW, WinH)
}

GetPrevColNum(ColCount) {
    DestCol := GetCurrentColNum(ColCount, bOnColEdge)
    if (bOnColEdge) {
        DestCol--
    }
    if (DestCol < 1) {
        ; TODO: Push onto previous monitor, if there is one
        ; For now, keep it on the current screen
        DestCol := 1
    }
    return DestCol
}
GetNextColNum(ColCount) {
    DestCol := GetCurrentColNum(ColCount)
    DestCol++
    if (DestCol > ColCount) {
        ; TODO: Push onto next monitor, if there is one
        ; For now, keep it on the current screen
        DestCol := ColCount
    }
    return DestCol
}

GetCurrentColNum(ColCount, ByRef bOnColEdge := false)
{
    ; Get active window and monitor details
    WinGetPos, WinX, WinY, WinW, WinH, A  ; "A" to get the active window's pos.
    WinNum := GetWindowNumber()
    SysGet, Mon, MonitorWorkArea, %WinNum%
    ; MsgBox, Mon (P) - Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
    MonWorkingWidth := MonRight - MonLeft
    MonWorkingHeight := MonBottom - MonTop

    ColWidth := MonWorkingWidth / ColCount
    AdjustX := 0 ; Adjustment amount to fix small window offset issue

    ; In which column is the top left corner?
    ; Loop through each column to see if the X,Y co-ordinates are in the column
    CurrentCol := 1
    loop, %ColCount% {
        ColStartX := MonLeft + (ColWidth * (A_Index-1))
        ColEndX := MonLeft + (ColWidth * A_Index)
        if (WinX+AdjustX < ColEndX) {
            bOnColEdge := (WinX = ColStartX-AdjustX)
            CurrentCol := A_Index
            break   ; We've found the column this window fits into - exit now
        }
    }

    ; MsgBox Current column = %CurrentCol%
    return CurrentCol
}
