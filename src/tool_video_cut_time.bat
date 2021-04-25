@echo off
setlocal
call _config.bat reload
call _header.bat "%~nx0"

echo ***************************************************
echo   Tool: Video cut by timestamps
echo ***************************************************

REM Import: --------------------------------------------
set INFILE=%~1
set OUTFILE=%~2
set EXTRA=%~3

REM Display: ------------------------------------------
echo Inputs:
echo INFILE : "%INFILE%"
echo OUTFILE: "%OUTFILE%"
echo   EXTRA: "%EXTRA%"

REM Infile: --------------------------------------------
call _inputfile.bat "%INFILE%" silent || goto :end

REM Input: ---------------------------------------------
echo.
set /p START=Start time [0:0:0]: 
set /p END=End time [End of video]: 

REM Command: -------------------------------------------
echo.
call ffmpeg_cut_time.bat "%INFILE%" "%START%" "%END%" "%OUTFILE%" || goto :end

REM Finalize: ------------------------------------------
:end
call _status.bat %EXTRA%
