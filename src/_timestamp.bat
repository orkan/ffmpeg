@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM =============================================================

setlocal
set "T=%~1"
set "D=%~2"

if "%T%" == "" (
	if "%D%" NEQ "" echo %D%
	exit /b
)

REM Replace spaces to : (colons)
set T=%T: =:%

REM Normalize timestamp string, ie. 1:23 to 0:1:23
for /f "tokens=1-3 delims=:" %%a in ("%T%") do (
	set H=%%a
	set M=%%b
	set S=%%c
	if "%%c" == "" (
		set H=0
		set M=%%a
		set S=%%b
	)
	if "%%b" == "" (
		set H=0
		set M=0
		set S=%%a
	)
)

echo %H%:%M%:%S%
