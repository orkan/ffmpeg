@echo off
setlocal
call _config.bat
call _header.bat "%~nx0"

echo ***************************************************
echo   Generate audio silence
echo   Usage: %~nx0 outfile duration [channels] [rate]
echo ***************************************************

REM Import: --------------------------------------------
set OUTFILE=%~1
set DURATION=%2
set CHANNELS=%3
set RATE=%4

if "%CHANNELS%" == "" set CHANNELS=2
if "%RATE%" == "" set RATE=41000

echo Inputs:
echo OUTFILE  : [%OUTFILE%]
echo DURATION : [%DURATION%]
echo CHANNELS : [%CHANNELS%]
echo RATE     : [%RATE%]

REM Command: -------------------------------------------
call ffmpeg -y -f lavfi -i anullsrc=channel_layout=%CHANNELS%:sample_rate=%RATE% -t %DURATION% %OUTFILE%

exit /b
