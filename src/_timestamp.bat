@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

REM Normalize timestamp string to hh:mm:ss format (with zero padding)
REM Usage:
REM   %1 - Raw timestamp eg. "1" "2:31" "5 46" "1 12 76"

setlocal
set "STR=%~1"
if "%STR%" == "" set STR=0

REM Replace spaces to colons eg. "1 12 76" == "1:12:76"
set STR=%STR: =:%

REM Extract H,M,S from string
for /f "tokens=1-3 delims=:" %%A in ("%STR%") do (
	set H=%%A
	set M=%%B
	set S=%%C
	if "%%C" == "" (
		set H=0
		set M=%%A
		set S=%%B
	)
	if "%%B" == "" (
		set H=0
		set M=0
		set S=%%A
	)
	if "%%A" == "" (
		set H=0
		set M=0
		set S=0
	)
)

REM LPad H,M,S with zeros
set H=0%H%
set H=%H:~-2%
set M=0%M%
set M=%M:~-2%
set S=0%S%
set S=%S:~-2%

echo %H%:%M%:%S%
exit /b
