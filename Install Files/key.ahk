#SingleInstance Force

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
Tray.add "Open", Scan
Tray.add
Tray.add "Reload", Load
Tray.add "Close", Close

#!Q::
{
    Scan()
}

Scan(*)
{
    Run('"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File "C:\Program Files (x86)\QR-Code Reader\read.ps1"', , "Hide")
    Exit
}

Load(*)
{
    Reload
}

Close(*)
{
    ExitApp
}

Exit
