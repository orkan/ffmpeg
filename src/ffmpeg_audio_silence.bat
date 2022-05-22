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

echo ************************************************************************
echo   Generate audio silence
echo   Usage: %~nx0 ^<outfile^> ^<duration^> [channels] [rate]
echo ************************************************************************

REM Import: -------------------------------------------
set OUTFILE=%~1
set DURATION=%2
set CHANNELS=%3
set RATE=%4
if "%CHANNELS%" == "" set CHANNELS=2
if "%RATE%" == "" set RATE=41000

REM Display: ------------------------------------------
echo Inputs:
echo  OUTFILE: "%OUTFILE%"
echo DURATION: "%DURATION%"
echo CHANNELS: "%CHANNELS%"
echo     RATE: "%RATE%"
echo.

REM Verify: --------------------------------------------
if "%OUTFILE%" == "" (
	echo Error: Empty ^<outfile^>
	set ERRORLEVEL=400
	goto :end
)
if "%DURATION%" == "" (
	echo Error: Empty ^<duration^>
	set ERRORLEVEL=400
	goto :end
)

REM Command: -------------------------------------------
call ffmpeg -y -f lavfi -i anullsrc=channel_layout=%CHANNELS%:sample_rate=%RATE% -t %DURATION% %OUTFILE%

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
