@echo off
REM =============================================================
REM Starter script for ork-ffmpeg tools.
REM Usage: autoload.bat <tool_*.bat> [arg1 ... arg8]
REM -------------------------------------------------------------
REM This script will look for <tool_*.bat> in all defined
REM locations from %APP_TOOLS_PATH%.
REM Tip: Use the user config.bat file to add more paths!
REM -------------------------------------------------------------
REM Example:
REM 1. Create starter file on system path:
REM [ork-ffmpeg.bat]
REM set ORKAN_FFMPEG_USER_CONFIG=D:\...\ork-ffmpeg\usr\bin\config.bat
REM call D:\...\ork-ffmpeg\vendor\orkan\ffmpeg\src\autoload.bat %*
REM 2. Call it with commands:
REM ork-ffmpeg.bat convert.bat files_default.bat <-- found [files_default.bat] in usr\
REM ork-ffmpeg.bat tool_mp4.bat myfile.mov arg2 arg3 <-- found [tool_mp4.bat] in src\
REM ork-ffmpeg.bat tool_ork.bat myfile.avi arg2 arg3 <-- found [tool_ork.bat] in usr\
REM =============================================================

setlocal
pushd %~dp0
call %~dp0_config.bat
call %~dp0_header.bat "%~nx0"

REM Search for %1 filename in defined locations form %APP_TOOLS_PATH%
REM Add current script location to help resolving relative paths
REM Return %~f1 if found, empty otherwise:
set AUTOLOAD_TOOL_ABS=%~f$APP_TOOLS_PATH:1
if not exist "%AUTOLOAD_TOOL_ABS%" (
	echo [AUTOLOAD] Unable to locate TOOL: "%~1"
	echo [AUTOLOAD] Was using: "%APP_TOOLS_PATH%"
	exit /b 404
)

call "%AUTOLOAD_TOOL_ABS%" %2 %3 %4 %5 %6 %7 %8 %9
