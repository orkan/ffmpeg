@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

REM Tip: Status codes https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400

REM Cant use setlocal cos it resets ERRORLEVEL !!!
REM setlocal

set STATUS_NOWAIT=%~1
if "%STATUS_NOWAIT%" == "" set STATUS_NOWAIT=%APP_NOWAIT%

set STATUS_ERRORLEVEL=%~2
if "%STATUS_ERRORLEVEL%" == "" set STATUS_ERRORLEVEL=%ERRORLEVEL%

if %STATUS_ERRORLEVEL% == 0 (
	echo.
	echo BUILD SUCCESSFUL
	echo.
	if "%STATUS_NOWAIT%" NEQ "" goto :eof
) else (
	echo.
	echo BUILD FAILED ^(%STATUS_ERRORLEVEL%^)
	REM Clear ERRORLEVEL
	REM ver > nul
	REM Always pause on errors!
	echo.
)

pause
