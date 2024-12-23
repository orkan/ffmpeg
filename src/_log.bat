@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

set RECORD=[%DATE% %TIME%] %*

if "%APP_DEBUG%" NEQ "" (
	echo [LOG: %RECORD%]
	exit /b
)

if exist "%LOG_DIR%" echo %RECORD% >> "%LOG_DIR%\%APP_NAME%.log"
