@echo off & setlocal enabledelayedexpansion
cls
cd "Q:\QR-Reader"
start /b /min "C:\Users\ottoz\AppData\Local\Programs\AutoHotkey\UX\AutoHotkeyUX.exe" "C:\Users\ottoz\OneDrive\Dokumente\AutoHotkey\QR-Code Reader.ahk"
start explorer ms-screenclip:

:wait
timeout /t 2 /nobreak > nul
set ftime=%time:~,2%%time:~3,2%%time:~6,2%
tasklist | find "ScreenClippingHost.exe" > nul
if errorlevel 1 goto next
goto wait

:next
set fdate=%date:~6%-%date:~3,2%-%date:~,2%
set "dir=C:\Users\ottoz\OneDrive\Bilder\Screenshots\"
set i=0

:check
if exist "%dir%Screenshot %fdate% %ftime%.png" (
    set "file=Screenshot %fdate% %ftime%.png"
) else (
    set "file="
    set /a ftime-=1
    set /a i+=1
    if %i% LSS 5 goto check
)

if "%file%" NEQ "" (
    for /f %%i in ('zbarimg.exe -q --raw "%dir%%file%"') do set output=%%i
    if "!output!" NEQ "" echo !output! | clip
    del "%dir%%file%"
    powershell -ExecutionPolicy Unrestricted -File "message.ps1" "!output!"
)
exit
