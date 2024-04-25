@echo off

set "version=1.1.3"

ahk2exe.exe /in "..\Source\reader.ahk" /out ".\reader.exe" /base "autohotkey32.exe" /silent
"Wix Toolset 3.11\candle.exe" setup.wxs -ext "WixUIExtension"
"Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-%version%-x86.msi"

del reader.exe *.wixobj *.wixpdb

ahk2exe.exe /in "..\Source\reader.ahk" /out ".\reader.exe" /base "autohotkey64.exe" /silent
"Wix Toolset 3.11\candle.exe" setup.wxs -ext "WixUIExtension"
"Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-%version%-x64.msi"

del reader.exe *.wixobj *.wixpdb

pause