QR Code Reader is a QR code scanner application that allows you to scan and encode QR codes directly from your computer screen.
This app is made possible by Windows Snipping Tool, [ZBar](https://github.com/mchehab/zbar), [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) and [BurntToast](https://github.com/Windos/BurntToast).


## Requirements:

- Windows 10 21H2
- Permission to run remote scripts
<br>(Enable Switch under `Settings > Privacy and Security / System > For Developers > PowerShell`)


## Usage:

1. Download the MSI package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)
2. Install the MSI package
3. Start QR-Code Reader from
   - the start menu
   - the key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>
   - a click on the system tray icon
4. Select the area with the QR code or the whole screen via Windows Snipping Tool.
5. The content of the QR code is copied to the clipboard and displayed in a notification (if it is a valid link, it can be opened directly via the integrated button)

