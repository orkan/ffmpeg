@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
pushd %~dp0
call _config.bat reload
call _header.bat "%~nx0"

echo *************************************************************
echo    Tool: Video subtitles
echo   Usage: %~nx0 ^<infile^> [subtitles: infile.srt]
echo *************************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set SUBTITLES=%~2

REM Display: ------------------------------------------
echo Inputs:
echo INFILE   : "%INFILE%"
echo SUBTITLES: "%SUBTITLES%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end
if "%SUBTITLES%" == "" set SUBTITLES=%~dpn1.srt
if not exist "%SUBTITLES%" (
	echo File not found: "%SUBTITLES%"
	set ERRORLEVEL=404
	goto :end
)

REM Config: --------------------------------------------
set OUTFILE=%~dpn1.[sub]%~x1
set METAS=%META_GLOBAL% -metadata comment="%~nx0 : '%~nx1' -c:s mov_text %META_USER_COMMENT%"

REM Command: -------------------------------------------
REM https://www.nikse.dk/subtitleedit/AddSubtitlesToVideo
call ffmpeg -y -i "%INFILE%" -i "%SUBTITLES%" -c:v copy -c:a copy -c:s mov_text %METAS% "%OUTFILE%"

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b %ERRORLEVEL%
