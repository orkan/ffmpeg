@echo off
setlocal
call _config.bat
call _header.bat "%~nx0"

set FFMPEG_EXE=%~n0.exe

if not exist "%FFMPEG_HOME%" (
	set FFMPEG_HOME=%FFMPEG_HOME_DEF%
)

set EXE_LOC=%FFMPEG_HOME%\%FFMPEG_EXE%

if not exist "%EXE_LOC%" (
	echo Error: Can't find %FFMPEG_EXE% in [%FFMPEG_HOME%]
	exit /b 410
)

REM Get fully qualified path name
REM https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name
pushd %FFMPEG_HOME%
set EXE_ABS=%CD%\%FFMPEG_EXE%
popd

set COMMAND=%EXE_ABS% %*
echo.
echo %COMMAND%

if "%FFMPEG_ERROR%" NEQ "" (
	endlocal
	set ERRORLEVEL=%FFMPEG_ERROR%
	exit /b
)

if "%FFMPEG_DEBUG%" == "" (
	echo.
	%COMMAND%
)
