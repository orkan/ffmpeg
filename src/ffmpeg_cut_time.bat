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

echo ***************************************************************
echo   Cut video by start/end timestamps
echo     Usage: %~nx0 ^<infile^> [start] [end] [outfile] [streams]
echo      Note: [start] and [end] are optional, use "" for defaults
echo   Example: %~nx0 "infile.mp4" 10:08 1:25:18
echo ***************************************************************
echo.

REM Import: -------------------------------------------
set INFILE=%~1
set SS=%~2
set TO=%~3
set OUTFILE=%~4
set STREAMS=%~5
set RECALL=%~6

set FFMPEG_ERRORLEVEL=0
set WAIT_FILE=%~dpn0.lock

REM Display: -------------------------------------------
echo Inputs:
echo  INFILE: "%INFILE%"
echo      SS: "%SS%"
echo      TO: "%TO%"
echo OUTFILE: "%OUTFILE%"
echo STREAMS: "%STREAMS%"
echo.

REM Reset wait file? -----------------------------------
if "%INFILE%" == "" (
	call :waitEnd
	goto :end
)

REM Verify: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM Config: --------------------------------------------
set SS=-ss %SS%
set TO=-to %TO%
if "%SS%" == "-ss " set SS=-ss 0
if "%TO%" == "-to " set TO=
if "%STREAMS%" == "" set STREAMS=-map 0:v -map 0:a:0 -map 0:a:1? -map 0:s:0?

REM Strings: -------------------------------------------
set SS_STR=%SS::=.%
if "%TO%" NEQ "" (
	set TO_STR=%TO::=.%
)

REM Outfile: -------------------------------------------
if "%OUTFILE%" == "" (
	REM Use quoted set "FILE=name with ().ext" in case of parenthesized file names!
	set "OUT_PATH=%~dp1"
	set "OUT_BASENAME=%~n1"
	set "OUT_FILENAME=%~nx1"
	set "OUT_EXT=%~x1"
) else (
	set "OUT_PATH=%~dp4"
	set "OUT_BASENAME=%~n4"
	set "OUT_FILENAME=%~nx4"
	set "OUT_EXT=%~x4"
)
set OUTFILE=%OUT_PATH%%OUT_BASENAME%.[%SS_STR%][%TO_STR%]%OUT_EXT%

REM Recall: --------------------------------------------
REM Use "recall" file to remember command in case of system crash
REM Or... remove current "recall" file at success exit
set RECALL_FILE=%~dpn0.[recall][%DATETIME%][%OUT_FILENAME%][%SS_STR%][%TO_STR%].bat
if "%RECALL%" == "" (
	echo %~nx0 %* "%%~nx0" > "%RECALL_FILE%"
) else (
	set RECALL_FILE=%~dp0%RECALL%
)

REM META tags: -----------------------------------------
for /f "tokens=*" %%x in ( 'call _location.bat "%INFILE%"' ) do set LOCATION=%%x
if "%LOCATION%" NEQ "" set META_LOCATION=gps:[%LOCATION%]
set METAS=%META_GLOBAL% -metadata description="%META_LOCATION%" -metadata comment="%~nx0 [%SS%] [%TO%] %META_USER_COMMENT%"

REM Wait: -------------------------------------------
REM Don't run multiple threads on the same time b/c of disk usage overhead
:wait
if not exist "%WAIT_FILE%" (
	echo "%OUTFILE%" > "%WAIT_FILE%"
	goto :run
)
call :waitSleep 4
goto :wait

REM Run: -----------------------------------------------
:run
call _log.bat %~nx0 %*
REM https://wjwoodrow.wordpress.com/2013/02/04/correcting-for-audiovideo-sync-issues-with-the-ffmpeg-programs-itsoffset-switch/
REM https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video
call ffmpeg -y -i "%INFILE%" %SS% %TO% %STREAMS% -c copy %METAS% "%OUTFILE%"
set FFMPEG_ERRORLEVEL=%ERRORLEVEL%

REM Finalize: ------------------------------------------
:end
call :clean
exit /b %FFMPEG_ERRORLEVEL%

REM Functions: -----------------------------------------
:waitSleep
if "%WAIT_SHOW%" == "" (
	echo.
	echo Waiting for previous thread to finish...
	set WAIT_SHOW=1
)
REM Pause for X sec
ping 127.0.0.1 -n %1 > nul
goto :eof

REM Release lock file for next thread
:waitEnd
if %FFMPEG_ERRORLEVEL% == 0 (
	if exist "%WAIT_FILE%" (
		del "%WAIT_FILE%"
	)
)
goto :eof

:clean
if %FFMPEG_ERRORLEVEL% == 0 (
	if exist "%RECALL_FILE%" (
		del "%RECALL_FILE%"
	)
	call :waitEnd
)
goto :eof
