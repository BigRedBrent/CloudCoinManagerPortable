TITLE %CLOUDCOINMANAGERPORTABLE_name% %CLOUDCOINMANAGERPORTABLE_version% - Copy
IF "%~1" == "" EXIT
CLS

SET CLOUDCOINMANAGERPORTABLE_copy_debug=

IF "%~3" == "yes" GOTO copy_skip_choice
:copy_redo_choice
ECHO.
CHOICE /C 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ /M "%~3" /N
IF %ERRORLEVEL% == 24 GOTO copy_no_choice
IF NOT %ERRORLEVEL% == 35 GOTO copy_redo_choice
:copy_skip_choice

CLS & ECHO. & ECHO %~4
RMDIR /S /Q "%~2.tmp" >NUL 2>&1
IF EXIST "%~2.tmp" GOTO copy_failed
XCOPY "%~1\" "%~2.tmp\" /H /E /G /Q /V /Y /R /K > NUL || GOTO copy_failed

SET CLOUDCOINMANAGERPORTABLE_copy_string_length=1
SET CLOUDCOINMANAGERPORTABLE_copy_tmp_string=%CLOUDCOINMANAGERPORTABLE_home_dir%
:copy_string_length_loop1
SET CLOUDCOINMANAGERPORTABLE_copy_tmp_string=%CLOUDCOINMANAGERPORTABLE_copy_tmp_string:~1%
IF NOT DEFINED CLOUDCOINMANAGERPORTABLE_copy_tmp_string GOTO copy_length_found1
SET /A CLOUDCOINMANAGERPORTABLE_copy_string_length+=1
GOTO :copy_string_length_loop1
:copy_length_found1
SET CLOUDCOINMANAGERPORTABLE_copy_relative_path_home=%~2
CALL SET CLOUDCOINMANAGERPORTABLE_copy_relative_path_home=%%CLOUDCOINMANAGERPORTABLE_copy_relative_path_home:~%CLOUDCOINMANAGERPORTABLE_copy_string_length%%%

SET CLOUDCOINMANAGERPORTABLE_copy_string_length=1
SET CLOUDCOINMANAGERPORTABLE_copy_tmp_string=%~1
:copy_string_length_loop2
SET CLOUDCOINMANAGERPORTABLE_copy_tmp_string=%CLOUDCOINMANAGERPORTABLE_copy_tmp_string:~1%
IF NOT DEFINED CLOUDCOINMANAGERPORTABLE_copy_tmp_string GOTO copy_length_found2
SET /A CLOUDCOINMANAGERPORTABLE_copy_string_length+=1
GOTO :copy_string_length_loop2
:copy_length_found2

CLS & ECHO. & ECHO %~5
SET CLOUDCOINMANAGERPORTABLE_copy_verify_msg=%~5
IF DEFINED CLOUDCOINMANAGERPORTABLE_copy_debug PAUSE
>NUL 2>NUL DIR /B /A:-D "%~1\*" && (CALL :copy_verify "%~1" "%~2" "*" || GOTO copy_failed)
FOR /F "TOKENS=*" %%G IN ('DIR /B /A:D /S "%~1\*"') DO >NUL 2>NUL DIR /B /A:-D "%%~G\*" && (CALL :copy_verify "%%~G" "%~2" "*" || GOTO copy_failed)
IF DEFINED CLOUDCOINMANAGERPORTABLE_copy_debug PAUSE
REN "%~2.tmp" "%~nx2" >NUL || GOTO copy_failed
CLS
EXIT /B 0

:copy_no_choice
CLS
IF NOT EXIST "%~2" MKDIR "%~2"
EXIT /B 2

:copy_failed
ECHO. & ECHO. & ECHO. & ECHO %~6 & ECHO.
IF NOT DEFINED CLOUDCOINMANAGERPORTABLE_copy_debug RMDIR /S /Q "%~2.tmp" >NUL 2>&1
PAUSE
EXIT /B 1

:copy_verify
SET CLOUDCOINMANAGERPORTABLE_copy_relative_path=%~1
CALL SET CLOUDCOINMANAGERPORTABLE_copy_relative_path=%%CLOUDCOINMANAGERPORTABLE_copy_relative_path:~%CLOUDCOINMANAGERPORTABLE_copy_string_length%%%
IF NOT DEFINED CLOUDCOINMANAGERPORTABLE_copy_debug CLS & ECHO. & ECHO %CLOUDCOINMANAGERPORTABLE_copy_verify_msg%
ECHO. & ECHO "%CLOUDCOINMANAGERPORTABLE_copy_relative_path_home%%CLOUDCOINMANAGERPORTABLE_copy_relative_path%\%~3"
FC /B "%~1\%~3" "%~2.tmp%CLOUDCOINMANAGERPORTABLE_copy_relative_path%\%~3" >NUL 2>&1 && EXIT /B 0
IF %ERRORLEVEL% EQU 1 EXIT /B 1
IF NOT "%~3" == "*" EXIT /B 1
FOR /F "TOKENS=*" %%G IN ('DIR /B /A:-D "%~1\*"') DO CALL :copy_verify "%~1" "%~2" "%%~nxG" || EXIT /B 1
EXIT /B 0
