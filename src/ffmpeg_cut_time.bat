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
set LAST_ERRORLEVEL=0

echo ***************************************************************
echo   Cut video by start/end timestamps
echo   Usage  : %~nx0 ^<infile^> [start] [end] [outfile] [streams]
echo   Note   : [start] and [end] are optional, use "" for defaults
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
set WAIT_FILE=%~dpn0.lock
set RECALL_FILE=%~dpn0.recall%DATETIME%.bat

REM Recall: --------------------------------------------
REM Use "recall" file to remember command in case of system crash
REM Or... remove current "recall" file at success exit
if "%RECALL%" == "" (
	echo %~nx0 %* %%~nx0 > "%RECALL_FILE%"
) else (
	set RECALL_FILE=%~dp0%RECALL%
)

REM Display: -------------------------------------------
echo Inputs:
echo INFILE  : [%INFILE%]
echo SS      : [%SS%]
echo TO      : [%TO%]
echo OUTFILE : [%OUTFILE%]
echo STREAMS : [%STREAMS%]
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
if "%STREAMS%" == "" set STREAMS=-map 0:v -map 0:a:0 -map 0:a:1?

REM Strings: -------------------------------------------
set SS_STR=%SS::=.%
if "%TO%" NEQ "" (
	set TO_STR=%TO::=.%
)

REM Outfile: -------------------------------------------
if "%OUTFILE%" == "" (
	REM Use quoted set "FILE=name with ().ext" in case of parenthesized file names!
	set "PATH1=%~dpn1"
	set "PATH2=%~x1"
) else (
	set "PATH1=%~dpn4"
	set "PATH2=%~x4"
)
set OUTFILE=%PATH1%.[%SS_STR%][%TO_STR%]%PATH2%

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
REM https://wjwoodrow.wordpress.com/2013/02/04/correcting-for-audiovideo-sync-issues-with-the-ffmpeg-programs-itsoffset-switch/
REM https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video
call ffmpeg -y -i "%INFILE%" %SS% %TO% %STREAMS% -c copy %METAS% "%OUTFILE%"
set LAST_ERRORLEVEL=%ERRORLEVEL%

del "%RECALL_FILE%"
call :waitEnd

REM Finalize: ------------------------------------------
:end
exit /b %LAST_ERRORLEVEL%

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
if %LAST_ERRORLEVEL% == 0 (
	if exist "%WAIT_FILE%" (
		del "%WAIT_FILE%"
	)
)
goto :eof
