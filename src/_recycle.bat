@echo off
REM ======================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021-2023 Orkan
REM ------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM ======================================================

setlocal

REM Import: -------------------------------------------
set "INFILE=%~1"

REM ---------------------------------------------------------
REM Command:
set COMMAND=%~dp0..\..\bin\Recycle.exe "%INFILE%"

echo.
echo %COMMAND%

if "%FFMPEG_DEBUG%" == "" (
	%COMMAND%
)

exit /b %ERRORLEVEL%
