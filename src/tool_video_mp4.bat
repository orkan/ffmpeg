@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Video to MP4
echo ***************************************************

REM Input: ---------------------------------------------
call _inputfile.bat %1 || goto :end

REM User: ----------------------------------------------
echo.
set /p CRF=CRF value [quality 0(hi)-51(low): 23]: 
echo Extra options:
echo - video size: -s hd720 (1280x720), -s pal (720x576)
echo - video filter: -vf fps=30,eq=brightness=0.04,crop=1280:536:0:93
echo - audio AC3 to AAC: -map v:0 -map a:0 -c:a aac -ac 2 -ar 44100 -ab 192k -c:v copy
set /p EXTRA=EXTRA [-c:a copy]: 

REM Command: -------------------------------------------
echo.
call ffmpeg_mp4.bat "%~1" "%CRF%" "%EXTRA%" || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat
