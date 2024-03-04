<br>
<div align="center">
  
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/social_banner_dark.png#gh-dark-mode-only" width="100%"/>
  <img alt="QR-Code Reader Logo" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/social_banner_light.png#gh-light-mode-only" width="100%"/>
  <br><br>
  
  QR-Code Reader is a barcode scanner application that allows you to scan and decode barcodes directly
  from your computer screen.<br>This app is made possible by Windows Snipping Tool, [ZXing.Net](https://github.com/micjahn/ZXing.Net), [AutoHotkey](https://github.com/AutoHotkey/AutoHotkey) and [Ps2Exe](https://github.com/MScholtes/PS2EXE).
  <br><br><br>
  [![](https://img.shields.io/github/v/tag/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=version&amp;logo=github&amp;color=2ea043)](https://github.com/ottozumkeller/QR-Code-Reader/releases)
  [![](https://img.shields.io/github/downloads/ottozumkeller/QR-Code-Reader/total?style=for-the-badge&amp;label=downloads&amp;logo=github&amp;color=2f81f7)](https://github.com/ottozumkeller/QR-Code-Reader/releases)
  [![](https://img.shields.io/github/stars/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=stars&amp;logo=github&amp;color=e3b341)](https://github.com/ottozumkeller/QR-Code-Reader/stargazers)
  [![](https://img.shields.io/github/issues/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=issues&amp;logo=github&amp;color=2ea043)](https://github.com/ottozumkeller/QR-Code-Reader/issues)
  [![](https://img.shields.io/github/issues-closed/ottozumkeller/QR-Code-Reader?style=for-the-badge&amp;label=&amp;color=8159c3)](https://github.com/ottozumkeller/QR-Code-Reader/issues)
    
</div>
<br>

## Features

- Scan barcodes directly from your computer screen with the familiar interface of Windows Snipping Tool.<br>

  > For a full list of supported formats, see the [ZXing.Net Documentation](https://github.com/micjahn/ZXing.Net/blob/master/README.md) 

- Copy the content of barcodes to the clipboard and display a notification.<br>
- Directly open weblinks in your default browser via a notification.<br>
- Directly connect to WiFi-Networks via a notification.

  > WiFi-Support is currently experimental; if you notice any bugs report them under [Issues](https://github.com/ottozumkeller/QR-Code-Reader/issues)
  
## System Requirements

- Windows 10 Version 2004 (20H1) or later
  
  > Check your Version under [Settings > System > About](https://tinyurl.com/4xscs5wb) <sup>[*](.\#Notes)</sup>
- Windows Snipping Tool must be installed
  
  > *(Optional)* Turn off the notifications for Snipping Tool under [Settings > System > Notifications](https://tinyurl.com/yff2j59d) <sup>[*](.\#Notes)</sup> to immediately receive only the notification from QR-Code Reader.

## Installation

- You can install QR-Code Reader from the following sources:<br>
  #### GitHub
    - Download the .msi package for your architecture under [Releases](https://github.com/ottozumkeller/QR-Code-Reader/releases)<br>
  #### WinGet
    - Run the following command in a Command Line, PowerShell or Terminal window
      
      ```cmd
      winget install OttoZumkeller.QR-CodeReader

  #### Chocolatey
    - Use the following command
      
      ```cmd
      choco install qr-codereader

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
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_1_dark.png#gh-dark-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_1_light.png#gh-light-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_2_dark.png#gh-dark-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_2_light.png#gh-light-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_3_dark.png#gh-dark-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_3_light.png#gh-light-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_4_dark.png#gh-dark-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_4_light.png#gh-light-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_5_dark.png#gh-dark-mode-only" width="49%" />
      <img loading="lazy" src="https://github.com/ottozumkeller/QR-Code-Reader/blob/main/Images/screenshot_5_light.png#gh-light-mode-only" width="49%" />
    </p>
</details>

#

  <sub>* Links with an asterisk have been shortend with [tinyurl.com](https://tinyurl.com/app) for greater convenience, because Github doesn't allow "ms-settings://" links ☹️</sub>
