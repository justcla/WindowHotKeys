# Alt+Win HotKeys
## Shortcuts to move and resize windows in Windows.<br>

### !! Including shortcuts to <u>Move Windows between Virtual Desktops</u>!!
<br>

![Alt+Win HotKeys logo](https://user-images.githubusercontent.com/17131343/87220588-6f73bf00-c3a8-11ea-9ae1-1919b0ad552c.png)

Download the **Installation Wizard**
- Download the [Windows installer MSI](https://github.com/justcla/WindowHotKeys/blob/master/Packaging/AltWin-HotKeys.msi?raw=true) <br>
- Note MSI Windows Installer installs the EXE plus additional shortcut profiles and config file.
- Also installs

*Alternatively* - to just get the EXE (no extra profiles and config files):
- Download and run the executable [AltWin-HotKeys.exe](https://github.com/justcla/WindowHotKeys/raw/master/Packaging/AltWin-HotKeys.exe)

*Admin User Issues?*
- Install [AutoHotKey](http://autohotkey.com/) on your machine. (You might have better luck getting that through IT/Networking/Admin)
- Run the [AltWin-Hotkey AHK script](https://github.com/justcla/WindowHotKeys/blob/master/AltWin-HotKeys.ahk) directly

## Latest Stable Release

* Go to [latest release](https://github.com/justcla/WindowHotKeys/releases/latest) for all options

[![Move window with Alt+Win + (direction)](https://user-images.githubusercontent.com/17131343/87670959-ed263900-c7b3-11ea-9575-bf87f05f28fb.png)](https://www.youtube.com/watch?v=iSf4AKjFQLs&t=18)

**Move Window:** Alt+Win + [Up/Down/Left/Right/PgUp/PgDn/Home/End/Del]

**Move Window between Virtual Desktops:** Ctrl+Shift+Win + [Left/Right]<br>
*Note: Will create a new Virtual Desktop if needed and move the current window into it.*

**Resize Window:** Alt+Win+Shift + [Up/Down/Left/Right/PgUp/PgDn/Home/End/Del]

**Special move/resize:** Alt+Win+Shift + [Plus/Minus/Enter/Home/Del]

**4-column layout (move):** Alt+Win + [1/2/3/4/,(<)/.(>)]

**4-column layout (snap):** Alt+Win+Shift + [1/2/3/4/,(<)/.(>)]

**Tile/Cascade:** Alt+Win + [H/V/F12]

## Usage (Keyboard Shortcuts)

### Move Window between Virtual Desktops *(Ctrl+Shift+Win)*
The following table lists the default shortcut combinations for **moving windows between Virtual Desktops**.

Keyboard Shortcut | Action
--- | ---
Ctrl+Shift+Win + Left | Move window previous virtual desktop
Ctrl+Shift+Win + Right | Move window to next virtual desktop<br> *Note: Will create new v-desktop if needed*

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
Alt+Win+Shift + Left | Resize window narrower | Decrease width
Alt+Win+Shift + Right | Resize window wider | Increase width
Alt+Win+Shift + PgUp | Resize window smaller | Decrease width and height from bottom right corner
Alt+Win+Shift + PgDn | Resize window larger | Increase width and height from bottom right corner

### Special Move/Resize commands
Keyboard Shortcut | Action | Description
--- | --- | ---
**Resize from Center** |
Alt+Win + Minus<br><br>Alt+Win+Shift + Minus (-/NumMinus) | Shrink window | Decrease width and height from center
Alt+Win + Plus<br><br>Alt+Win+Shift + Plus (=/NumPlus) | Grow window | Increase width and height from center
**Major Resize shortcuts** |
Alt+Win + Enter<br><br>Alt+Win+Shift + Enter | Resize to full extent of monitor | Max width and height of monitor
Alt+Win+Shift + Home | Center and Resize to three quarters of monitor size| 3/4 width and height of monitor
Alt+Win+Shift + Del | Center and Resize to half the monitor size| 1/2 width and height of monitor
**Restore Size / Position** |
Alt+Win + BackSpace | Restore window to previous position (not size)
Alt+Win+Shift + BackSpace | Restore window to previous size and position
**Tile and Cascade** |
Alt+Win + V<br><br>Alt+Win+Shift + V | Tile windows Vertically
Alt+Win + H<br><br>Alt+Win+Shift + H | Tile windows Horizontally
Alt+Win + F12<br><br>Alt+Win+Shift + F12 | Cascade windows

### 4-Column Layout shortcuts

Use the following shortcuts to align and resize windows to fit four vertical columns across the screen.
Useful for very wide monitors.

Keyboard Shortcut | Action
--- | ---
**Move window (no resize)** | [ *Align left edge of window with column grid* ] |
Alt+Win + 1 | Move window to Column 1
Alt+Win + 2 | Move window to Column 2
Alt+Win + 3 | Move window to Column 3
Alt+Win + 4 | Move window to Column 4
Alt+Win + ,(<) | Move window to the Column on the Left
Alt+Win + .(>) | Move window to the Column on the Right
**Move and Resize shortcuts** | [ *Snap to Column grid (move and resize)* ] |
Alt+Win+Shift + 1 | Snap window to Column 1
Alt+Win+Shift + 2 | Snap window to Column 2
Alt+Win+Shift + 3 | Snap window to Column 3
Alt+Win+Shift + 4 | Snap window to Column 4
Alt+Win+Shift + ,(<) | Snap window to the Column on the Left
Alt+Win+Shift + .(>) | Snap window to the Column on the Right

## Additional Windows Shortcuts
### Adjust Volume *(Ctrl+Alt+ NumPad Plus/Minus/Asterisk)*
The following table lists the default shortcut combinations for **adjusting volume**.

Keyboard Shortcut | Action
--- | ---
Ctrl+Alt+NumPadAdd (NumPad +)| Volume Up
Ctrl+Alt+NumPadSub (NumPad -)| Volume Down
Ctrl+Alt+NumPadMult (NumPad *) | Volume Mute

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
