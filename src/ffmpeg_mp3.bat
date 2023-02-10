@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

REM -------------------------------------------------------------
REM Convert audio files to mp3 using ffmpeg
REM https://stackoverflow.com/a/12952172/166689
REM -------------------------------------------------------------

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

set "INFILE=%~1"
set "BRATE=%~2"
set "SRATE=%~3"
set "OUTFILE=%~4"

echo *************************************************************************
echo  Any to MP3
echo  Usage: %~nx0 ^<infile^> [bitrate: %DEFAULT_MP3_BRATE%] [sample: %DEFAULT_MP3_SRATE%] [outfile/outdir]
echo *************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo    BRATE: "%BRATE%"
echo    SRATE: "%SRATE%"
echo  OUTFILE: "%OUTFILE%"
echo.

REM -------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM -------------------------------------------------------------
REM Config:
set BRATE=-b:a %BRATE%
set SRATE=-ar %SRATE%
if "%BRATE%" == "-b:a " set BRATE=-b:a %DEFAULT_MP3_BRATE%
if "%SRATE%" == "-ar "  set SRATE=-ar %DEFAULT_MP3_SRATE%
set BRATE_STR=%BRATE::=%

call :setOUTFILE "%INFILE%" "%OUTFILE%"

set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%BRATE%] [%SRATE%] %META_USER_COMMENT%"

REM -------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
call ffmpeg -y -i "%INFILE%" -vn %BRATE% %SRATE% %METAS% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%

REM =============================================================
REM Functions:
REM -------------------------------------------------------------
REM set_OUTFILE( infile, outfile )
:setOUTFILE
if "%~2" == "" (
	set "OUTFILE=%~dpn1.[%BRATE_STR%][%SRATE%].mp3"
	goto :eof
)
REM Check if [outdir] Note: %~a2 won't work in if() clause
set ATTR=%~a2
set ATTR=%ATTR:~0,1%
if /I "%ATTR%"=="d" (
	set "OUTFILE=%OUTFILE%\%~n1.[%BRATE_STR%][%SRATE%].mp3"
)
goto :eof
