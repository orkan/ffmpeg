@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Video to GIF
echo ***************************************************

REM Input: ---------------------------------------------
call _inputfile.bat %1 || goto :end

REM User: ----------------------------------------------
echo.
set /p START=Start time [0:0.0]: 
set /p DURATION=Duration [0:0.0]: 

REM Command: --------------------------------------------------
echo.
call ffmpeg_gif.bat %1 %START% %DURATION% || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat
