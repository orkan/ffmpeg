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
set "OUTFILE=%~2"
set "NOWAIT=%~3"
set "STREAMS=%~4"

echo **********************************************************************************************
echo    Tool: Video cut by timestamps v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [outfile] [nowait] [streams]
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo  OUTFILE: "%OUTFILE%"
echo   NOWAIT: "%NOWAIT%"
echo  STREAMS: "%STREAMS%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM User:
set /p START=Start time [0:0:0]: 
set /p END=End time [End of video]: 

REM Treat spaces as : in time tags
if "%START%" NEQ "" set START=%START: =:%
if "%END%" NEQ "" set END=%END: =:%

REM -------------------------------------------------------------
REM Command:
echo.
call ffmpeg_cut_time.bat "%INFILE%" "%START%" "%END%" "%OUTFILE%" "%STREAMS%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%
