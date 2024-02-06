@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM =============================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

set INFILE=%~1
set CRF=%~2
set FPS=%~3
set EXT=%~4

echo **********************************************************************************************
echo   FFplay: Video to MP4 (WIP) v%APP_VERSION%
echo    Usage: %~nx0 ^<infile^> [quality 0(hi)-51(low): %DEFAULT_H264_CRF%] [fps: original] [extra: %DEFAULT_H264_EXT%]
echo **********************************************************************************************
echo Inputs:
echo INFILE: "%INFILE%"
echo    CRF: "%CRF%"
echo    FPS: "%FPS%"
echo    EXT: "%EXT%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM Config:
set CRF=-crf %CRF%
set FPS=-r %FPS%
if "%CRF%" == "-crf " set CRF=-crf %DEFAULT_H264_CRF%
if "%FPS%" == "-r "   set FPS=
if "%EXT%" == ""      set EXT=%DEFAULT_H264_EXT%

set EXT_STR=%EXT%
set EXT_STR=%EXT_STR::=%
set EXT_STR=%EXT_STR:?=%

REM -------------------------------------------------------------
REM Command:
call ffplay -i "%INFILE%" -c:v libx264 %DEFAULT_H264% %CRF% %FPS% %EXT%

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
