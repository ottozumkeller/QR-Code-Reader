
@echo off
del ..\Source\reader.exe

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /base "AutoHotkey\AutoHotkey64.exe" /silent /compress 2

"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs
"Wix Toolset 3.11\light.exe" -ext WixUIExtension "setup.wixobj" -out "QR-Code-Reader-X.X.X.msi"

del setup.wixobj
del QR-Code-Reader-X.X.X.wixpdb
pause