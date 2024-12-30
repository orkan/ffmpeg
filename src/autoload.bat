@echo off
REM ===========================================================================
REM Starter script for ork-ffmpeg tools.
REM Usage: autoload.bat <tool_*.bat> [arg1 ... arg8]
REM ---------------------------------------------------------------------------
REM By extending %APP_TOOLS_PATH% you can add your own custom tools locations.
REM 1. Create custom config: my-config.bat
REM 	set APP_TOOLS_PATH=%APP_TOOLS_PATH%;D:\MyTools
REM 	set MY_VALUE=This VAR will be available in all tools
REM 2. Create custom starter: my-ffmpeg.bat
REM 	set ORKAN_FFMPEG_USER_CONFIG=path\to\my-config.bat
REM 	call path\to\this\autoload.bat %*
REM 3. Run original autoload via custom starter
REM 	my-ffmpeg.bat convert.bat files_default.bat
REM		my-ffmpeg.bat tool_mp4.bat myfile.mov arg2 arg3
REM ===========================================================================

setlocal
pushd %~dp0
call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

REM Search for %1 filename in defined locations form %APP_TOOLS_PATH%
REM Add current script location to help resolving relative paths
REM Return %~f1 if found, empty otherwise:
set AUTOLOAD_TOOL_ABS=%~f$APP_TOOLS_PATH:1
if not exist "%AUTOLOAD_TOOL_ABS%" (
	echo [%~n0] Unable to locate TOOL "%~1"
	echo [%~n0] Was using "%APP_TOOLS_PATH%"
	exit /b 404
)

call "%AUTOLOAD_TOOL_ABS%" %2 %3 %4 %5 %6 %7 %8 %9
