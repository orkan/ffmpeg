@echo off
setlocal

REM Import: -------------------------------------------------
set INPUT=%~1
set EXTRA=%2

if "%INPUT%" == "" (
	echo Error: Empty input
	exit /b 400
)
if not exist "%INPUT%" (
	REM https://stackoverflow.com/questions/11944074/parenthesis-in-variables-inside-if-blocks
	REM for %%^" in ("") do echo Error: File not found: %%~"[%INPUT%]%%~"
	REM Parentheses in filename! Will use double-quotes for now...
	echo Error: File not found "%INPUT%"
	exit /b 404
)
if "%EXTRA%" == "silent" (
	exit /b
)

echo File: %INPUT%
