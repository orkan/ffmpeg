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
set "STREAMS=%~4"
set "EXTRA=%~5"

echo **********************************************************************************************
echo    Tool: Video cut by timestamps v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [outfile] [nowait] [streams] [extra]
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo  OUTFILE: "%OUTFILE%"
echo   NOWAIT: "%NOWAIT%"
echo  STREAMS: "%STREAMS%"
echo    EXTRA: "%EXTRA%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM User:
set /p START=Start time [0:0:0]: 
set /p END=End time [End of video]: 

for /f "tokens=*" %%x in ( 'call _timestamp.bat "%START%" "0:0:0"' ) do set START=%%x
for /f "tokens=*" %%x in ( 'call _timestamp.bat "%END%"' ) do set END=%%x

REM -------------------------------------------------------------
REM Command:
echo.
call ffmpeg_cut_time.bat "%INFILE%" "%START%" "%END%" "%OUTFILE%" "%STREAMS%" "" "%EXTRA%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
