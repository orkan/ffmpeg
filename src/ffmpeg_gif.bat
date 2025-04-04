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
set "SS=%~2"
set "TO=%~3"
set "OUTFILE=%~4"

echo **********************************************************************************************
echo   Video to GIF + cut by start/end timestamps v%APP_VERSION%
echo     Usage: %~nx0 ^<infile^> [start] [end] [outfile]
echo   Example: %~nx0 "video.mp4" 0:1.0 0:12.5 "video.gif"
echo **********************************************************************************************
echo Inputs:
echo   INFILE: "%INFILE%"
echo       SS: "%SS%"
echo       TO: "%TO%"
echo  OUTFILE: "%OUTFILE%"
echo.

REM ---------------------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

REM ---------------------------------------------------------------------------
REM Config:
set SS=-ss %SS%
set TO=-to %TO%
if "%SS%" == "-ss " set SS=-ss 0
if "%TO%" == "-to " set TO=

set SS_STR=%SS::=.%
if "%TO%" NEQ "" (
	set TO_STR=%TO::=.%
)

REM Use quoted set "FILE=name with ().ext" in case of parenthesized file names!
if "%OUTFILE%" == "" (
	set "PATH1=%~dpn1"
) else (
	set "PATH1=%~dpn4"
)
set OUTFILE=%PATH1%.[%SS_STR%][%TO_STR%].gif
set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%SS%] [%TO%] [-filter_complex ...]"

REM ---------------------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
REM https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
call ffmpeg -y %SS% %TO% -i "%INFILE%" -filter_complex "[0:v] fps=12,scale=480:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" %METAS% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
