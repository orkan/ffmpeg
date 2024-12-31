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
call _header.bat %0 %*

set "INFILE=%~1"

echo **********************************************************************************************
echo   Helper: Video cut by timestamps [noqueue] v%APP_VERSION%
echo   Windows by default is adding dragged file path as the last arg.
echo   Use this helper to re-order args for [tool_video_cut_time.bat].
echo   Usage: %~nx0 ^<infile^>
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo.

REM ---------------------------------------------------------------------------
REM Command:
call tool_video_cut_time.bat "%INFILE%" "" "" "" "noqueue"

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
