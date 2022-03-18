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

echo *********************************************************************
echo    Tool: Video cut by timestamps
echo   Usage: %~nx0 ^<infile^> [outfile] [quit_on_success] [streams]
echo *********************************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set OUTFILE=%~2
set EXTRA=%~3
set STREAMS=%~4

REM Display: ------------------------------------------
echo Inputs:
echo INFILE : "%INFILE%"
echo OUTFILE: "%OUTFILE%"
echo   EXTRA: "%EXTRA%"
echo STREAMS: "%STREAMS%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM User: ----------------------------------------------
set /p START=Start time [0:0:0]: 
set /p END=End time [End of video]: 

REM Command: -------------------------------------------
echo.
call ffmpeg_cut_time.bat "%INFILE%" "%START%" "%END%" "%OUTFILE%" "%STREAMS%"

REM Finalize: ------------------------------------------
:end
call _status.bat "%EXTRA%"
exit /b %ERRORLEVEL%
