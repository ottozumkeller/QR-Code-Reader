ahk2exe.exe /in "..\Source\key.ahk" /base "autohotkey.exe" /compress 2 /silent
powershell -command "&{ps2exe.ps1 ..\Source\read.ps1 ..\Source\read.exe -iconFile ..\Source\qr_reader.ico -title 'QR-Code Reader' -version 1.0.0.0 -product 'QR-Code Reader' -copyright 'Copyright Otto Zumkeller 2023' -noConsole -noOutput}"

candle.exe ..\Source\setup.wxs
light.exe -ext WixUIExtension "setup.wixobj" -out "Setup.msi"

del setup.wixobj
del setup.wixpdb
pause