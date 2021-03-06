@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
pushd %~dp0
call _config.bat
call _header.bat "%~nx0"

echo ********************************************************
echo   Video rotation
echo   Usage: %~nx0 ^<infile^> ^<rotation^> [outfile]
echo   Notes:
echo   - only changes [rotate] flag in metadata video
echo   - make sure your video player can read this flag
echo ********************************************************

REM Import: -------------------------------------------
set INFILE=%~1
set ROTATION=%~2
set OUTFILE=%~3

REM Display: -------------------------------------------
echo Inputs:
echo   INFILE: "%INFILE%"
echo ROTATION: "%ROTATION%"
echo  OUTFILE: "%OUTFILE%"
echo.

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end
if "%ROTATION%" == "" (
	echo Error: Empty ^<rotation^>
	set ERRORLEVEL=400
	goto :end
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

set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%ROTATE%] %META_USER_COMMENT%"

REM Command: -------------------------------------------
call ffmpeg -y -i "%INFILE%" -c copy %METAS% %ROTATE% "%OUTFILE%"

REM Finalize: ------------------------------------------
:end
exit /b %ERRORLEVEL%
