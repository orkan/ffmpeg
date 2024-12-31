@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat %0 %*

set "INFILE=%~1"
set "ROTATION=%~2"
set "OUTFILE=%~3"

echo **********************************************************************************************
echo   Video rotate v%APP_VERSION%
echo   Usage: %~nx0 ^<infile^> ^<rotation^> [outfile]
echo   Notes:
echo   - only changes [rotate] flag in metadata video
echo   - make sure your video player can read this flag
echo **********************************************************************************************
echo Inputs:
echo    INFILE: "%INFILE%"
echo  ROTATION: "%ROTATION%"
echo   OUTFILE: "%OUTFILE%"
echo.

REM ---------------------------------------------------------------------------
REM Verify:
call _inputfile.bat "%INFILE%" silent || goto :end

if "%ROTATION%" == "" (
	echo [%~n0] Empty ROTATION!
	exit /b 400
)

REM [stackoverflow] Rotate mp4 videos without re-encoding
REM https://stackoverflow.com/a/27768317/166689
REM set ROTATE=-metadata:s:v:0 rotate=%ROTATION%
REM [GitHub Gist] ViktorNova/rotate-video.sh
REM https://gist.github.com/ViktorNova/1dd68a2ec99781fd9adca49507c73ee2
set ROTATE=-metadata:s:v rotate="%ROTATION%"
if "%OUTFILE%" == "" (
	set "OUTFILE=%~dpn1.[r%ROTATION%]%~x1"
)

set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%ROTATE%]"

REM ---------------------------------------------------------------------------
REM Command:
call _log.bat %~nx0 %*
call ffmpeg -y -i "%INFILE%" -c copy %METAS% %ROTATE% "%OUTFILE%"
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Finalize:
:end
exit /b %ERRORLEVEL%
