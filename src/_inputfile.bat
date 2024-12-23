@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

setlocal
set "INFILE=%~1"
set "SILENT=%~2"

REM ---------------------------------------------------------------------------
REM Verify:
if "%INFILE%" == "" (
	echo Error: Empty INFILE
	exit /b 400
)
if not exist "%INFILE%" (
	REM https://stackoverflow.com/questions/11944074/parenthesis-in-variables-inside-if-blocks
	REM for %%^" in ("") do echo Error: File not found: %%~"[%INFILE%]%%~"
	REM Parentheses in filename! Will use double-quotes for now...
	echo Error: File not found "%INFILE%"
	exit /b 404
)

REM ---------------------------------------------------------------------------
REM Finalize:
:end
if "%SILENT%" == "" (
	echo Exists: "%INFILE%"
)

exit /b %ERRORLEVEL%
