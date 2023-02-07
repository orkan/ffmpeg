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

echo ***************************************
echo    Tool: Audio delay
echo   Usage: %~nx0 ^<infile^>
echo ***************************************

REM Import: -------------------------------------------
set "INFILE=%~1"

REM Display: ------------------------------------------
echo Inputs:
echo INFILE: "%INFILE%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM User: ----------------------------------------------
set /p SECONDS=Audio delay (sec):

REM Command: -------------------------------------------
echo.
call ffmpeg_audio_sync.bat "%INFILE%" %SECONDS%

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
