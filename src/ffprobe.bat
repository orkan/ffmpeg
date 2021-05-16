@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

setlocal
set FFPROBE_EXE=%~n0.exe

if not exist "%FFMPEG_HOME%" (
	set FFMPEG_HOME=%FFMPEG_HOME_DEF%
)

REM Get fully qualified path name
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
pushd %FFMPEG_HOME%
set APP=%CD%\%FFPROBE_EXE%
popd

if "%FFMPEG_DEBUG%" == "" (
	REM No echo please!!!
	%APP% %*
)
