@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat %0 %*

set "INFILE=%~1"
set "SUBTITLES=%~2"
set "NOWAIT=%~3"

echo **********************************************************************************************
echo    Tool: Video subtitles v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> [subtitles: infile.srt] [nowait]
echo **********************************************************************************************
echo Inputs:
echo     INFILE: "%INFILE%"
echo  SUBTITLES: "%SUBTITLES%"
echo     NOWAIT: "%NOWAIT%"
echo.

REM ---------------------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

if "%SUBTITLES%" == "" set SUBTITLES=%~dpn1.srt
if not exist "%SUBTITLES%" (
	echo [%~n0] Not found SUBTITLES: "%SUBTITLES%"
	set APP_ERRORLEVEL=404
	goto :end
)

REM ---------------------------------------------------------------------------
REM Config:
set OUTFILE=%~dpn1.[sub]%~x1
set METAS=%META_GLOBAL% -metadata comment="%~nx0 : '%~nx1' -c:s mov_text"

REM ---------------------------------------------------------------------------
REM Command:
REM https://www.nikse.dk/subtitleedit/AddSubtitlesToVideo
call ffmpeg -y -i "%INFILE%" -i "%SUBTITLES%" -c:v copy -c:a copy -c:s mov_text %METAS% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Finalize:
:end
call _status.bat "%NOWAIT%" %APP_ERRORLEVEL%
exit /b %ERRORLEVEL%
