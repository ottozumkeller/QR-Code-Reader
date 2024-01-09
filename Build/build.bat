@echo off

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /base "AutoHotkey\AutoHotkey32.exe" /silent /compress 0

powershell -Command "&{ps2exe.ps1 ..\Source\connect.ps1 -iconFile ..\Source\qr_reader_dark.ico -title 'QR-Code Reader' -description 'QR-Code Reader' -product 'QR-Code Reader' -version 1.1.0 -copyright 'Otto Zumkeller 2024' -noConsole -noOutput -noError -noVisualStyles}"

"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs -ext "WixUIExtension" -ext "WixUtilExtension"
"Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -ext "WixUtilExtension" -out "QR-Code-Reader-X.X.X.msi"
del *.wixobj
del *.wixpdb

pause