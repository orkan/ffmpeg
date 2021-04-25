@echo off
set EXTRA=%1

if "%EXTRA%" NEQ "reload" if "%CONFIG_LOADED%" == "yes" exit /b

REM system: --------------------------------------------
set ERRORLEVEL=0

REM ffmpeg: --------------------------------------------
set FFMPEG_HOME_DEF=%~dp0..\..\bin\ffmpeg-static

REM Codecs: --------------------------------------------
set DEFAULT_H264=-preset slow -bf 2 -flags +cgop -pix_fmt yuv420p
set DEFAULT_H264_CRF=23
set DEFAULT_H264_EXT=-c:a copy

set DEFAULT_MP3_BRATE=192k
set DEFAULT_MP3_SRATE=44100

REM Meta: ----------------------------------------------
REM Tags supported by ffmpeg/mp4: https://superuser.com/a/1208277/221381
REM To copy all metadata: -map_metadata 0
REM Define your META_USER_??? in usrer config.bat since some tools can modify particular metadata, then your META will be appended
set "META_USER_COPYRIGHT=Orkan <orkans@gmail.com>"
set "META_USER_COMMENT=https://github.com/orkan/ffmpeg-rel"
set "META_USER_DESCRIPTION=ffmpeg (W)indows (C)ontext (T)ools"
set META_GLOBAL=-map_metadata 0 -metadata copyright="%META_USER_COPYRIGHT%" -metadata comment="%META_USER_COMMENT%" -metadata description="%META_USER_DESCRIPTION%" 

REM Tools: ---------------------------------------------
REM Put these in your usr\config.bat
REM set TOOL_VIDEO_MERGE_TMPDIR=
REM set TOOL_VIDEO_MERGE_OUTDIR=

REM User config: ---------------------------------------
set USER_CONFIG="%~dp0..\usr\config.bat"
if exist %USER_CONFIG% (
	call %USER_CONFIG%
)

REM Finalize: ------------------------------------------
set CONFIG_LOADED=yes

if "%FFMPEG_DEBUG%" NEQ "" (
	echo [%~nx0: loaded]
)
