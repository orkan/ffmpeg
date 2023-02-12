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
set "NOWAIT=%~2"

echo **********************************************************************************************
echo    Tool: Video rotate v%APP_VERSION%
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
set /p ROTATION=Rotation: 

REM -------------------------------------------------------------
REM Command:
echo.
call ffmpeg_rotate.bat "%INFILE%" "%ROTATION%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
