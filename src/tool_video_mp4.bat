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
echo    Tool: Video to MP4 v%APP_VERSION%
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
set /p CRF=CRF value [quality 0(hi)-51(low): 23]:

echo Extra options:
echo - video size:       -s hd720 (1280x720), -s pal (720x576)
echo - video filter:     -vf fps=30,eq=brightness=0.04,crop=1280:536:0:93
echo - audio AC3 to AAC: -map v:0 -map a:0 -c:a aac -ac 2 -ar 44100 -ab 192k -c:v copy
echo - FLV to MP4:       -map v:0 -map a:0 -c:a aac -ab 128k
echo - audio resample:   -c:a aac -ar 44100 -ab 128k
echo - bitrate limit:    -b:v 3M -maxrate 5M -bufsize 1M
set /p EXTRA=EXTRA [-c:a copy]:

REM -------------------------------------------------------------
REM Command:
echo.
call ffmpeg_mp4.bat "%INFILE%" "%CRF%" "%EXTRA%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
