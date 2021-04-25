@echo off
setlocal
call _config.bat
call _header.bat "%~nx0"

REM Convert audio files to mp3 using ffmpeg
REM https://stackoverflow.com/a/12952172/166689

echo ***************************************************
echo  Any to MP3
echo  Usage: %~nx0 infile [bitrate: %DEFAULT_MP3_BRATE%] [sample: %DEFAULT_MP3_SRATE%] [outfile]
echo ***************************************************

REM Config: --------------------------------------------
set INFILE=%~1
set BRATE=%~2
set SRATE=%~3
set OUTFILE=%~4

echo Inputs:
echo INFILE  : [%INFILE%]
echo BRATE   : [%BRATE%]
echo SRATE   : [%SRATE%]
echo OUTFILE : [%OUTFILE%]

set BRATE=-b:a %BRATE%
set SRATE=-ar %SRATE%

if "%BRATE%" == "-b:a " set BRATE=-b:a %DEFAULT_MP3_BRATE%
if "%SRATE%" == "-ar "  set SRATE=-ar %DEFAULT_MP3_SRATE%

set BRATE_STR=%BRATE::=%

if "%OUTFILE%" == "" (
	set "OUTFILE=%~dpn1.[%BRATE_STR%][%SRATE%].mp3"
)

REM META tags: -----------------------------------------
set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%BRATE%] [%SRATE%] %META_USER_COMMENT%"

REM Command: -------------------------------------------
call ffmpeg -y -i "%INFILE%" -vn %BRATE% %SRATE% %METAS% "%OUTFILE%"

exit /b %ERRORLEVEL%
