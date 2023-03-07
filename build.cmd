@ECHO OFF
ECHO. & ECHO 3 & ECHO. & PAUSE & CLS & ECHO. & ECHO 2 & ECHO. & PAUSE & CLS & ECHO. & ECHO 1 & ECHO. & PAUSE & CLS
CD /D "%~dp0"
DEL "%CD%\version.tmp" >NUL 2>&1
DEL "%CD%\CloudCoinManagerPortable.tmp" >NUL 2>&1
COPY /V /Y "%CD%\CloudCoin Manager Portable\Scripts\version.txt" "%CD%\version.tmp" >NUL 2>&1 || GOTO build_fail
MOVE /Y "%CD%\version.tmp" "%CD%\version.txt" >NUL 2>&1 || GOTO build_fail
"%CD%\CloudCoin Manager Portable\Scripts\7za.exe" a -tzip "%CD%\CloudCoinManagerPortable.tmp" "%CD%\CloudCoin Manager Portable\" -mx=9 || GOTO build_fail
MOVE /Y "%CD%\CloudCoinManagerPortable.tmp" "%CD%\CloudCoinManagerPortable.zip" >NUL 2>&1 || GOTO build_fail
ECHO.
ECHO Completed successfully.
ECHO.
PAUSE
EXIT
:build_fail
ECHO.
ECHO Failed!
ECHO.
DEL "%CD%\version.tmp" >NUL 2>&1
DEL "%CD%\CloudCoinManagerPortable.tmp" >NUL 2>&1
PAUSE
