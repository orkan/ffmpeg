@echo off
REM Tip: Status codes https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400

if "%ERRORLEVEL%" == "" set ERRORLEVEL=0
set EXTRA=%1

echo.
if %ERRORLEVEL% == 0 (
	echo BUILD SUCCESSFUL
	if "%EXTRA%" == "quit_on_success" goto :eof
) else (
	echo BUILD FAILED [Error: %ERRORLEVEL%]
)

echo.
pause
