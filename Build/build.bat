
@echo off
del ..\Source\key.exe
del ..\Source\read.exe
del ..\Source\actions.exe

AutoHotkey\ahk2exe.exe /in "..\Source\key.ahk" /base "AutoHotkey\autohotkey.exe" /compress 2 /silent

powershell -Command "&{ps2exe.ps1 ..\Source\read.ps1 ..\Source\read.exe -iconFile ..\Source\qr_reader.ico -title 'QR-Code Reader' -version 1.0.0 -product 'QR-Code Reader' -copyright 'Copyright Otto Zumkeller 2023' -noConsole -noOutput}"
powershell -Command "&{ps2exe.ps1 ..\Source\actions.ps1 ..\Source\actions.exe -iconFile ..\Source\qr_reader.ico -title 'QR-Code Reader Action Handler' -version 1.0.0 -product 'QR-Code Reader Action Handler' -copyright 'Copyright Otto Zumkeller 2023' -noConsole -noOutput}"

"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs
"Wix Toolset 3.11\light.exe" -ext WixUIExtension "setup.wixobj" -out "Setup.msi"

del setup.wixobj
del setup.wixpdb
pause