@echo off

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /base "AutoHotkey\AutoHotkey64.exe" /silent /compress 0
"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs
"Wix Toolset 3.11\light.exe" -ext WixUIExtension "setup.wixobj" -out "QR-Code-Reader-X.X.X-Mode-0.msi"
del *.wixobj
del *.wixpdb

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /base "AutoHotkey\AutoHotkey64.exe" /silent /compress 1
"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs
"Wix Toolset 3.11\light.exe" -ext WixUIExtension "setup.wixobj" -out "QR-Code-Reader-X.X.X-Mode-1.msi"
del *.wixobj
del *.wixpdb

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /base "AutoHotkey\AutoHotkey64.exe" /silent /compress 2
"Wix Toolset 3.11\candle.exe" ..\Source\setup.wxs
"Wix Toolset 3.11\light.exe" -ext WixUIExtension "setup.wixobj" -out "QR-Code-Reader-X.X.X-Mode-2.msi"
del *.wixobj
del *.wixpdb

pause