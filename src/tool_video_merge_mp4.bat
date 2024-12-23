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
call _header.bat "%~nx0"

echo **********************************************************************************************
echo   Tool: Merge MP4 Videos v%APP_VERSION%
echo   Note: Only ACC audio is supported
echo **********************************************************************************************
echo.

REM ---------------------------------------------------------------------------
REM Dirs setup:
:mp4dir
set /p MP4DIR=Input videos dir: 
if not exist "%MP4DIR%" (
	echo [%~n0] Dir not found! "%MP4DIR%"
	goto :mp4dir
)

echo Files:
for %%f in (%MP4DIR%\*.mp4) do echo %%f

echo.
set /p YESNO=Proceed? [y/N]: 
if "%YESNO%" NEQ "y" (
	set APP_ERRORLEVEL=406
	goto :end
)

:tmpdir
set /p TMPDIR=Temp dir [%DEFAULT_TOOL_VIDEO_MERGE_OUTDIR%]: 
if "%TMPDIR%" == "" set TMPDIR=%DEFAULT_TOOL_VIDEO_MERGE_OUTDIR%
call _inputfile.bat "%TMPDIR%" silent || goto :tmpdir

:outdir
set /p OUTDIR=Output dir [%DEFAULT_TOOL_VIDEO_MERGE_OUTDIR%]: 
if "%OUTDIR%" == "" set OUTDIR=%DEFAULT_TOOL_VIDEO_MERGE_OUTDIR%
call _inputfile.bat "%OUTDIR%" silent || goto :outdir

REM ---------------------------------------------------------------------------
REM Create intermediate TS files:
set COUNT=0
set TODEL=
for %%f in (%MP4DIR%\*.mp4) do (
	call :toIntermediate "%%f" || goto :end
	set /a COUNT+=1
)
if "%COUNT%" == "0" (
	echo [ERROR] No files in "%MP4DIR%"
	set APP_ERRORLEVEL=404
	goto :end
)

REM ---------------------------------------------------------------------------
REM Concat videos:
call ffmpeg -y -i "concat:%CONCAT%" -c copy -bsf:a aac_adtstoasc "%OUTDIR%\%FIRSTNAME%.[merged].mp4" || goto :end
if %ERRORLEVEL% GEQ 1 goto :end

REM ---------------------------------------------------------------------------
REM Delete intermediate files:
echo.
set /p DELYESNO=Delete temp files? [Y/n]: 
if "%DELYESNO%" == "n" goto :end
del %TODEL%

REM ---------------------------------------------------------------------------
REM Finalize:
:end
call _status.bat "" %APP_ERRORLEVEL%
exit /b %ERRORLEVEL%

REM ===========================================================================
REM Functions:
REM ---------------------------------------------------------------------------
:toIntermediate
set NAME=%~n1
set TSNAME=%TMPDIR%\%NAME%.ts
set TODEL=%TODEL% "%TSNAME%"
if %COUNT% == 0 (
	set "FIRSTNAME=%NAME%"
	set "CONCAT=%TSNAME%"
) else (
	set "CONCAT=%CONCAT%|%TSNAME%"
)
call ffmpeg -y -i "%MP4DIR%\%NAME%.mp4" -c copy -bsf:v h264_mp4toannexb -f mpegts "%TSNAME%" || exit /b
goto :eof
