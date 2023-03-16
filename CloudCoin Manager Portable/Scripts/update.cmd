@ECHO OFF
CLS
IF "%~1" == "2" GOTO update_install
IF "%~1" == "3" GOTO update_finish
IF NOT "%~1" == "1" EXIT
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update

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
MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
BITSADMIN /TRANSFER "%CLOUDCOINMANAGERPORTABLE_name% Download Update" /DOWNLOAD /DYNAMIC "https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/CloudCoinManagerPortable.zip" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoinManagerPortable.zip"
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
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoinManagerPortable.zip" GOTO update_failed

CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp"
ECHO. & ECHO Testing downloaded update...
"%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts\7za.exe" t CloudCoinManagerPortable.zip -r > NUL 2>&1 || GOTO update_failed
CLS & ECHO. & ECHO Extracting update...
"%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts\7za.exe" x CloudCoinManagerPortable.zip > NUL 2>&1 || GOTO update_failed
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Scripts\update.cmd" GOTO update_failed
COPY /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Scripts\update.cmd" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
FC /B "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Scripts\update.cmd" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
START "" update.tmp.cmd "2" & EXIT

:update_install
CALL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Start CloudCoin Manager Portable.cmd" "1"
SET CLOUDCOINMANAGERPORTABLE_new_version=%CLOUDCOINMANAGERPORTABLE_version%
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts" > NUL 2>&1 || GOTO update_failed
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Scripts" "%CLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts"
START "" update.cmd "3" & EXIT

:update_finish
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
DEL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 || GOTO update_failed
DEL /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\*" || GOTO update_failed
MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\*" "%CLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
ECHO %CLOUDCOINMANAGERPORTABLE_new_version% %DATE:~-10% %TIME: =0%> "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version%
CLS & ECHO. & ECHO Updated to version %CLOUDCOINMANAGERPORTABLE_new_version% successfully. & ECHO. & PAUSE & EXIT

:update_failed
ECHO.
ECHO Update failed!
ECHO.
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
DEL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 & PAUSE & EXIT
