<br>
<div align="center">
  
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/logo_dark.png#gh-dark-mode-only" height="200px"/>
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/logo_light.png#gh-light-mode-only" height="200px"/>
  <br><br>
  
  # QR-Code Reader
  QR-Code Reader is a barcode scanner application that allows you to scan and decode QR codes (and other barcodes) directly
  from your computer screen.<br>This app is made possible by Windows Snipping Tool, the [ZXing.Net library](https://github.com/micjahn/ZXing.Net) and [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey).
  <br><br><br>
  [![](https://img.shields.io/github/v/tag/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=Version&amp;logo=GitHub&amp;color=2ea043)](https://github.com/ottozumkeller/QR-Code-Reader/releases)
  [![](https://img.shields.io/github/downloads/ottozumkeller/QR-Code-Reader/total?style=for-the-badge&amp;label=Downloads&amp;logo=GitHub&amp;color=2f81f7)](https://github.com/ottozumkeller/QR-Code-Reader/releases)
  [![](https://img.shields.io/github/stars/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=Stars&amp;logo=GitHub&amp;color=e3b341)](https://github.com/ottozumkeller/QR-Code-Reader/stargazers)
    
</div>
<br>

## Features

- Scan barcodes directly from your computer screen with the familiar interface of Windows Snipping Tool.<br>

  > Supported formats:<br>
  > QR Code - EAN-8 - EAN-13 - Data Matrix - Aztec - PDF-417 - Code 39 - Code 93 - Code 128 - UPC-A - UPC-E - ITF - Codabar - MSI - RSS-14

- Copy the content of barcodes to the clipboard and display a notification.<br>
- Directly open weblinks in your default browser via a notification.<br>
- Directly connect to WiFi-Networks via a notification.

  > WiFi-Support is currently experimental; if you notice any bugs report them under [Issues](https://github.com/ottozumkeller/QR-Code-Reader/issues)
  
## System Requirements

- Windows 10 Version 2004 (20H1) or later
  
  > Check your Version under [Settings > System > About](https://tinyurl.com/4xscs5wb) <sup>[*](.\#Notes)</sup>
- Windows Snipping Tool must be installed
  
  > It is recommended to turn off the notifications for Snipping Tool under [Settings > System > Notifications](https://tinyurl.com/yff2j59d) <sup>[*](.\#Notes)</sup> to immediately receive only the notification from QR-Code Reader.

## Installation

- You can install QR-Code Reader from the following sources:<br>
  #### GitHub
    - Download the .msi package under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)<br>
  #### WinGet
    - Run the following command in a Command Line, PowerShell or Terminal window
      
      ```cmd
      winget install OttoZumkeller.QR-CodeReader

## Usage

- Open QR-Code Reader from:
   - The start menu
   - The key combination <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd>
   - A click on the system tray icon

- Select an area, window or the whole screen via Windows Snipping Tool.
- The content of the barcode is copied to the clipboard and displayed in a notification.

   > For some QR codes the notification will display a custom action like "Follow Link" or "Connect" (see [Screenshot Collection](.\#Screenshots))

## Screenshots

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

#

  <sub>* Links with an asterisk have been shortend with [tinyurl.com](https://tinyurl.com/app) for greater convenience, because Github doesn't allow "ms-settings://" links ☹️</sub>
