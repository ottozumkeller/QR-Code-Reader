@echo off

set "version=1.1.2"

ahk2exe.exe /in "..\Source\reader.ahk" /out ".\reader.exe" /base "autohotkey32.exe" /silent
powershell -Command "&{ps2exe.ps1 -inputFile ..\Source\connect.ps1 -outputFile 'connect.exe' -iconFile ..\Source\qr_reader_dark.ico -title 'QR-Code Reader' -description 'QR-Code Reader' -product 'QR-Code Reader' -version %version% -copyright 'Otto Zumkeller 2024' -noConsole -noOutput -noError -noVisualStyles -x86}"
"Wix Toolset 3.11\candle.exe" setup.wxs -ext "WixUIExtension"
"Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-%version%-x86.msi"


ahk2exe.exe /in "..\Source\reader.ahk" /out ".\reader.exe" /base "autohotkey64.exe" /silent
powershell -Command "&{ps2exe.ps1 -inputFile ..\Source\connect.ps1 -outputFile 'connect.exe' -iconFile ..\Source\qr_reader_dark.ico -title 'QR-Code Reader' -description 'QR-Code Reader' -product 'QR-Code Reader' -version %version% -copyright 'Otto Zumkeller 2024' -noConsole -noOutput -noError -noVisualStyles -x64}"
"Wix Toolset 3.11\candle.exe" setup.wxs -ext "WixUIExtension"
"Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-%version%-x64.msi"

del reader.exe connect.exe *.wixobj *.wixpdb

if %errorlevel% neq 0 pause