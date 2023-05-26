@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

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
