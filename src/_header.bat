@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
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
