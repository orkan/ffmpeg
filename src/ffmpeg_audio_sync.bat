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
set "SECONDS=%~2"
set "OUTFILE=%~3"

echo **********************************************************************************************
echo   Audio delay v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> ^<seconds^> [outfile]
echo   Notes:
echo   - use negative value to delay audio
echo   - use positive value to delay video
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo  SECONDS: "%SECONDS%"
echo  OUTFILE: "%OUTFILE%"
echo.

REM ---------------------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

if "%SECONDS%" == "" (
	echo [%~n0] Empty SECONDS!
	exit /b 400
)

REM ---------------------------------------------------------------------------
REM Config:
REM https://superuser.com/questions/982342/in-ffmpeg-how-to-delay-only-the-audio-of-a-mp4-video-without-converting-the-au
REM If you need to delay video by 3.84 seconds, use a command like this:
REM ffmpeg.exe -i "movie.mp4" -itsoffset 3.84 -i "movie.mp4" -map 1:v -map 0:a -c copy "movie-video-delayed.mp4"
REM If you need to delay audio by 3.84 seconds, use a command like this:
REM ffmpeg.exe -i "movie.mp4" -itsoffset 3.84 -i "movie.mp4" -map 0:v -map 1:a -c copy "movie-audio-delayed.mp4"
if "%SECONDS:~0,1%" == "-" (
	set OFFSET=-itsoffset %SECONDS:~1%
	set MAP=-map 1:v -map 0:a
) else (
	set OFFSET=-itsoffset %SECONDS%
	set MAP=-map 0:v -map 1:a
)

if "%OUTFILE%" == "" (
	set "OUTFILE=%~dpn1.[audio%SECONDS%sec]%~x1"
)

set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%OFFSET%] [%MAP%]"

REM ---------------------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
call ffmpeg -y -i "%INFILE%" %OFFSET% -i "%INFILE%" %MAP% -c copy %METAS% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
