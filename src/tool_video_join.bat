@echo off

setlocal
pushd %~dp0
call _config.bat
call _header.bat %0 %*

set "OUTDIR=%~1"
set "EXTS=%~2"
set "NOWAIT=%~3"
set "INDIR=%~4"

if "%EXTS%" == "" set EXTS=ts,vob

echo **********************************************************************************************
echo    Tool: Binary join files v%APP_VERSION%
echo   Usage: %~nx0 ^<outdir^> [exts=ts,vob] [nowait] ^<indir^>
echo **********************************************************************************************
echo Inputs:
echo   OUTDIR: "%OUTDIR%"
echo     EXTS: "%EXTS%"
echo   NOWAIT: "%NOWAIT%"
echo    INDIR: "%INDIR%"

REM ---------------------------------------------------------------------------
pushd "%INDIR%"
set TOT=0
set CUR=0

for %%E in (%EXTS%) do call :setEXT %%E || goto :start
call :err "No supported video files found"
goto :end

REM ---------------------------------------------------------------------------
:start
if "%NOWAIT%" == "" (
	echo.
	pause
)

REM Clear output file
for %%F in (.) do set OUTFILE=%%~nxF.%EXT%
type nul > "%OUTDIR%\%OUTFILE%"

echo.
echo Join:
for %%F in (%FILES%) do (
	call :join "%%~F" || goto :end
)

echo.
echo Save:
echo %OUTDIR%\%OUTFILE%

REM ---------------------------------------------------------------------------
REM Finalize:
:end
popd
call _status.bat "%NOWAIT%"
exit /b %ERRORLEVEL%

REM ===========================================================================
REM Functions:

REM ---------------------------------------------------------------------------
REM Join vids in current dir
:join
set /a CUR+=1
echo [%CUR%:%TOT%] "%~nx1"
pushd %OUTDIR%
if "%APP_DEBUG%" NEQ "" echo copy /b "%OUTFILE%" + %1
REM Note: copy needs output dir set to current dir!
copy /b "%OUTFILE%" + %1 >nul
popd
exit /b %ERRORLEVEL%

REM ---------------------------------------------------------------------------
:setEXT
REM Find supported vids in current dir. First found extension wins!
echo.
echo Files: *.%1
for /F "tokens=*" %%F in ('dir /b /a:-d /o:n *.%1') do (call :setFILES "%CD%\%%~F")
if %TOT% == 0 goto :eof
set EXT=%1
exit /b 100

REM ---------------------------------------------------------------------------
REM Build list of video files to join
:setFILES
set /a TOT+=1
echo %TOT%: "%~nx1"
set FILES=%FILES%;%1
goto :eof

REM ---------------------------------------------------------------------------
:err
echo.
echo %~1. Bye!
exit /b %2
