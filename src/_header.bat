@echo off
call _config.bat
setlocal

REM Display [header] only in DEBUG mode
if "%FFMPEG_DEBUG%" == "" exit /b

if "%FFMPEG_DEBUG%" NEQ "" set INFO_DEBUG=Debug mode: ON
if "%FFMPEG_ERROR%" NEQ "" set INFO_DEBUG=%INFO_DEBUG%, ERRORLEVEL: %FFMPEG_ERROR%
if "%INFO_DEBUG%"   NEQ "" set INFO_DEBUG=(%INFO_DEBUG%)

echo.
echo [%~1] %INFO_DEBUG%
