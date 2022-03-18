@echo off
REM =================================================
REM ffmpeg (W)indows (C)ontext (T)ools (c) 2022 Orkan
REM -------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM https://github.com/orkan/ffmpeg
REM =================================================

setlocal
set SRC=%~dp0..\src
set TESTS=%~dp0..\..\var\tests

REM This is the default file for src\convert.bat - don't change it!
REM You can create your own and call convert.bat "usr\myfiles.bat"
REM Use absolute paths b/c all paths here are relative to /bat dir
REM All paths must use wildcards: * or ?

REM Test all: -----------------------------------------
echo %SRC%\ffmpeg_audio_silence.bat "%TESTS%\silence.mp3" 4
echo %SRC%\ffmpeg_cut_time.bat "%TESTS%\ac3\*.ts" 1 3
echo %SRC%\ffmpeg_mp3.bat "%TESTS%\name\*.mp?"
echo %SRC%\ffmpeg_gif.bat "%TESTS%\vids\0003 REPLA?.mp4" 1 2
echo %SRC%\ffmpeg_mp4.bat "%TESTS%\vids\*REPLAY.mp4" "" "-an"
echo %SRC%\ffmpeg_rotate.bat "%TESTS%\vids\*REPLAY.mp4" 90
