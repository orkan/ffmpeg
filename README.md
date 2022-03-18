![ffmpeg-logo](https://user-images.githubusercontent.com/129182/109426413-f506b680-79ed-11eb-9792-c09119ed708a.jpg)

# ffmpeg (W)indows (C)ontext (T)ools `v1.2.1`
Convert your media files quickly with: Right click > "Send to" menu.

---

The main idea behind this project is to limit the command line switches that need to be passed to ffmpeg.exe while keeping full control of the convertion process.

## Installation

### General:
Set environment variable `FFMPEG_HOME` pointing to ffmpeg installation dir or set it locally by creating autoloaded `usr\config.bat` file with:
```batch
@echo off
set FFMPEG_HOME=path\to\ffmpeg-dir
```

### Send To:
1. Create shortcuts to any of `src\tool_***.bat` in `%USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo`
1. Rename shortcuts as needed, eg. "*Shortcut to tool_video_cut_time.bat*" > "_Clip movie_"
1. Right click on your media file, choose: Send To > Clip movie

### Batch processing:
To convert many media files at once, run: `src\convert.bat "usr\myfiles.bat"`

Create `usr\myfiles.bat` as follows: 
```batch
@echo off

REM Convert all *.ts to *.mp4 in X:\media\videos
echo ffmpeg_mp4.bat "X:\media\videos\*.ts" 28 24.97

REM Convert all *.avi to *.mp3 in D:\clips
echo ffmpeg_mp3.bat "D:\clips\*.avi"
```
Tips:
* All paths must contain wildcards. Use * or ? as needed.
* For more examples check out `usr\files_tests.bat`

## Configuration
The ffmpeg configuration is stored in `src\_config.bat` You can create your own by copying this file to `usr\config.bat` Your changes will be automatically loaded and will overwrite any corresponding default configuration.

## About
### Requirements
* [ffmpeg.exe](https://ffmpeg.org/)

### Author
[Orkan](https://github.com/orkan)

### Updated
Fri, 18 Mar 2022 19:14:16 +01:00

### License
GNU General Public License v3.0
