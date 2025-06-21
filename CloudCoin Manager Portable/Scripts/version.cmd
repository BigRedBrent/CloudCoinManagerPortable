IF "%~1" == "" EXIT

IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" > NUL 2>&1 || GOTO version_done
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\" RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO version_done
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" DEL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO version_done
CALL :version_done
IF DEFINED CLOUDCOINMANAGERPORTABLE_no_version_check GOTO version_done
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt" GOTO version_start
FOR %%G IN ("%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt") DO SET CLOUDCOINMANAGERPORTABLE_file_date=%%~tG
IF "%CLOUDCOINMANAGERPORTABLE_file_date:~0,10%" == "%DATE:~-10%" IF NOT "%CLOUDCOINMANAGERPORTABLE_file_date:~0,10%" == "" GOTO version_done

:version_start
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version% - Checking Version
SET CLOUDCOINMANAGERPORTABLE_new_version=
CALL :version_done
ECHO. & ECHO Checking for update...
WHERE powershell >NUL 2>&1 || GOTO version_done
powershell -Command "$ErrorActionPreference = 'Stop';" "try { Invoke-WebRequest -Uri 'https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/version.txt' -TimeoutSec 5 -OutFile '%CLOUDCOINMANAGERPORTABLE_home_dir%\\Settings\\version.tmp' } catch { exit 1 }" || GOTO version_done
CLS
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.tmp" GOTO version_done

CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
FOR /F "tokens=* delims=" %%G in (version.tmp) DO IF NOT "%%~G" == "" CALL :set_version "%%~G" & GOTO skip_version
GOTO skip_version
:set_version
SET CLOUDCOINMANAGERPORTABLE_new_version=%~1
EXIT /B
:skip_version
CD /D "%~dp0"

CALL :version_done

IF "%CLOUDCOINMANAGERPORTABLE_new_version%" == "" GOTO version_done
IF NOT "%CLOUDCOINMANAGERPORTABLE_version%" == "%CLOUDCOINMANAGERPORTABLE_new_version%" GOTO version_next
ECHO %CLOUDCOINMANAGERPORTABLE_version% %DATE:~-10% %TIME: =0%> "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
GOTO version_done
:version_next

TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
:version_redo_choice
CLS
ECHO. & ECHO Update available: %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% & ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "Download and update [Y/N]?" /N
IF %ERRORLEVEL% == 24 GOTO version_done
IF NOT %ERRORLEVEL% == 35 GOTO version_redo_choice
CALL update.cmd "1"

:version_done
DEL /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
DEL /A:H /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\*.tmp" > NUL 2>&1
EXIT /B
