@echo off
setlocal

REM Show all
REM ffprobe -show_format video-xyz.mov
REM [FORMAT]
REM filename=video-xyz.mov
REM nb_streams=2
REM nb_programs=0
REM format_name=mov,mp4,m4a,3gp,3g2,mj2
REM format_long_name=QuickTime / MOV
REM start_time=0.000000
REM duration=11.808333
REM size=5366527
REM bit_rate=3635755
REM probe_score=100
REM TAG:major_brand=qt
REM TAG:minor_version=0
REM TAG:compatible_brands=qt
REM TAG:creation_time=2010-06-26T14:43:09.000000Z
REM TAG:model=iPhone 3GS
REM TAG:model-pol=iPhone 3GS
REM TAG:date=2010-06-26T16:43:08+0200
REM TAG:date-pol=2010-06-26T16:43:08+0200
REM TAG:encoder=3.1.3
REM TAG:encoder-pol=3.1.3
REM TAG:location=+52.3016+015.2408/
REM TAG:location-pol=+52.3016+015.2408/
REM TAG:make=Apple
REM TAG:make-pol=Apple
REM [/FORMAT]

REM Command: --------------------------------------------------
REM Display only location string from metadata
set COMMAND=ffprobe -v quiet -print_format compact=print_section=0:nokey=1:escape=csv -show_entries format_tags=location "%~1"

pushd %~dp0
call %COMMAND%
popd
