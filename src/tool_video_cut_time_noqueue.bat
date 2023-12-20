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

REM -------------------------------------------------------------
REM Command:
call tool_video_cut_time.bat "%INFILE%" "" "" "" "noqueue"

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
