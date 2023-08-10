#SingleInstance Force

;@Ahk2Exe-SetName QR-Code Reader Hotkey Listener
;@Ahk2Exe-SetDescription QR-Code Reader Hotkey Listener
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-AddResource qr_reader.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource qr_reader.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource qr_reader.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource qr_reader.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetMainIcon qr_reader.ico
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

Tray := A_TrayMenu
Tray.delete
Tray.add "Scan", Scan
Tray.add "Close", Close

#!Q::
{
    Scan()
}

Scan(*)
{
    Run("read.exe", , "Hide")
}

Close(*)
{
    ExitApp
}

Exit