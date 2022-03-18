@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

setlocal
set FFMPEG_EXE=%~n0.exe

if not exist "%FFMPEG_HOME%" (
	set FFMPEG_HOME=%FFMPEG_HOME_DEF%
)

set EXE_LOC=%FFMPEG_HOME%\%FFMPEG_EXE%

if not exist "%EXE_LOC%" (
	echo Error: Can't find %FFMPEG_EXE% in [%FFMPEG_HOME%]
	exit /b 404
)

REM Get fully qualified path name
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
pushd %FFMPEG_HOME%
set APP=%CD%\%FFMPEG_EXE%
popd

echo.
set COMMAND=%APP% %*
echo %COMMAND%

if "%FFMPEG_DEBUG%" == "" (
	echo.
	%COMMAND%
)
