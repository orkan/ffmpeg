@echo off
setlocal
set DATESTART=%DATE% %TIME%
set FILES=%1
if "%FILES%" == "" set "FILES=%~dp0..\usr\files_tests.bat"

call _config.bat
call _header.bat "%~nx0"
echo ******************************************************************
echo  Batch media converter
echo  Files: %FILES%
echo ******************************************************************
echo.
echo Queue:
call :config %FILES% show || goto :end
echo.
set /p SHUTDOWN_USER=When done (s - shutdown ^| h - hibernate ^| [n] - nothing): 

call :config %FILES% run
goto :end

REM FUNCTION::config() ---------------------------------
:config
REM Call :start with each echoed line from "files_***.bat"
set COUNT=0
for /f "tokens=*" %%a in ( 'call "%1"' ) do (
	call :start %2 %%a || exit /b
)
if %COUNT% == 0 (
	echo Error: No files!
	exit /b 204
)
goto :eof

REM FUNCTION::start() ----------------------------------
:start
REM To allow exclamation mark "!" in filenames we must DisableDelayedExpansion here
REM and in every submodule where %INFILE% is used
REM The drawback is that we cannot set variables in parentheses now
for %%f in (%3) do (
	set /a COUNT+=1

	if "%1" == "show" (
		echo call %2 "%%f" %4 %5 %6
	) else (
		echo.
		call %2 "%%f" %4 %5 %6 || exit /b
	)
)
goto :eof

REM Finalize: ------------------------------------------
:end
echo.
echo Started  on: %DATESTART%
echo Finished on: %DATE% %TIME%

set SHUTDOWN_TYPE=n
if "%SHUTDOWN_USER%" == "s" set SHUTDOWN_TYPE=/s
if "%SHUTDOWN_USER%" == "h" set SHUTDOWN_TYPE=/h
if "%SHUTDOWN_TYPE%" NEQ "n" (
	echo.
	echo Shuting down...
	if "%FFMPEG_DEBUG%" == "" (
		shutdown %SHUTDOWN_TYPE%
	) else (
		echo shutdown %SHUTDOWN_TYPE%
	)
)

call _status.bat
if %ERRORLEVEL% NEQ 0 exit /b
