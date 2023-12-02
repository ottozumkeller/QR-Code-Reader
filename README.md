<br>
<p align="center">
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/logo.png" height="150px"/><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<h1 align="center">QR-Code Reader</h1>
  <p align="center">
    QR-Code Reader is a QR code scanner application that allows you to scan and decode QR codes directly<br>
    from your computer screen. This app is made possible by Windows Snipping Tool, <a href="https://github.com/mchehab/zbar">ZBar</a> and <a href="https://github.com/AutoHotkey/AutoHotkey">AutoHotkey</a>.
    <br><br>
    <a href="https://github.com/ottozumkeller/QR-Code-Reader/releases"><img alt="Current Version" src="https://img.shields.io/github/v/tag/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=Version&amp;logo=GitHub&amp;color=2ea043"></a>
    &nbsp;
    <a href="https://github.com/ottozumkeller/QR-Code-Reader/releases"><img alt="Downloads" src="https://img.shields.io/github/downloads/ottozumkeller/QR-Code-Reader/total?style=for-the-badge&amp;label=Downloads&amp;logo=GitHub&amp;color=2f81f7"></a>
    &nbsp;
    <a href="https://github.com/ottozumkeller/QR-Code-Reader/stargazers"><img alt="GitHub Stars" src="https://img.shields.io/github/stars/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=Stars&amp;logo=GitHub&amp;color=e3b341"></a>
  </p>
</p>
<br>

## :rocket: Features

- Scan QR codes directly from your computer screen with the familiar interface of Windows Snipping Tool.<br>
- Copy the content of QR codes to the clipboard and display a notification.<br>
- Directly open Weblinks in your default browser via a notification.<br>
- Directly connect to WiFi-Networks via a notification.

  > WiFi-Support is currently experimental; if you notice any bugs report them under [Issues](https://github.com/ottozumkeller/QR-Code-Reader/issues)
  
## :computer: System Requirements

- Windows 10 Version 2004 (20H1) or later
  
  > Check your Version under [Settings > System > About](https://tinyurl.com/4pxm8wes) <sup>[*](.\#Notes)</sup>
- Windows Snipping Tool must be installed
  
  > It is recommended to turn off the notifications for Snipping Tool under [Settings > System > Notifications](https://tinyurl.com/35mdtcsk) <sup>[*](.\#Notes)</sup> to immediately receive only the notification from QR-Code Reader.

## :cd: Installation

- You can install QR-Code Reader from the following sources:<br>
  #### GitHub
    - Download the .msi package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)<br>
  #### WinGet
    - Run the following command in a Command Line, PowerShell or Terminal window
      
      ```cmd
      winget install OttoZumkeller.QR-CodeReader

## :book: Usage

- Open QR-Code Reader from:
   - The start menu
   - The key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>
   - A click on the system tray icon

- Select the QR code or the whole screen via Windows Snipping Tool.
- The content of the QR code is copied to the clipboard and displayed in a notification.

   > For some QR codes the notification will display a custom action like "Follow Link" or "Connect" (see [Screenshot Collection](.\#Screenshots))

## :camera_flash: Screenshots

<details>
  <summary>&nbsp;Show Screenshot Collection</summary><br>
    <p float="left" width="100%">
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_1.png" width="49.5%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_2.png" width="49.5%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_3.png" width="49.5%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_4.png" width="49.5%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_5.png" width="49.5%" />
    </p>
</details>

## :memo: Notes

\* Links with an asterisk have been shortend with [tinyurl.com](https://tinyurl.com/app) for greater convenience, because Github doesn't allow "ms-settings://" links ☹️.
