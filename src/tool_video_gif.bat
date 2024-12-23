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
call _header.bat "%~nx0"

set "INFILE=%~1"
set "NOWAIT=%~2"

echo **********************************************************************************************
echo    Tool: Video to GIF v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [nowait]
echo **********************************************************************************************
echo Inputs:
echo  INFILE: "%INFILE%"
echo  NOWAIT: "%NOWAIT%"
echo.

REM ---------------------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM ---------------------------------------------------------------------------
REM User:
set /p START=Start time [0:0.0]: 
set /p DURATION=Duration [0:0.0]: 

REM ---------------------------------------------------------------------------
REM Command:
echo.
call ffmpeg_gif.bat %1 %START% %DURATION%
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
