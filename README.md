# Alt+Win HotKeys
Shortcuts to move and resize windows in Windows.

![Alt+Win HotKeys logo](https://user-images.githubusercontent.com/17131343/87220588-6f73bf00-c3a8-11ea-9ae1-1919b0ad552c.png)

* Download the [latest release](https://github.com/justcla/WindowHotKeys/releases/latest) self-installer (MSI) for Windows
* Download the executable [AltWin-HotKeys.exe](https://github.com/justcla/WindowHotKeys/blob/master/Packaging/AltWin-HotKeys.exe)

#### Example: Move window to monitor edges

![Move window to monitor edges with Home/End/PgUp/PgDn/Del](https://user-images.githubusercontent.com/17131343/87170961-64238380-c315-11ea-9200-8f23f4b1669f.png)

**Shortcuts:** Alt+Win + [Home/End/PgUp/PgDn/Del] = Move to corresponding monitor edge

## Usage (Keyboard Shortcuts)

### Move Window *(Alt+Win)*
The following table lists the default shortcut combinations for **moving windows**.

Keyboard Shortcut | Action
--- | ---
**Basic Move shortcuts** <br> [ *Move window by 50px* ] |
Alt+Win + Up | Move window Up
Alt+Win + Down | Move window Down
Alt+Win + Left | Move window Left
Alt+Win + Right | Move window Right
**Additional Move shortcuts** <br> *[ Move to monitor Edges ]* |
Alt+Win + PgUp | Move window to the Top Edge
Alt+Win + PgDn | Move window to the Bottom Edge
Alt+Win + Home | Move window to the Left Edge
Alt+Win + End | Move window to the Right Edge
Alt+Win + Del | Move window to the Center
**NumPad Move shortcuts** <br> *[ Moves window to the corresponding edge/corner ]* |
Alt+Win + NumPad 1 | Move window to the Bottom Left Corner
Alt+Win + NumPad 2 | Move window to the Bottom Edge
Alt+Win + NumPad 3 | Move window to the Bottom Right Corner
Alt+Win + NumPad 4 | Move window to the Left Edge
Alt+Win + NumPad 5 | Move window to the Center
Alt+Win + NumPad 6 | Move window to the Right Edge
Alt+Win + NumPad 7 | Move window to the Top Left Corner
Alt+Win + NumPad 8 | Move window to the Top Edge
Alt+Win + NumPad 9 | Move window to the Top Right Corner

### Resize Window *(Alt+Win+Shift)*
The following table lists the default shortcut combinations for **resizing windows**.

**Note:** Minor resize actions occur on the RIGHT and BOTTOM edges of the window.

Keyboard Shortcut | Action | Description
--- | --- | ---
**Minor Resize shortcuts** | [ *Resize window by 50px* ] |
Alt+Win+Shift + Up | Resize window shorter | Decrease height
Alt+Win+Shift + Down | Resize window taller | Increase height
Alt+Win+Shift + Left | Resize window narrower | Ddecrease width
Alt+Win+Shift + Right | Resize window wider | Increase width
Alt+Win+Shift + PgUp | Resize window smaller | Decrease width and height
Alt+Win+Shift + PgDn | Resize window larger | Increase width and height

### Special Move/Resize commands
Keyboard Shortcut | Action | Description
--- | --- | ---
**Major Resize shortcuts** |
Alt+Win + Enter<br><br>Alt+Win+Shift + Enter | Resize to full extent of monitor | Max width and height of monitor
Alt+Win+Shift + Home | Resize to three quarters of monitor size| 3/4 width and height of monitor
Alt+Win+Shift + Del | Resize to half the monitor size| 1/2 width and height of monitor
**Restore Size / Position** |
Alt+Win + BackSpace | Restore window to previous position (not size)
Alt+Win+Shift + BackSpace | Restore window to previous size and position

## Technical details:
Uses [AutoHotkey](https://www.autohotkey.com/).

Works for Windows 10

## Manual Installation Instructions:
1. Download the Windows executable: AltWinKeys-v0.1.exe
2. Include the EXE in the windows Startup folder. (or run it on demand)

### Where is the Startup folder on the Windows Start Menu?

> - Your personal startup folder should be C:\Users\<user name>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup.
> - The All Users startup folder should be C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup.
> - Enable viewing of hidden folders to see them.

From [answers.microsoft.com](https://answers.microsoft.com/en-us/windows/forum/all/how-to-get-startup-folder-in-start-all-programs/d3f5486a-16c0-4e69-8446-c50dd35163f1#:~:text=Your%20personal%20startup%20folder%20should,if%20they%20aren't%20there.)
