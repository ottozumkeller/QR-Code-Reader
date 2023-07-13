@set PATH=%PATH%;C:\Program Files (x86)\ZBar\bin
@echo This is the zbarcam output window.
@echo Hold a bar code in front of the camera (make sure it's in focus!)
@echo and decoded results will appear below.
@echo.
@echo Initializing camera, please wait...
@echo.
@zbarcam.exe --prescale=640x480
@if errorlevel 1 pause
