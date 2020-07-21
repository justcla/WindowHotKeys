Gui Add, Text, xm, Prefix key:
Gui Add, Edit, yp x100 w100 vPrefix, Space
Gui Add, Text, xm, Suffix hotkey:
Gui Add, Edit, yp x100 w100  vSuffix, f & j
Gui Add, Button, Default, Register
Gui Show
return

ButtonRegister() {
    global
    Gui Submit, NoHide
    local fn
    fn := Func("HotkeyShouldFire").Bind(Prefix)
    Hotkey If, % fn
    Hotkey % Suffix, FireHotkey
}

HotkeyShouldFire(prefix, thisHotkey) {
    return GetKeyState(prefix)
}

FireHotkey() {
    MsgBox %A_ThisHotkey%
}

GuiClose:
GuiEscape:
ExitApp