@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

REM Tip: Status codes https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400

REM Cant use setlocal cos it resets ERRORLEVEL !!!
REM setlocal
REM set "NOWAIT=%~1"

echo.
if %ERRORLEVEL% == 0 (
	echo BUILD SUCCESSFUL
	if "%~1" NEQ "" goto :eof
	if "%STATUS_NOWAIT%" NEQ "" goto :eof
) else (
	echo BUILD FAILED ^(%ERRORLEVEL%^)
	REM Always pause on errors!
)
echo.
pause
