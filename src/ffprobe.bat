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

set FFPROBE_EXE=%~n0.exe

if not exist "%FFMPEG_HOME%" (
	set FFMPEG_HOME=%FFMPEG_HOME_DEF%
)

REM Get fully qualified path name
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
pushd %FFMPEG_HOME%
set FFPROBE_EXE_ABS=%CD%\%FFPROBE_EXE%
popd

%FFPROBE_EXE_ABS% %*
