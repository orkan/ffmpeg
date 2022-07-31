@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

if "%LOG_FILE%" NEQ "" (
	echo [%DATE% %TIME%] %* >> "%LOG_FILE%"
)
