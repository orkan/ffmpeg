@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Video Rotate
echo ***************************************************

REM Input: ---------------------------------------------
call _inputfile.bat %1 || goto :end

REM User: ----------------------------------------------
echo.
set /p ROTATION=Rotation: 

REM Command: -------------------------------------------
echo.
call ffmpeg_rotate.bat %1 %ROTATION% || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat
