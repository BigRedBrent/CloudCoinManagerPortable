@ECHO OFF
TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version%
IF "%~1" == "" EXIT
ECHO.
ECHO   CloudCoin Manager is closing...
ECHO.
:client_running_check
TASKLIST /FI "imagename eq %CLOUDCOINMANAGERPORTABLE_client_name_ext%" | FIND "%CLOUDCOINMANAGERPORTABLE_client_name_ext%" > NUL || GOTO client_not_running
FOR %%G IN ("1") DO TIMEOUT /T %%~G /NOBREAK> NUL 2>&1 || PING -n %%~G 127.0.0.1 > NUL 2>&1 || PING -n %%~G ::1 > NUL 2>&1
GOTO client_running_check
:client_not_running
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%\EBWebView\Default\Cache" > NUL 2>&1
RMDIR /S /Q "%CLOUDCOINMANAGERPORTABLE_local_appdata_settings_dir%\EBWebView\GrShaderCache" > NUL 2>&1
IF EXIST "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings\custom_end.cmd" (
    CD /D "%CLOUDCOINMANAGERPORTABLE_home_dir%\Settings"
    CALL custom_end.cmd "1" & EXIT
)
EXIT
