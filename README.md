<p align="center">
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/logo.png" width="150" />
  <h2 align="center">QR-Code Reader</h2>
</p>

QR-Code Reader is a QR code scanner application that allows you to scan and decode QR codes directly from your computer screen.
This app is made possible by Windows Snipping Tool, [ZBar](https://github.com/mchehab/zbar) and [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey).


## Features

- Scan QR codes directly from your computer screen with the familiar interface of Windows Snipping Tool.
- Copy the content of QR codes to the clipboard and display a notification.
- Directly open Weblinks and other URI's in your default browser or specified programm via a notification.
- Directly connect to WiFi-Networks via a notification. *(Currently only supports WPA2-Personal authenticated networks)*

  
## System Requirements

- Windows 10 Version 2004 (20H1) or later
- Windows Snipping Tool must be installed
- *(Recommended)* For the fastest possible response, disable notifications for Snipping Tool <br>under `Settings > Notifications`


## Installation and Usage

1. Download the MSI package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)
3. Install the MSI package
4. Start QR-Code Reader from
   - The start menu
   - The key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd> (recognized after first launch)
   - A click on the system tray icon (visible after first launch)
5. Select the QR code or the whole screen via Windows Snipping Tool. (It is recommended to select the QR-Code with as little different colored surrounding content as possible to ensure a correct recognition.)
6. The content of the QR code is copied to the clipboard and displayed in a notification (if it is a valid URL, it can be opened directly via the integrated button)


## Screenshots

<details>
    <summary>Show Screenshot Collection</summary><br>
    <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_collection.png" />
</details>


