@echo off
REM ======================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021-2023 Orkan
REM ------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM ======================================================

call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

if "%FFMPEG_DEBUG%" == "" if "%LOG_FILE%" NEQ "" (
	echo [%DATE% %TIME%] %* >> "%LOG_FILE%"
)
