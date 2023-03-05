@ECHO OFF
TITLE CloudCoin Manager Portable - version
SET CLOUDCOINMANAGERPORTABLE_current_version=
SET CLOUDCOINMANAGERPORTABLE_version=
IF EXIST "%CD%\version.tmp" DEL "%CD%\version.tmp"

IF EXIST "%CD%\version.txt" FOR /F "tokens=* delims=" %%G in (version.txt) DO IF NOT "%%~G" == "" CALL :set_current_version "%%~G" & GOTO skip_current_version
GOTO skip_current_version
:set_current_version
SET CLOUDCOINMANAGERPORTABLE_current_version=%~1
EXIT /B
:skip_current_version

ECHO Current version: %CLOUDCOINMANAGERPORTABLE_current_version%
ECHO. & ECHO Checking for new version...
bitsadmin.exe /TRANSFER "CloudCoin Manager Portable Version Check" /DOWNLOAD /DYNAMIC "https://raw.githubusercontent.com/BigRedBrent/CloudCoinManagerPortable/main/version.txt" "%CD%\version.tmp" > NUL
CLS
IF NOT EXIST "%CD%\version.tmp" GOTO version_done

FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "" CALL :set_version "%%~G" & GOTO skip_version
GOTO skip_version
:set_version
SET CLOUDCOINMANAGERPORTABLE_version=%~1
EXIT /B
:skip_version
IF EXIST "%CD%\version.tmp" DEL "%CD%\version.tmp"

IF "%CLOUDCOINMANAGERPORTABLE_version%" == "" GOTO version_done
IF NOT "%CLOUDCOINMANAGERPORTABLE_current_version%" == "" (
    ECHO Current version: %CLOUDCOINMANAGERPORTABLE_current_version%
    IF "%CLOUDCOINMANAGERPORTABLE_current_version%" == "%CLOUDCOINMANAGERPORTABLE_version%" (
        ECHO. & ECHO You have the latest version.
        FOR %%G IN ("3") DO TIMEOUT /T %%~G /NOBREAK> NUL 2>&1 || PING -n %%~G 127.0.0.1 >NUL 2>&1 || PING -n %%~G ::1 >NUL 2>&1 || PAUSE
        GOTO version_done
    )
)
ECHO. & ECHO New version available: %CLOUDCOINMANAGERPORTABLE_version%
ECHO.
PAUSE
:version_done
EXIT
