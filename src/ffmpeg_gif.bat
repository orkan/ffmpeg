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

echo **************************************************************
echo   Video to GIF + cut by start/end timestamps
echo     Usage: %~nx0 ^<infile^> [start] [end] [outfile]
echo   Example: %~nx0 "video.mp4" 0:1.0 0:12.5 "video.gif"
echo **************************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set SS=%~2
set TO=%~3
set OUTFILE=%~4

REM Display: -------------------------------------------
echo Inputs:
echo  INFILE: "%INFILE%"
echo      SS: "%SS%"
echo      TO: "%TO%"
echo OUTFILE: "%OUTFILE%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM Config: --------------------------------------------
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
set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%SS%] [%TO%] [-filter_complex ...] %META_USER_COMMENT%"

REM Command: -------------------------------------------
REM https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
call ffmpeg -y %SS% %TO% -i "%INFILE%" -filter_complex "[0:v] fps=12,scale=480:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" %METAS% "%OUTFILE%"

REM Finalize: ------------------------------------------
:end
exit /b %ERRORLEVEL%
