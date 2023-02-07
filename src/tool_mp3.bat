@echo off
REM ======================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021-2023 Orkan
REM ------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM ======================================================

setlocal
pushd %~dp0
call _config.bat reload
call _header.bat "%~nx0"

echo ************************************
echo    Tool: Any to MP3
echo   Usage: %~nx0 ^<infile^> [outfile] [quit_on_success]
echo ************************************

REM Import: -------------------------------------------
set "INFILE=%~1"
set "OUTFILE=%~2"
set "EXTRA=%~3"

REM Display: ------------------------------------------
echo Inputs:
echo  INFILE: "%INFILE%"
echo OUTFILE: "%OUTFILE%"
echo   EXTRA: "%EXTRA%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM User: ----------------------------------------------
set /p BRATE=Bitrate [%DEFAULT_MP3_BRATE%]: 
set /p SRATE=Sample [%DEFAULT_MP3_SRATE%]: 

REM Command: -------------------------------------------
call ffmpeg_mp3.bat "%~1" "%BRATE%" "%SRATE%" "%OUTFILE%" || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
