@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

REM Let _status.bat return immediately after each tool_*.bat
set APP_NOWAIT=%~n0

REM Set before setlocal! See :end
set "NOWAIT=%~2"

setlocal
pushd %~dp0
call _config.bat
call _header.bat %0 %*

set "FILES=%~1"
REM set "NOWAIT=%~2" // @see above

echo **********************************************************************************************
echo  Batch media converter v%APP_VERSION%
echo  Usage: %~nx0 ^<files^> [nowait]
REM echo  ---------------------------------------------------------------------------------------------
REM echo  ^<files^>
REM echo  	- filename if on APP_TOOLS_PATH
REM echo  	- relative path to this script location
REM echo  	- absolute path if none above
echo **********************************************************************************************
echo Inputs:
echo   FILES: "%FILES%"
echo  NOWAIT: "%NOWAIT%"
echo.

REM ---------------------------------------------------------------------------
REM Setup:
set DATESTART=%DATE% %TIME%
set TOTAL=0

REM ---------------------------------------------------------------------------
REM Verify:
call :filesAbs "%FILES%" || goto :end

REM ---------------------------------------------------------------------------
REM Run:
call :showTitleDefault %CONVERT_FILES_ABS%

echo Queue:
call :config %CONVERT_FILES_ABS% show || goto :finalize

echo.
set /p SHUTDOWN_USER=When done (s - shutdown ^| h - hibernate ^| [n] - nothing): 

REM Empty input sets ERRORLEVEL=1 so we need to reset it with: ver > nul
REM Do NOT cover pseudo var with local variable, like: set ERRORLEVEL=0
ver > nul

call :config %CONVERT_FILES_ABS% run
goto :finalize

REM ---------------------------------------------------------------------------
REM Finalize:
:finalize
call :showTitleDefault %CONVERT_FILES_ABS%
echo.
echo Started  on: %DATESTART%
echo Finished on: %DATE% %TIME%

set SHUTDOWN_TYPE=n
if "%SHUTDOWN_USER%" == "s" set SHUTDOWN_TYPE=/s
if "%SHUTDOWN_USER%" == "h" set SHUTDOWN_TYPE=/h
if "%SHUTDOWN_TYPE%" NEQ "n" (
	echo.
	echo [%~n0] Shutting down...
	if "%APP_DEBUG%" NEQ "" (
		echo [%~n0] shutdown %SHUTDOWN_TYPE%
	) else (
		shutdown %SHUTDOWN_TYPE%
	)
)

:end
endlocal
set APP_NOWAIT=
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%

REM ===========================================================================
REM Functions:
REM ---------------------------------------------------------------------------
:config
REM Loop over each echoed line
set PROGRESS=0
for /f "tokens=*" %%a in ( 'call %1' ) do (
	call :start %2 %%a || exit /b %ERRORLEVEL%
)
if %PROGRESS% == 0 (
	echo No results
	exit /b 204
)
exit /b 0

REM ---------------------------------------------------------------------------
:filesAbs
set CONVERT_FILES_ABS=%~f$APP_TOOLS_PATH:1
if not exist "%CONVERT_FILES_ABS%" (
	echo [%~n0] Unable to locate FILES "%FILES%"
	echo [%~n0] Was using "%APP_TOOLS_PATH%"
	exit /b 404
)
if "%APP_DEBUG%" NEQ "" echo [%~n0] Located FILES "%~1" at "%CONVERT_FILES_ABS%"
exit /b 0

REM ---------------------------------------------------------------------------
:start
REM Loop over each parameter from echoed line
REM To allow exclamation mark "!" in filenames we must DisableDelayedExpansion here
REM and in every submodule where %INFILE% is used
REM The drawback is that we cannot set variables in parentheses now
for %%f in (%3) do (
	set /a PROGRESS+=1

	if "%1" == "show" (
		set /a TOTAL+=1
		call :showQueue %2 "%%~f" %4 %5 %6
	) else (
		call :showTitle "%%~f"
		echo.
		REM Locate current tool on APP_TOOLS_PATH
		if "%APP_DEBUG%" NEQ "" echo [%~n0] call "%~f$APP_TOOLS_PATH:2" "%%~f" %4 %5 %6
		call "%~f$APP_TOOLS_PATH:2" "%%~f" %4 %5 %6 || exit /b %ERRORLEVEL%
	)
)
exit /b 0

REM ---------------------------------------------------------------------------
:showQueue
echo %PROGRESS%. %*
goto :eof

REM ---------------------------------------------------------------------------
:showTitle
TITLE [%PROGRESS%/%TOTAL%] %~nx1 - "%~1"
goto :eof

REM ---------------------------------------------------------------------------
:showTitleDefault
TITLE [CONVERT] %~nx1 - "%~1"
goto :eof

