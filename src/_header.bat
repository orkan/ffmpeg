@echo off
REM ======================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021-2023 Orkan
REM ------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM ======================================================

call %~dp0_config.bat

REM Display [header] only in DEBUG mode
if "%FFMPEG_DEBUG%" == "" exit /b

setlocal
if "%FFMPEG_DEBUG%" NEQ "" set INFO_DEBUG=Debug mode: ON
if "%FFMPEG_ERROR%" NEQ "" set INFO_DEBUG=%INFO_DEBUG%, ERRORLEVEL: %FFMPEG_ERROR%
if "%INFO_DEBUG%"   NEQ "" set INFO_DEBUG=(%INFO_DEBUG%)

echo.
echo [%~1] %INFO_DEBUG%
