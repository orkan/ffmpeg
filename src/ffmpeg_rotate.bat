@echo off
setlocal
call _config.bat
call _header.bat "%~nx0"

echo ***************************************************
echo   Video rotation
echo   Usage: %~nx0 infile rotation [outfile]
echo   Description:
echo   - only changes [rotate] flag in metadata video
echo   - make sure your video player can read this flag
echo ***************************************************

REM Config: --------------------------------------------
set INFILE=%~1
set ROTATION=%~2
set OUTFILE=%~3

if "%ROTATION%" == "" (
	echo Error: Missing rotation value
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

REM META tags: -----------------------------------------
set METAS=%META_GLOBAL% -metadata comment="%~nx0 [%ROTATE%] %META_USER_COMMENT%"

REM Command: -------------------------------------------
call ffmpeg -y -i "%INFILE%" -c copy %METAS% %ROTATE% "%OUTFILE%"

exit /b %ERRORLEVEL%
