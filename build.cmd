CALL :lock
EXIT /B
:lock
CALL :main 9>>"%~f0"
EXIT /B
:main
@ECHO OFF
CLS & ECHO. & ECHO 3 & ECHO. & PAUSE & CLS & ECHO. & ECHO 2 & ECHO. & PAUSE & CLS & ECHO. & ECHO 1 & ECHO. & PAUSE & CLS
CD /D "%~dp0"
DEL "*.tmp" >NUL 2>&1
COPY /Y "CloudCoin Manager Portable\Help.txt" "README.tmp" || GOTO build_fail
FC /B "CloudCoin Manager Portable\Help.txt" "README.tmp" || GOTO build_fail
MOVE /Y "README.tmp" "README.md" >NUL 2>&1 || GOTO build_fail
COPY /Y "CloudCoin Manager Portable\Changelog.txt" "CHANGELOG.tmp" || GOTO build_fail
FC /B "CloudCoin Manager Portable\Changelog.txt" "CHANGELOG.tmp" || GOTO build_fail
MOVE /Y "CHANGELOG.tmp" "CHANGELOG.md" >NUL 2>&1 || GOTO build_fail
CALL "CloudCoin Manager Portable\Start CloudCoin Manager Portable.cmd" "1"
IF "%CLOUDCOINMANAGERPORTABLE_version%" == "" GOTO build_fail
ECHO %CLOUDCOINMANAGERPORTABLE_version%> version.tmp
FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "%CLOUDCOINMANAGERPORTABLE_version%" GOTO build_fail
MOVE /Y "version.tmp" "version.txt" >NUL 2>&1 || GOTO build_fail
"%CD%\CloudCoin Manager Portable\Scripts\7za.exe" a -tzip "%CD%\CloudCoinManagerPortable.tmp" "%CD%\CloudCoin Manager Portable\" -mx=9 || GOTO build_fail
MOVE /Y "CloudCoinManagerPortable.tmp" "CloudCoinManagerPortable.zip" >NUL 2>&1 || GOTO build_fail
ECHO. & ECHO. & ECHO.
ECHO Completed successfully.
ECHO. & PAUSE & EXIT
:build_fail
ECHO. & ECHO. & ECHO.
ECHO Failed!
ECHO.
DEL "*.tmp" >NUL 2>&1
PAUSE
EXIT
