@ECHO OFF
TITLE CloudCoin Manager Portable - error
IF "%~1" == "" EXIT
CLS
ECHO.
ECHO.
ECHO     %~1
ECHO.
ECHO.
IF "%~2" == "" PAUSE & EXIT
FOR %%G IN ("%~2") DO TIMEOUT /T %%~G /NOBREAK> NUL 2>&1 || PING -n %%~G 127.0.0.1 >NUL 2>&1 || PING -n %%~G ::1 >NUL 2>&1 || PAUSE
EXIT
