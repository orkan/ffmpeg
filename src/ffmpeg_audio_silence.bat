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

set "OUTFILE=%~1"
set "DURATION=%~2"
set "CHANNELS=%~3"
set "RATE=%~4"

echo **********************************************************************************************
echo   Generate audio silence v%APP_VERSION%
echo   Usage: %~nx0 ^<outfile^> ^<duration^> [channels] [rate]
echo **********************************************************************************************
echo Inputs:
echo   OUTFILE: "%OUTFILE%"
echo  DURATION: "%DURATION%"
echo  CHANNELS: "%CHANNELS%"
echo      RATE: "%RATE%"
echo.

REM Verify: --------------------------------------------
if "%OUTFILE%" == "" (
	echo [%~n0] Empty OUTFILE!
	exit /b 400
)
if "%DURATION%" == "" (
	echo [%~n0] Empty DURATION!
	exit /b 400
)

REM -------------------------------------------------------------
REM Config:
if "%CHANNELS%" == "" set CHANNELS=2
if "%RATE%"     == "" set RATE=41000

REM -------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
call ffmpeg -y -f lavfi -i "anullsrc=channel_layout=%CHANNELS%:sample_rate=%RATE%" -t "%DURATION%" "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
