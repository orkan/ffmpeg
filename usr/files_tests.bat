@echo off
REM This is the default file for bat\convert.bat - don't change it!
REM You can create your own and call convert.bat "usr\myfiles.bat"
REM Use absolute paths b/c all paths here are relative to /bat dir
REM All paths must use wildcards: * or ?

REM Convert to mp4
echo ffmpeg_cut_time.bat "%~dp0..\tests\videos\ac3\*.ts" 2 4
echo ffmpeg_mp4.bat "%~dp0..\tests\videos\name\*_.mp?" 25 24.99 "-an"
echo ffmpeg_mp4.bat "%~dp0..\tests\videos\ac3\*.ts" 44 10 "-map v:0 -map a:0 -map a:1? -c:a copy"

REM Convert to mp3
echo ffmpeg_mp3.bat "%~dp0..\tests\videos\vids\*.mp4"
