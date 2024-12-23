@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

setlocal
call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

set FFMPEG_EXE=%~n0.exe

if not exist "%FFMPEG_HOME%" (
	set FFMPEG_HOME=%FFMPEG_HOME_DEF%
)

set FFMPEG_EXE_LOC=%FFMPEG_HOME%\%FFMPEG_EXE%

if not exist "%FFMPEG_EXE_LOC%" (
	echo [%~n0] Unable to find "%FFMPEG_EXE%" in "%FFMPEG_HOME%"
	exit /b 404
)

REM Get fully qualified path name
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
pushd %FFMPEG_HOME%
set FFMPEG_EXE_ABS=%CD%\%FFMPEG_EXE%
popd

set COMMAND=%FFMPEG_EXE_ABS% %*

echo.
echo %COMMAND%

if "%APP_ERROR%" NEQ "" (
	echo [%~n0] Exit code: "%APP_ERROR%"
	exit /b %APP_ERROR%
)

if "%APP_DEBUG%" == "" (
	echo.
	%COMMAND% || goto :end
)

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
