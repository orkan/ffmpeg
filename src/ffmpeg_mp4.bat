@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

echo *****************************************************************************************
echo   Video to MP4
echo   Usage: %~nx0 ^<infile^> [quality 0(hi)-51(low): %DEFAULT_H264_CRF%] [extra: %DEFAULT_H264_EXT%] [outfile]
echo *****************************************************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set CRF=%~2
set EXT=%~3
set OUTFILE=%~4

REM Display: ------------------------------------------
echo Inputs:
echo INFILE  : [%INFILE%]
echo CRF     : [%CRF%]
echo EXT     : [%EXT%]
echo OUTFILE : [%OUTFILE%]
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM Config: --------------------------------------------
set CRF=-crf %CRF%
if "%CRF%" == "-crf " set CRF=-crf %DEFAULT_H264_CRF%
if "%EXT%" == ""      set EXT=%DEFAULT_H264_EXT%

set EXT_STR=%EXT%
set EXT_STR=%EXT_STR::=%
set EXT_STR=%EXT_STR:?=%
set EXT_STR=%EXT_STR:/=-%

if "%OUTFILE%" == "" (
	set "OUTFILE=%~dpn1.[%CRF%][%EXT_STR%].mp4"
)

REM META tags: -----------------------------------------
for /f "tokens=*" %%x in ( 'call _location.bat "%INFILE%"' ) do set LOCATION=%%x
if "%LOCATION%" NEQ "" set META_LOCATION=gps:[%LOCATION%]
set METAS=%META_GLOBAL% -metadata description="%META_LOCATION%" -metadata comment="%~nx0 [%CRF%] [%EXT%] %META_USER_COMMENT%"

REM Command: -------------------------------------------
call ffmpeg -y -i "%INFILE%" -c:v libx264 %DEFAULT_H264% %CRF% %EXT% %METAS% "%OUTFILE%"

REM Finalize: ------------------------------------------
:end
exit /b %ERRORLEVEL%
