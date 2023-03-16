IF "%~1" == "" EXIT
CLS
IF "%CLOUDCOINMANAGERPORTABLE_home_dir%" == "" EXIT
SET CLOUDCOINMANAGERPORTABLE_client_name_ext=%~nx1
TASKLIST /FI "imagename eq %CLOUDCOINMANAGERPORTABLE_client_name_ext%" | FIND "%CLOUDCOINMANAGERPORTABLE_client_name_ext%" > NUL && CALL error.cmd "CloudCoin Manager is already running!" "4"
CALL version.cmd "1"
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
CLS

IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\CloudCoin Manager\cloudcoin_manager" IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\cloudcoin_manager" (
    IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\CloudCoin Manager" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\CloudCoin Manager"
    MOVE "%CLOUDCOINMANAGERPORTABLE_home_dir%\cloudcoin_manager" "%CLOUDCOINMANAGERPORTABLE_home_dir%\CloudCoin Manager\" >NUL || EXIT
)

IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\cloudcoin_manager" IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandbox\DefaultBox\user\current\cloudcoin_manager" (
    IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings" MKDIR "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    MOVE "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandbox\DefaultBox\user\current\cloudcoin_manager" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\" >NUL || EXIT
    IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandbox\DefaultBox\user\current\cloudcoin_manager" RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandbox" >NUL 2>&1
    RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandboxie-Plus" >NUL 2>&1
    DEL /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts\Sandboxie*" >NUL 2>&1
    DEL /Q "%CLOUDCOINMANAGERPORTABLE_home_dir%\Sandboxie*" >NUL 2>&1
)

FOR %%f IN (%*) DO IF EXIST "%%~f" (
    SET CLOUDCOINMANAGERPORTABLE_manager=%%~f
    SET CLOUDCOINMANAGERPORTABLE_manager_dir=%%~dpf
    GOTO manager_found
)
CALL error.cmd "CloudCoin Manager not installed!"
:manager_found
SET CLOUDCOINMANAGERPORTABLE_local_manager_dir=%~dp1
IF EXIST "%CLOUDCOINMANAGERPORTABLE_local_manager_dir%" GOTO no_copy_manager
IF "%CLOUDCOINMANAGERPORTABLE_manager_dir:~-1%" == "\" SET CLOUDCOINMANAGERPORTABLE_manager_dir=%CLOUDCOINMANAGERPORTABLE_manager_dir:~0,-1%
IF "%CLOUDCOINMANAGERPORTABLE_local_manager_dir:~-1%" == "\" SET CLOUDCOINMANAGERPORTABLE_local_manager_dir=%CLOUDCOINMANAGERPORTABLE_local_manager_dir:~0,-1%
CALL copy.cmd "%CLOUDCOINMANAGERPORTABLE_manager_dir%" "%CLOUDCOINMANAGERPORTABLE_local_manager_dir%" "Copy CloudCoin Manager to portable folder [Y/N]?" "Copying manager files..." "Verifying copied manager files..." "Failed to copy manager files!"
IF %ERRORLEVEL% EQU 1 EXIT
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
CLS
:no_copy_manager

SET CLOUDCOINMANAGERPORTABLE_userprofile_settings_dir=%USERPROFILE%\cloudcoin_manager
SET CLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir=%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\cloudcoin_manager
IF EXIST "%CLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" GOTO copy_settings_exist
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_userprofile_settings_dir%" GOTO no_copy_settings
CALL copy.cmd "%CLOUDCOINMANAGERPORTABLE_userprofile_settings_dir%" "%CLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" "Copy detected CloudCoin settings and coins to portable folder [Y/N]?" "Copying settings files..." "Verifying copied settings files..." "Failed to copy settings files!"
SET CLOUDCOINMANAGERPORTABLE_copy_error=%ERRORLEVEL%
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
CLS
IF %CLOUDCOINMANAGERPORTABLE_copy_error% EQU 2 GOTO no_copy_settings
IF %CLOUDCOINMANAGERPORTABLE_copy_error% NEQ 0 EXIT
:copy_settings_exist

SET CLOUDCOINMANAGERPORTABLE_appdata_settings_dir=%APPDATA%\%CLOUDCOINMANAGERPORTABLE_client_name_ext%
SET CLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir=%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\AppData\Roaming\%CLOUDCOINMANAGERPORTABLE_client_name_ext%
IF EXIST "%CLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%" GOTO no_copy_settings
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_appdata_settings_dir%" GOTO no_copy_settings
CALL copy.cmd "%CLOUDCOINMANAGERPORTABLE_appdata_settings_dir%" "%CLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%" "yes" "Copying settings files..." "Verifying copied settings files..." "Failed to copy settings files!"
IF %ERRORLEVEL% NEQ 0 EXIT
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
CLS
:no_copy_settings
IF NOT EXIST "%CLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" MKDIR "%CLOUDCOINMANAGERPORTABLE_local_userprofile_settings_dir%" || EXIT

SET APPDATA=%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\AppData\Roaming
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom.cmd" (
    CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    CALL custom.cmd "%~0"
    CD /D "%~dp0"
)

START "" wait.vbs "%CLOUDCOINMANAGERPORTABLE_manager%" "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
EXIT
