IF "%~1" == "" EXIT

IF DEFINED CLOUDCOINMANAGERPORTABLE_no_version_check GOTO version_done
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt" (
    FOR %%G IN ("%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt") DO SET CLOUDCOINMANAGERPORTABLE_file_date=%%~tG
    SET CLOUDCOINMANAGERPORTABLE_file_date=%CLOUDCOINMANAGERPORTABLE_file_date:~0,10%
    SET CLOUDCOINMANAGERPORTABLE_current_date=%DATE%
    SET CLOUDCOINMANAGERPORTABLE_current_date=%CLOUDCOINMANAGERPORTABLE_current_date:~-10%
    IF "%CLOUDCOINMANAGERPORTABLE_current_date%" == "%CLOUDCOINMANAGERPORTABLE_file_date%" GOTO version_done
)

TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version% - Checking Version
SET CLOUDCOINMANAGERPORTABLE_new_version=
CALL :version_done
ECHO. & ECHO Checking for update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
BITSADMIN /CANCEL "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO version_done
BITSADMIN /CREATE /DOWNLOAD "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%CLOUDCOINMANAGERPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
BITSADMIN /TRANSFER "%CLOUDCOINMANAGERPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/version.txt" "%CD%\version.tmp" > NUL 2>&1
BITSADMIN /CANCEL "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :version_remove_job "%%G"
GOTO version_skip_remove_job
:version_remove_job
SET CLOUDCOINMANAGERPORTABLE_version_guid=%~1
ECHO %~1 | FIND "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %CLOUDCOINMANAGERPORTABLE_version_guid:~0,38% > NUL 2>&1
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
    IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" > NUL 2>&1 || GOTO version_done
    ECHO %CLOUDCOINMANAGERPORTABLE_version% %DATE% %TIME: =0%> "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
    GOTO version_done
)

TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
:version_redo_choice
CLS
ECHO. & ECHO Update available: %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% & ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "Download and update [Y/N]?" /N
IF %ERRORLEVEL% == 24 GOTO version_done
IF NOT %ERRORLEVEL% == 35 GOTO version_redo_choice
COPY /V /Y update.cmd update.tmp.cmd || GOTO version_done
START "" update.tmp.cmd "1" & EXIT

:version_done
DEL /Q "*.tmp" > NUL 2>&1
DEL /A:H /Q "*.tmp" > NUL 2>&1
EXIT /B
