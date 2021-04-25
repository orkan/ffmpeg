@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Embed subtitles to video
echo   Usage: %~nx0 infile [subtitles: infile.srt]
echo ***************************************************

REM Input: ---------------------------------------------
call _inputfile.bat %1 silent || goto :end

REM Config: --------------------------------------------
set INFILE=%~1

set SUBTITLES=%~2
if "%SUBTITLES%" == "" set SUBTITLES=%~dpn1.srt

if not exist "%SUBTITLES%" (
	echo File not found: "%SUBTITLES%"
	set ERRORLEVEL=404
	goto :end
)

set OUTFILE=%~dpn1.[sub]%~x1

set METAS=%META_GLOBAL% -metadata comment="%~nx0 : '%~nx1' -c:s mov_text %META_USER_COMMENT%"

REM Command: -------------------------------------------
REM https://www.nikse.dk/subtitleedit/AddSubtitlesToVideo
call ffmpeg -y -i "%INFILE%" -i "%SUBTITLES%" -c:v copy -c:a copy -c:s mov_text %METAS% "%OUTFILE%"

:end
call _status.bat
