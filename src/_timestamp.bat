@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

setlocal
set "T=%~1"

if "%T%" == "" (
	echo 0:0:0
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
