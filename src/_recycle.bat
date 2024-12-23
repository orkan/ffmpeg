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

REM ---------------------------------------------------------------------------
REM Command:
set COMMAND=%BIN_RECYCLE% "%INFILE%"
if "%APP_DEBUG%" NEQ "" echo [RECYCLE: %COMMAND%]

echo.
%COMMAND%

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
