#SingleInstance Force

;@Ahk2Exe-SetName QR-Code Reader
;@Ahk2Exe-SetDescription QR-Code Reader
;@Ahk2Exe-SetVersion 1.0.3
;@Ahk2Exe-AddResource qr_reader_dark.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource qr_reader_dark.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource qr_reader_dark.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource qr_reader_dark.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetMainIcon qr_reader_dark.ico
;@Ahk2Exe-UseResourceLang 0x0001
;@Ahk2Exe-SetOrigFilename key.exe
;@Ahk2Exe-SetInternalName key.exe
;@Ahk2Exe-SetCopyright Copyright Otto Zumkeller 2023

A_IconTip := "QR-Code Reader"

OnMessage(0x404, Callback)
Callback(wParam, lParam, uMsg, hWnd)
{
    if (lParam = 0x201) {
        Scan()
    }
}

Color()
Color() 
{
    static Theme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", Theme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", Theme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", 1)
    DllCall(FlushMenuThemes)
}

Tray := A_TrayMenu
Tray.delete()
Tray.add("Scan", Scan)
Tray.Default := "Scan"
Tray.addStandard()
Tray.delete("&Suspend Hotkeys")
Tray.delete("&Pause Script")

SetTimer(Check, 2000)

#!Q::
{
    Scan()
}

Scan(*)
{
    Run("read.exe", , "Hide")
}

Check()
{
    if (RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", "SystemUsesLightTheme") = 1) {
        TraySetIcon("qr_reader_light.ico")
    } else {
        TraySetIcon("qr_reader_dark.ico")
    }
}