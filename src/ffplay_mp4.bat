@echo off
setlocal
call _config.bat
call _header.bat "%~nx0"

echo ***************************************************
echo   WIP: Video to MP4 (ffplay)
echo   Usage: %~nx0 infile [quality 0(hi)-51(low): %DEFAULT_H264_CRF%] [fps: original] [extra: %DEFAULT_H264_EXT%]
echo ***************************************************

REM Config: --------------------------------------------
set INFILE=%~1
set CRF=%~2
set FPS=%~3
set EXT=%~4

echo Inputs:
echo INFILE  : [%INFILE%]
echo CRF     : [%CRF%]
echo FPS     : [%FPS%]
echo EXT     : [%EXT%]

set CRF=-crf %CRF%
set FPS=-r %FPS%

if "%CRF%" == "-crf " set CRF=-crf %DEFAULT_H264_CRF%
if "%FPS%" == "-r "   set FPS=
if "%EXT%" == ""      set EXT=%DEFAULT_H264_EXT%

REM Extra options: -------------------------------------
set EXT_STR=%EXT%
set EXT_STR=%EXT_STR::=%
set EXT_STR=%EXT_STR:?=%

REM Command: -------------------------------------------
call ffplay -y -i "%INFILE%" -c:v libx264 %DEFAULT_H264% %CRF% %FPS% %EXT%

exit /b %ERRORLEVEL%
