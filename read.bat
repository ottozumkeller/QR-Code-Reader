@echo on & setlocal enabledelayedexpansion
cls
set fdate=%date:~6%-%date:~3,2%-%date:~,2%
start explorer ms-screenclip:
timeout /t 1 /nobreak >nul

:wait
set ftime=%time:~,2%%time:~3,2%%time:~6,2%
tasklist | find "ScreenClippingHost.exe"
if errorlevel 1 goto next
goto wait

:next
echo Check 1: "Screenshot %fdate% %ftime%.png"
set "dir=C:\Users\ottoz\OneDrive\Bilder\Screenshots\"
set i=0

:check
dir %dir% /b /a:-d-h-s /o:-d /t:c | find "Screenshot %fdate% %ftime%" > temp.log
if errorlevel 1 if %i% LSS 3 (
    set /a ftime-=1
    set /a i+=1
    echo Check 2: "Screenshot %fdate% %ftime%.png"
    goto check
)
set /p file= < temp.log
del temp.log
echo Check 3: "%file%"

set "output="
if "%file%" NEQ "" (
    Q:\QR-Reader\zbarimg.exe -q --raw "%dir%%file%" > out.log
    del "%dir%%file%"
    set /p output= < out.log
    echo Check 4: "%output%" "!output!"
    del out.log
    if "!output!" NEQ "" echo !output! | clip
    powershell -ExecutionPolicy Unrestricted -File "Q:\QR-Reader\message.ps1" "!output!"
)
exit
