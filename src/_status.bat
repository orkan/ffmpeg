@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

REM Tip: Status codes https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400

echo.
if %ERRORLEVEL% == 0 (
	echo BUILD SUCCESSFUL
	if "%~1" == "quit_on_success" goto :eof
) else (
	echo BUILD FAILED ^(%ERRORLEVEL%^)
)
echo.
pause
