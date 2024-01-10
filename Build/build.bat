@echo off

AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /out ".\X86\reader.exe" /base "AutoHotkey\AutoHotkey32.exe" /silent /compress 0
AutoHotkey\ahk2exe.exe /in "..\Source\reader.ahk" /out ".\X64\reader.exe" /base "AutoHotkey\AutoHotkey64.exe" /silent /compress 0

powershell -Command "&{ps2exe.ps1 -inputFile ..\Source\connect.ps1 -outputFile '.\X86\connect.exe' -iconFile ..\Source\qr_reader_dark.ico -title 'QR-Code Reader' -description 'QR-Code Reader' -product 'QR-Code Reader' -version 1.1.0 -copyright 'Otto Zumkeller 2024' -noConsole -noOutput -noError -noVisualStyles -x86}"
powershell -Command "&{ps2exe.ps1 -inputFile ..\Source\connect.ps1 -outputFile '.\X64\connect.exe' -iconFile ..\Source\qr_reader_dark.ico -title 'QR-Code Reader' -description 'QR-Code Reader' -product 'QR-Code Reader' -version 1.1.0 -copyright 'Otto Zumkeller 2024' -noConsole -noOutput -noError -noVisualStyles -x64}"

cd "X86"
"..\Wix Toolset 3.11\candle.exe" ..\setup.wxs -ext "WixUIExtension"
"..\Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-X.X.X-x86.msi"

del *.wixobj
del *.wixpdb
del *.exe

cd "..\X64"
"..\Wix Toolset 3.11\candle.exe" ..\setup.wxs -ext "WixUIExtension"
"..\Wix Toolset 3.11\light.exe" "setup.wixobj" -ext "WixUIExtension" -out "QR-Code-Reader-X.X.X-x64.msi"
del *.wixobj
del *.wixpdb
del *.exe

pause