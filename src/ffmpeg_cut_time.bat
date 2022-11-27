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
echo   Example: %~nx0 "infile.mp4" 10:08 1:25:18
echo      Note: [start] and [end] are optional, use "" for defaults
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
set SS_ARG=-ss %SS%
set TO_ARG=-to %TO%
if "%SS_ARG%" == "-ss " set SS_ARG=-ss 0
if "%TO_ARG%" == "-to " set TO_ARG=
if "%STREAMS%" == "" set STREAMS=-map 0:v -map 0:a:0 -map 0:a:1? -map 0:s:0?

REM Strings: -------------------------------------------
set SS_STR=%SS_ARG::=.%
if "%TO_ARG%" NEQ "" (
	set TO_STR=%TO_ARG::=.%
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
set OUTNAME=%OUT_BASENAME%.[%SS_STR%][%TO_STR%]%OUT_EXT%
set OUTFILE=%OUT_PATH%%OUTNAME%
REM Segment:
REM set OUTFILE=%OUT_PATH%%OUT_BASENAME%.[%SS_STR%][%TO_STR%][seg-%%%%03d]%OUT_EXT%

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
set METAS=%META_GLOBAL% -metadata description="%META_LOCATION%" -metadata comment="%~nx0 [%SS_ARG%] [%TO_ARG%] %META_USER_COMMENT%"

REM Wait: -------------------------------------------
REM Don't run multiple threads on the same time b/c of disk usage overhead
set WAIT_TIME=4
set WAIT_LOOP=0
set WAIT_TOTAL=0
:wait
if not exist "%WAIT_FILE%" (
	echo "%OUTFILE%" > "%WAIT_FILE%"
	goto :run
)
set /A WAIT_LOOP += 1
set /A WAIT_TOTAL = WAIT_LOOP * WAIT_TIME
TITLE Waiting %WAIT_TOTAL% sec...
call :waitSleep %WAIT_TIME%
goto :wait

REM Run: -----------------------------------------------
:run
TITLE %OUTNAME%
call _log.bat %~nx0 %*
REM https://wjwoodrow.wordpress.com/2013/02/04/correcting-for-audiovideo-sync-issues-with-the-ffmpeg-programs-itsoffset-switch/
REM https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video
REM https://stackoverflow.com/questions/14005110/how-to-split-a-video-using-ffmpeg-so-that-each-chunk-starts-with-a-key-frame
call ffmpeg -y -i "%INFILE%" %SS_ARG% %TO_ARG% %STREAMS% -c copy %METAS% "%OUTFILE%"
REM Segment:
REM https://www.ffmpeg.org/ffmpeg-formats.html#toc-segment_002c-stream_005fsegment_002c-ssegment
REM call ffmpeg -y -i "%INFILE%" %SS_ARG% %TO_ARG% -f segment -segment_time 999999 -reset_timestamps 1 %STREAMS% -c copy %METAS% "%OUTFILE%"
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
) else (
	TITLE Error ^(%FFMPEG_ERRORLEVEL%^)
)
goto :eof
