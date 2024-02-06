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

set "INFILE=%~1"
set "OUTFILE=%~2"
set "NOWAIT=%~3"

echo **********************************************************************************************
echo    Tool: Any to MP3 v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [outfile] [nowait]
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo  OUTFILE: "%OUTFILE%"
echo   NOWAIT: "%NOWAIT%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM User:
set /p BRATE=Bitrate [%DEFAULT_MP3_BRATE%]: 
set /p SRATE=Sample [%DEFAULT_MP3_SRATE%]: 

REM -------------------------------------------------------------
REM Command:
call ffmpeg_mp3.bat "%~1" "%BRATE%" "%SRATE%" "%OUTFILE%" || goto :end
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
