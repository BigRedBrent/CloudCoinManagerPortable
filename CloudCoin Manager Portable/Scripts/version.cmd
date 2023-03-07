@ECHO OFF
TITLE CloudCoin Manager Portable - Checking Version
SET CLOUDCOINMANAGERPORTABLE_version=
SET CLOUDCOINMANAGERPORTABLE_new_version=
CD /D "%~dp0"
CALL :version_done

IF EXIST "version.txt" FOR /F "tokens=* delims=" %%G in (version.txt) DO IF NOT "%%~G" == "" CALL :set_current_version "%%~G" & GOTO skip_current_version
GOTO skip_current_version
:set_current_version
SET CLOUDCOINMANAGERPORTABLE_version=%~1
EXIT /B
:skip_current_version
IF "%CLOUDCOINMANAGERPORTABLE_version%" == "" GOTO version_done
TITLE CloudCoin Manager Portable %CLOUDCOINMANAGERPORTABLE_version% - Checking Version

ECHO. & ECHO Checking for script update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
BITSADMIN /CANCEL "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO version_done
BITSADMIN /CREATE /DOWNLOAD "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" NULL NULL > NUL 2>&1
BITSADMIN /TRANSFER "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/version.txt" "%CD%\version.tmp" > NUL 2>&1
BITSADMIN /CANCEL "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
GOTO version_skip_remove_job
:version_remove_job
SET CLOUDCOINMANAGERPORTABLE_version_guid=%~1
ECHO %~1 | FIND "CLOUDCOINMANAGERPORTABLE_VERSION_BITFC3UEVPCG8BJNGFRU" > NUL 2>&1 && BITSADMIN /CANCEL %CLOUDCOINMANAGERPORTABLE_version_guid:~0,38% > NUL 2>&1
EXIT /B
:version_skip_remove_job
CLS
IF NOT EXIST "version.tmp" GOTO version_done

FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "" CALL :set_version "%%~G" & GOTO skip_version
GOTO skip_version
:set_version
SET CLOUDCOINMANAGERPORTABLE_new_version=%~1
EXIT /B
:skip_version

CALL :version_done

IF "%CLOUDCOINMANAGERPORTABLE_new_version%" == "" GOTO version_done
IF "%CLOUDCOINMANAGERPORTABLE_version%" == "%CLOUDCOINMANAGERPORTABLE_new_version%" (
    ECHO. & ECHO. & ECHO You have the latest version.
    ::FOR %%G IN ("3") DO TIMEOUT /T %%~G /NOBREAK> NUL 2>&1 || PING -n %%~G 127.0.0.1 > NUL 2>&1 || PING -n %%~G ::1 > NUL 2>&1 || PAUSE
    GOTO version_done
)

TITLE CloudCoin Manager Portable %CLOUDCOINMANAGERPORTABLE_version%
:version_redo_choice
CLS
ECHO. & ECHO Script update available: CloudCoin Manager Portable %CLOUDCOINMANAGERPORTABLE_new_version% & ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "Download and update [Y/N]?" /N
IF %ERRORLEVEL% == 24 GOTO version_done
IF NOT %ERRORLEVEL% == 35 GOTO version_redo_choice
COPY /Y update.cmd update.tmp.cmd || GOTO version_done
START "" update.tmp.cmd "1" & EXIT

:version_done
DEL /Q "*.tmp" > NUL 2>&1
DEL /A:H /Q "*.tmp" > NUL 2>&1
EXIT /B
