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
set "NOWAIT=%~2"

echo **********************************************************************************************
echo    Tool: Audio delay v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [nowait]
echo **********************************************************************************************
echo Inputs:
echo  INFILE: "%INFILE%"
echo  NOWAIT: "%NOWAIT%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM User:
set /p SECONDS=Audio delay (sec): 

REM -------------------------------------------------------------
REM Command:
echo.
call ffmpeg_audio_sync.bat "%INFILE%" "%SECONDS%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
