@echo off
REM =============================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools v2 (c) 2021-2023 Orkan
REM -------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =============================================================

setlocal

set "INFILE=%~1"

REM -------------------------------------------------------------
REM Command:
set COMMAND=%BIN_RECYCLE% "%INFILE%"
if "%APP_DEBUG%" NEQ "" echo [RECYCLE: %COMMAND%]

echo.
%COMMAND%

REM -------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
