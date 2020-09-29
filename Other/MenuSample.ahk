;-------- Sample menus -----------

SampleMenu() {
    ; Add items to the SysTray
    Menu, Tray, Add  ; Creates a separator line.
    ; Menu, Tray, Add, Item Text, MenuHandler  ; Creates a new menu item.
    Menu, Tray, Add, Item1, MenuHandler  ; Creates a new menu item.
}

InitMyMenu() {
    ; Create the menu (MyMenu) by adding some items to it.
    Menu, MyMenu, Add, &Item1, MenuHandler
    Menu, MyMenu, Add, Item&2, MenuHandler
    Menu, MyMenu, Add  ; Add a separator line.

    ; Create another menu destined to become a submenu of the above menu.
    Menu, Submenu1, Add, Item&1, MenuHandler
    Menu, Submenu1, Add, Item&2, MenuHandler

    ; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
    Menu, MyMenu, Add, My &Submenu, :Submenu1

    Menu, MyMenu, Add  ; Add a separator line below the submenu.
    Menu, MyMenu, Add, Item&3, MenuHandler  ; Add another menu item beneath the submenu.

    ; Add MyMenu to the SysTray menu
    Menu, Tray, Add ; separator
    Menu, Tray, Add, &My Menu, :MyMenu

    ; Set the menu to pop up when Win-Z is pressed
    Hotkey, #z, ShowMyMenu
}

ShowMyMenu() {
    Menu, MyMenu, Show  ; i.e. press the Win-Z hotkey to show the menu.
}

MenuHandler() {
    MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
    return
}
