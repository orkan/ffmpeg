@echo off
REM ===========================================================================
REM ork-ffmpeg (W)indows (C)ontext (T)ools
REM https://github.com/orkan/ffmpeg
REM ---------------------------------------------------------------------------
REM This file is part of orkan/ffmpeg package
REM Copyright (c) 2021 Orkan <orkans+ffmpeg@gmail.com>
REM ===========================================================================

if "%SRC_CONFIG_LOADED%" NEQ "" exit /b

REM ---------------------------------------------------------------------------
REM Debug: Use empty string to clear SWITCH!
REM set APP_DEBUG=1
REM set APP_ERROR=1

if "%APP_DEBUG%" NEQ "" echo [APP_CONFIG: %0]

REM ---------------------------------------------------------------------------
REM Setup:
set "APP_NAME=ork-ffmpeg"
set "APP_URL=https://github.com/orkan/ffmpeg"
set "APP_EMAIL=Orkan <orkans+ffmpeg@gmail.com>"
set "APP_YEAR=2021-2025"
set "APP_VERSION=2.7.7"
set "APP_VERSION_MIN=2.7"
set "APP_LONGNAME=%APP_NAME% v%APP_VERSION%"

REM Project dir from [vendor] dir
pushd %~dp0..\..\..\..
set PROJECT_DIR=%CD%
popd

set APP_TOOLS_PATH=%APP_TOOLS_PATH%;%~dp0
set LOG_DIR=%PROJECT_DIR%\var\log

REM Create date-time unique string, eg. 2022011209032911
set DATETIME=%DATE%.%TIME: =0%
for /f "tokens=1-7 delims=/:.," %%A in ("%DATETIME%") do set DATETIME=%%C%%B%%A%%D%%E%%F%%G

REM Create some random numbers
set UNIQUE1=%RANDOM%
set UNIQUE2=%RANDOM%

REM ---------------------------------------------------------------------------
REM Binaries:
set FFMPEG_BIN=%PROJECT_DIR%\bin
set BIN_RECYCLE=%FFMPEG_BIN%\Recycle.exe
set BIN_MP3GAIN=%FFMPEG_BIN%\mp3gain.exe
set FFMPEG_HOME_DEF=%FFMPEG_BIN%\ffmpeg-static

REM ---------------------------------------------------------------------------
REM Tools:
set DEFAULT_TOOL_VIDEO_MERGE_TMPDIR=C:\Temp
set DEFAULT_TOOL_VIDEO_MERGE_OUTDIR=C:\

REM ---------------------------------------------------------------------------
REM Codecs:
set DEFAULT_H264=-preset slow -bf 2 -flags +cgop -pix_fmt yuv420p
set DEFAULT_H264_CRF=23
set DEFAULT_H264_EXT=-c:a copy
set DEFAULT_MP3_BRATE=192k
set DEFAULT_MP3_SRATE=44100

REM ---------------------------------------------------------------------------
REM Meta:
REM Tags supported by ffmpeg/mp4: https://superuser.com/a/1208277/221381
REM To copy all metadata: -map_metadata 0
set "META_COPYRIGHT=%APP_LONGNAME% - %APP_URL% - Copyright %APP_YEAR% %APP_EMAIL%"
set META_GLOBAL=-map_metadata 0 -metadata copyright="%META_COPYRIGHT%"

REM ---------------------------------------------------------------------------
REM User config:
if exist "%ORKAN_FFMPEG_USER_CONFIG%" (
	call "%ORKAN_FFMPEG_USER_CONFIG%"
)

REM ---------------------------------------------------------------------------
REM Finalize:
set SRC_CONFIG_LOADED=yes
