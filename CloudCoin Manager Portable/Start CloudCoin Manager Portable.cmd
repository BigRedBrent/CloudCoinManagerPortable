@ECHO OFF

SET CLOUDCOINMANAGERPORTABLE_version=2.12
SET CLOUDCOINMANAGERPORTABLE_name=CloudCoin Manager Portable
SET CLOUDCOINMANAGERPORTABLE_no_version_check=
SET CLOUDCOINMANAGERPORTABLE_no_reset_settings_on_start=

IF NOT "%~1" == "" EXIT /B
TASKLIST /FI "imagename eq cmd.exe" /FO list /V | FIND "%CLOUDCOINMANAGERPORTABLE_name%" > NUL && EXIT
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
SET CLOUDCOINMANAGERPORTABLE_home_dir=%~dp0
IF "%CLOUDCOINMANAGERPORTABLE_home_dir:~0,2%" == "\\" ECHO. & ECHO. & ECHO     Unable to run CloudCoin Manager Portable from a network share! & ECHO. & ECHO. & PAUSE & EXIT
IF "%CLOUDCOINMANAGERPORTABLE_home_dir:~-1%" == "\" SET CLOUDCOINMANAGERPORTABLE_home_dir=%CLOUDCOINMANAGERPORTABLE_home_dir:~0,-1%
SET CLOUDCOINMANAGERPORTABLE_manager_list="%CLOUDCOINMANAGERPORTABLE_home_dir%\CloudCoin Manager\cloudcoin_manager\cloudcoin_manager.exe"
SET CLOUDCOINMANAGERPORTABLE_manager_list=%CLOUDCOINMANAGERPORTABLE_manager_list% "%ProgramFiles(x86)%\CloudCoin Consortium\CloudCoin Manager\cloudcoin_manager\cloudcoin_manager.exe"
SET CLOUDCOINMANAGERPORTABLE_manager_list=%CLOUDCOINMANAGERPORTABLE_manager_list% "%ProgramFiles%\CloudCoin Consortium\CloudCoin Manager\cloudcoin_manager\cloudcoin_manager.exe"
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom_start.cmd" (
    CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    CALL custom_start.cmd "1"
)
CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Scripts"
CALL run.cmd %CLOUDCOINMANAGERPORTABLE_manager_list%
EXIT
