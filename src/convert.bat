@echo off
REM ======================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021-2023 Orkan
REM ------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM ======================================================

setlocal
pushd %~dp0

set FILES=%1
if "%FILES%" == "" set "FILES=%~dp0..\usr\files_tests.bat"
set TOTAL=0
set DATESTART=%DATE% %TIME%

call _config.bat
call _header.bat "%~nx0"
echo ******************************************************************
echo  Batch media converter
echo  Files: %FILES%
echo ******************************************************************

echo.
echo Queue:
call :config %FILES% show || goto :end

echo.
set /p SHUTDOWN_USER=When done (s - shutdown ^| h - hibernate ^| [n] - nothing): 
REM WARNING: 
REM Empty input sets ERRORLEVEL=1 so we need to reset it with: ver > nul
REM Do NOT cover pseudo var with local variable, like: set ERRORLEVEL=0
ver > nul

call :config %FILES% run
goto :end

REM Finalize: ------------------------------------------
:end
echo.
echo Started  on: %DATESTART%
echo Finished on: %DATE% %TIME%

set SHUTDOWN_TYPE=n
if "%SHUTDOWN_USER%" == "s" set SHUTDOWN_TYPE=/s
if "%SHUTDOWN_USER%" == "h" set SHUTDOWN_TYPE=/h
if "%SHUTDOWN_TYPE%" NEQ "n" (
	echo.
	echo Shutting down...
	if "%FFMPEG_DEBUG%" == "" (
		shutdown %SHUTDOWN_TYPE%
	) else (
		echo shutdown %SHUTDOWN_TYPE%
	)
)

call _status.bat
exit /b %ERRORLEVEL%

REM FUNCTIONS -------------------------------------------
:config
REM Loop over each echoed line
set PROGRESS=0
for /f "tokens=*" %%a in ( 'call %1' ) do (
	call :start %2 %%a || exit /b %ERRORLEVEL%
)
if %PROGRESS% == 0 (
	echo Error: No files!
	exit /b 204
)
exit /b 0

:start
REM Loop over each parameter from echoed line
REM To allow exclamation mark "!" in filenames we must DisableDelayedExpansion here
REM and in every submodule where %INFILE% is used
REM The drawback is that we cannot set variables in parentheses now
for %%f in (%3) do (
	set /a PROGRESS+=1
	
	if "%1" == "show" (
		set /a TOTAL+=1
		call :showQueue %2 "%%f" %4 %5 %6
	) else (
		call :showTitle "%%f"
		echo.
		call %2 "%%f" %4 %5 %6 || exit /b %ERRORLEVEL%
	)
)
exit /b 0

:showQueue
setlocal EnableDelayedExpansion
echo !PROGRESS!. %*
setlocal DisableDelayedExpansion
goto :eof

:showTitle
setlocal EnableDelayedExpansion
REM Assignment required to properly extract special chars like: &
set "BASENAME=%~nx1"
TITLE [!PROGRESS!/!TOTAL!] !BASENAME! - %1
setlocal DisableDelayedExpansion
goto :eof
