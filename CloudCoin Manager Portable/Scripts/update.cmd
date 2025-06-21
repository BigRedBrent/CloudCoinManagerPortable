@ECHO OFF
CLS
IF "%~1" == "2" GOTO update_install
IF "%~1" == "3" GOTO update_finish
IF NOT "%~1" == "1" EXIT

TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
ECHO. & ECHO Downloading update...
WHERE powershell >NUL 2>&1 || GOTO update_failed
MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1 || GOTO update_failed
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Downloading Update
powershell -Command "$ErrorActionPreference = 'Stop'; try { Invoke-WebRequest -Uri 'https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/CloudCoinManagerPortable.zip' -TimeoutSec 10 -OutFile '%CLOUDCOINMANAGERPORTABLE_home_dir%\\Settings\\update.tmp\\CloudCoinManagerPortable.zip' } catch { exit 1 }" || GOTO update_failed
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoinManagerPortable.zip" GOTO update_failed

ECHO. & ECHO Checking downloaded update...
CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp"
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
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1 || GOTO update_failed
MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\Scripts" "%CLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed
CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts"
START "" update.cmd "3" & EXIT

:update_finish
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Update
CLS & ECHO. & ECHO Installing update...
FOR %%G IN ("vbs","cmd") DO MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\*.%%~G" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp\" > NUL 2>&1
MOVE /Y "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp\CloudCoin Manager Portable\*" "%CLOUDCOINMANAGERPORTABLE_home_dir%\" > NUL 2>&1 || GOTO update_failed

DEL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\replaced.tmp" > NUL 2>&1
ECHO %CLOUDCOINMANAGERPORTABLE_new_version% %DATE:~-10% %TIME: =0%> "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\version.txt"
START "" notepad.exe "%CLOUDCOINMANAGERPORTABLE_home_dir%\Changelog.txt"
EXIT

:update_failed
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_new_version% - Failed
ECHO.
ECHO Update failed!
ECHO.
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp" > NUL 2>&1
DEL "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\update.tmp.cmd" > NUL 2>&1 & PAUSE & EXIT
