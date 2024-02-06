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
set "CRF=%~2"
set "EXT=%~3"
set "OUTFILE=%~4"

echo **********************************************************************************************
echo   Video to MP4 v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [quality 0(hi)-51(low): %DEFAULT_H264_CRF%] [extra: %DEFAULT_H264_EXT%] [outfile]
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo      CRF: "%CRF%"
echo      EXT: "%EXT%"
echo  OUTFILE: "%OUTFILE%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM Config:
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

REM -------------------------------------------------------------
REM META tags:
for /f "tokens=*" %%x in ( 'call _location.bat "%INFILE%"' ) do set LOCATION=%%x
if "%LOCATION%" NEQ "" set META_LOCATION=-metadata description="gps:[%LOCATION%]"
set METAS=%META_GLOBAL% %META_LOCATION% -metadata comment="%~nx0 [%CRF%] [%EXT%]"

REM -------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
call ffmpeg -y -i "%INFILE%" -c:v libx264 %DEFAULT_H264% %CRF% %EXT% %METAS% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
