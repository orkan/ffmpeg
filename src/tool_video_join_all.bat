@echo off

REM Global NOWAIT - always pause after error in sub-tool
set APP_NOWAIT=%~n0

REM Remember main-tool NOWAIT after endlocal
set "NOWAIT=%~2"

pushd %~dp0
call _config.bat
call _header.bat %0 %*

setlocal
set "OUTDIR=%~1"
set "EXTS=%~2"
REM set "NOWAIT=%~3" // @see above
set "INDIR=%~4"

if "%EXTS%" == "" set EXTS=ts,vob

echo ==============================================================================================
echo    Tool: Join files in ALL subfolders v%APP_VERSION%
echo   Usage: %~nx0 ^<outdir^> [exts=ts,vob] [nowait] ^<indir^>
echo ==============================================================================================

:outdir_check
if exist "%OUTDIR%" goto outdir_check_ok
set /p OUTDIR=OUTDIR [%OUTDIR%] not found:
goto outdir_check
:outdir_check_ok

for /f "tokens=1-3 delims=/." %%A in ("%DATE%") do set YMD=%%C%%B%%A
set OUTDIR=%OUTDIR%\%YMD%
mkdir "%OUTDIR%"

echo Inputs:
echo   OUTDIR: "%OUTDIR%"
echo     EXTS: "%EXTS%"
echo   NOWAIT: "%NOWAIT%"
echo    INDIR: "%INDIR%"

REM ---------------------------------------------------------------------------
pushd "%INDIR%"
set TOT=0
set CUR=0

call :showTitleDefault "%INDIR%"
echo.
echo Queue subfolders:
for /D %%D in ("%INDIR%\*") do (
	call :setDIRS "%%~D"
)

:start
echo.
pause

for %%D in (%DIRS%) do (
	call :join "%%~D" || goto :end
)

call :showTitleDefault "%INDIR%"

REM ---------------------------------------------------------------------------
REM Finalize:
:end
echo ==============================================================================================
REM endlocal - bring original NOWAIT
endlocal
set APP_NOWAIT=
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%

REM ===========================================================================
REM Functions:

REM ---------------------------------------------------------------------------
REM Call join tool in current sub-dir
:join
set /a CUR+=1
call :showTitle %1
echo.
echo [%CUR%/%TOT%] %~nx1
set COMMAND=%~dp0tool_video_join.bat "%OUTDIR%" "%EXTS%" nowait %1
call %COMMAND%
exit /b %ERRORLEVEL%

REM ---------------------------------------------------------------------------
REM Get list of sub-dirs to proccess
:setDIRS
set /a TOT+=1
set DIRS=%DIRS%;%1
echo %TOT%. "%~1"
goto :eof

REM ---------------------------------------------------------------------------
:showTitle
TITLE [%CUR%/%TOT%] %~nx1 - "%~1\*.%EXTS%"
goto :eof

REM ---------------------------------------------------------------------------
:showTitleDefault
TITLE [JOIN ALL] "%~1"
goto :eof
