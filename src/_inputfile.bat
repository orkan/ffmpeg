@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2021 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

REM Import: -------------------------------------------
setlocal
set INPUT=%~1
set EXTRA=%2

REM Verify: --------------------------------------------
if "%INPUT%" == "" (
	echo Error: Empty arg 1
	pause
	exit /b 400
)
if not exist "%INPUT%" (
	REM https://stackoverflow.com/questions/11944074/parenthesis-in-variables-inside-if-blocks
	REM for %%^" in ("") do echo Error: File not found: %%~"[%INPUT%]%%~"
	REM Parentheses in filename! Will use double-quotes for now...
	echo Error: File not found "%INPUT%"
	pause
	exit /b 404
)

:end
if "%EXTRA%" NEQ "silent" (
	echo File: "%INPUT%"
)
exit /b %ERRORLEVEL%
