@ECHO OFF
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
IF "%~1" == "" EXIT
CD /D "%~dp0"
CALL :update_clear

ECHO. & ECHO Downloading update...
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
BITSADMIN /CANCEL "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
PING github.com -n 1 -w 5000 > NUL 2>&1 || GOTO update_failed
BITSADMIN /CREATE /DOWNLOAD "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
BITSADMIN /SETMAXDOWNLOADTIME "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 20 > NUL 2>&1
BITSADMIN /SETNOPROGRESSTIMEOUT "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 5 > NUL 2>&1
BITSADMIN /SETMINRETRYDELAY "%CLOUDCOINMANAGERPORTABLE_name% Download Update" 0 > NUL 2>&1
BITSADMIN /SETNOTIFYCMDLINE "%CLOUDCOINMANAGERPORTABLE_name% Download Update" NULL NULL > NUL 2>&1
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Downloading Update
BITSADMIN /TRANSFER "%CLOUDCOINMANAGERPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/CloudCoinManagerPortable.zip" "%CD%\CloudCoinManagerPortable.zip"
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
BITSADMIN /CANCEL "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1
FOR /F "tokens=*" %%G IN ('BITSADMIN /LIST 1^>NUL') DO CALL :update_remove_job "%%G"
GOTO update_skip_remove_job
:update_remove_job
SET CLOUDCOINMANAGERPORTABLE_update_guid=%~1
ECHO %~1 | FIND "%CLOUDCOINMANAGERPORTABLE_name% Download Update" > NUL 2>&1 && BITSADMIN /CANCEL %CLOUDCOINMANAGERPORTABLE_update_guid:~0,38% > NUL 2>&1
EXIT /B
:update_skip_remove_job
CLS
IF NOT EXIST "CloudCoinManagerPortable.zip" GOTO update_failed

ECHO. & ECHO Extracting update...
7za.exe e CloudCoinManagerPortable.zip -spf > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CD%\CloudCoin Manager Portable\*" "%CLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
FOR /F "TOKENS=*" %%G IN ('DIR /B /A:D "%CD%\CloudCoin Manager Portable\*"') DO CALL :update_subdirectories "%%~nG"
CALL :update_clear
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" > NUL 2>&1 || GOTO version_done
ECHO %CLOUDCOINMANAGERPORTABLE_new_version% %DATE% %TIME: =0%> "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
DEL "update.tmp.cmd" & EXIT
:update_subdirectories
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\%~1" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\%~1" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CD%\CloudCoin Manager Portable\%~1\*" "%CLOUDCOINMANAGERPORTABLE_home_dir%\%~1\" > NUL 2>&1 || GOTO update_failed
EXIT /B

:update_failed
ECHO.
ECHO Update failed!
ECHO.
CALL :update_clear
DEL "update.tmp.cmd" & PAUSE & EXIT

:update_clear
RMDIR /S /Q "CloudCoin Manager Portable" > NUL 2>&1
DEL /Q "*.tmp" > NUL 2>&1
DEL /A:H /Q "*.tmp" > NUL 2>&1
DEL /Q "*.zip" > NUL 2>&1
EXIT /B
