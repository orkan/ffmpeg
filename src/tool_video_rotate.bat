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

echo ***************************************
echo    Tool: Video Rotate
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
set /p ROTATION=Rotation: 

REM Command: -------------------------------------------
echo.
call ffmpeg_rotate.bat "%INFILE%" %ROTATION%

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
