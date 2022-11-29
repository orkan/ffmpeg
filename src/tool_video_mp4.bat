@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
pushd %~dp0
call _config.bat reload
call _header.bat "%~nx0"

echo ************************************
echo    Tool: Video to MP4
echo   Usage: %~nx0 ^<infile^>
echo ************************************

REM Import: -------------------------------------------
set "INFILE=%~1"

REM Display: ------------------------------------------
echo Inputs:
echo INFILE: "%INFILE%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM User: ----------------------------------------------
set /p CRF=CRF value [quality 0(hi)-51(low): 23]: 
echo Extra options:
echo - video size: -s hd720 (1280x720), -s pal (720x576)
echo - video filter: -vf fps=30,eq=brightness=0.04,crop=1280:536:0:93
echo - audio AC3 to AAC: -map v:0 -map a:0 -c:a aac -ac 2 -ar 44100 -ab 192k -c:v copy
echo - FLV to MP4: -map v:0 -map a:0 -c:a aac -ab 128k
set /p EXTRA=EXTRA [-c:a copy]: 

REM Command: -------------------------------------------
echo.
call ffmpeg_mp4.bat "%INFILE%" "%CRF%" "%EXTRA%"

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
