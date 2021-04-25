@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Merge MP4 Videos
echo   Note: Only ACC sound in MP4 is supported
echo ***************************************************
echo.

REM Dirs setup: ----------------------------------------
:mp4dir
set /p MP4DIR=Input videos dir: 
if not exist "%MP4DIR%" (
	echo Not exist: [%MP4DIR%]
	goto :mp4dir
)
echo Files:
for %%f in (%MP4DIR%\*.mp4) do echo %%f
echo.
set /p YESNO=Proceed? [Y/n]: 
if "%YESNO%" == "n" (
	set ERRORLEVEL=406
	goto :end
)

:tmpdir
set /p TMPDIR=Temp dir [%TOOL_VIDEO_MERGE_TMPDIR%]: 
if "%TMPDIR%" == "" set TMPDIR=%TOOL_VIDEO_MERGE_TMPDIR%
call _inputfile.bat "%TMPDIR%" silent || goto :tmpdir

:outdir
set /p OUTDIR=Output dir [%TOOL_VIDEO_MERGE_OUTDIR%]: 
if "%OUTDIR%" == "" set OUTDIR=%TOOL_VIDEO_MERGE_OUTDIR%
call _inputfile.bat "%OUTDIR%" silent || goto :outdir

REM Create intermediate TS files: ----------------------
set COUNT=0
set TODEL=
for %%f in (%MP4DIR%\*.mp4) do (
	call :toIntermediate "%%f" || exit /b
	set /a COUNT+=1
)
if "%COUNT%" == "0" (
	echo No files in "%MP4DIR%"
	set ERRORLEVEL=404
	goto :end
)

REM Concat videos: -------------------------------------
call ffmpeg -y -i "concat:%CONCAT%" -c copy -bsf:a aac_adtstoasc "%OUTDIR%\%FIRSTNAME%.[merged].mp4" || goto :end

REM Delete intermediate files: -------------------------
echo.
set /p DELYESNO=Delete temp files? [Y/n]: 
if "%DELYESNO%" == "n" goto :end
del %TODEL%

REM Finalize: ------------------------------------------
:end
call _status.bat
exit /b

REM Functions: -----------------------------------------
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
