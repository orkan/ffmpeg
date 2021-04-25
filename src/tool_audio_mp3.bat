@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Video to MP3
echo ***************************************************

REM Input: ---------------------------------------------
call _inputfile.bat %1 || goto :end

REM User: ----------------------------------------------
echo.
set /p BRATE=Bitrate [%DEFAULT_MP3_BRATE%]: 
set /p SRATE=Sample [%DEFAULT_MP3_SRATE%]: 

REM Command: -------------------------------------------
call ffmpeg_mp3.bat "%~1" "%BRATE%" "%SRATE%" || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat
