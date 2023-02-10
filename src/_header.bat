@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

REM -------------------------------------------------------------
REM Display [header] only in DEBUG mode
if "%APP_DEBUG%" == "" exit /b

setlocal
if "%APP_DEBUG%" NEQ "" set INFO=Debug mode: ON
if "%APP_ERROR%" NEQ "" set INFO=%INFO%, ERRORLEVEL: %APP_ERROR%
if "%INFO%" NEQ "" set INFO=(%INFO%)

echo.
echo [%~1] %INFO%
