QR-Code Reader is a QR code scanner application that allows you to scan and encode QR codes directly from your computer screen.
This app is made possible by Windows Snipping Tool, [ZBar](https://github.com/mchehab/zbar), [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) and [BurntToast](https://github.com/Windos/BurntToast).


## System Requirements:

- Windows 10 Version 2004 (20H1) or later
- Permission to execute remote scripts
  <br>(Change Setting under`Settings > Update and Security / System > For Developers > PowerShell`)


## Installation and Usage:

1. Download the MSI package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)
2. (‼️Important‼️) Make sure you have permission to execute remote scripts
3. Install the MSI package
4. Start QR-Code Reader from
   - The start menu
   - The key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd> (recognized after first launch)
   - A click on the system tray icon (visible after first launch)
5. Select the QR code or the whole screen via Windows Snipping Tool. (It is recommended to select the QR-Code with as little different colored surrounding content as possible to ensure a correct recognition.)
6. The content of the QR code is copied to the clipboard and displayed in a notification (if it is a valid link, it can be opened directly via the integrated button)

