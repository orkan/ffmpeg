@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

echo ***********************************************************************************************
echo   FFplay: Video to MP4 (WIP)
echo   Usage: %~nx0 ^<infile^> [quality 0(hi)-51(low): %DEFAULT_H264_CRF%] [fps: original] [extra: %DEFAULT_H264_EXT%]
echo ***********************************************************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set CRF=%~2
set FPS=%~3
set EXT=%~4

REM Display: ------------------------------------------
echo Inputs:
echo INFILE  : [%INFILE%]
echo CRF     : [%CRF%]
echo FPS     : [%FPS%]
echo EXT     : [%EXT%]
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM Config: --------------------------------------------
set CRF=-crf %CRF%
set FPS=-r %FPS%
if "%CRF%" == "-crf " set CRF=-crf %DEFAULT_H264_CRF%
if "%FPS%" == "-r "   set FPS=
if "%EXT%" == ""      set EXT=%DEFAULT_H264_EXT%

set EXT_STR=%EXT%
set EXT_STR=%EXT_STR::=%
set EXT_STR=%EXT_STR:?=%

REM Command: -------------------------------------------
call ffplay -i "%INFILE%" -c:v libx264 %DEFAULT_H264% %CRF% %FPS% %EXT%

REM Finalize: ------------------------------------------
:end
exit /b %ERRORLEVEL%
