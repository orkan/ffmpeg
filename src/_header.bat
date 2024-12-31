@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

REM ---------------------------------------------------------------------------
REM Display [header] only in DEBUG mode
if "%APP_DEBUG%" == "" exit /b

echo.
echo [%~nx1]
echo File: %1
echo Args: %2 %3 %4 %5 %6 %7 %8 %9
if "%APP_ERROR%" NEQ "" echo ERRORLEVEL: %APP_ERROR%
