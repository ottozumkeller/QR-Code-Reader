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

## Features

- Scan QR codes directly from your computer screen with the familiar interface of Windows Snipping Tool.
- Copy the content of QR codes to the clipboard and display a notification.
- Directly open Weblinks and other URI's in your default browser or specified programm via a notification.
- Directly connect to WiFi-Networks via a notification. *(Currently only supports WPA2-Personal authenticated networks)*

  
## System Requirements

- Windows 10 Version 2004 (20H1) or later (Check your Version under <a href="https://tinyurl.com/4pxm8wes">`Settings > System > Info`</a>) <a href=".\#Notes"><sup>*</sup></a>
- Windows Snipping Tool must be installed
- *(Recommended)* For the fastest possible response, disable notifications for Snipping Tool under <a href="https://tinyurl.com/35mdtcsk">`Settings > System > Notifications`</a> <a href=".\#Notes"><sup>*</sup></a>


## Installation and Usage

1. Install the MSI package from:<br>
     #### GitHub
     Download the .msi package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)<br>
     #### WinGet
     Run the following command in a Cmd, PowerShell or Terminal window
      ```cmd
      winget install OttoZumkeller.QR-CodeReader
      ```

3. Start QR-Code Reader from:
   - The start menu
   - The key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd> *(recognized after first launch)*
   - A click on the system tray icon *(visible after first launch)*

4. Select the QR code or the whole screen via Windows Snipping Tool.
5. The content of the QR code is copied to the clipboard and displayed in a notification (if it is a valid URL, it can be opened directly via the integrated button)


## Screenshots

<details>
    <summary>Show Screenshot Collection</summary><br>
    <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_collection.png" />
</details>


## Notes
\* Links with an asterisk have been shortend with [tinyurl.com](https://tinyurl.com/app) for greater convenience, because Github doesn't allow "ms-settings://" links ☹️.


