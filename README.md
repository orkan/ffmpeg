![ffmpeg-logo](https://user-images.githubusercontent.com/129182/109426413-f506b680-79ed-11eb-9792-c09119ed708a.jpg)

# ork-ffmpeg `v2.4.1`
Convert your media files quickly with FFmpeg library.

---

The main idea is to limit the command line switches passed to `ffmpeg.exe` while keeping full control of the conversion process.
Use Windows "Send To" menu or "Drag & Drop" features to quickly convert your media.
Use `convert.bat` tool to batch proccess multiple media files from different locations at once.

## Installation

### Environment variables:
Customize default config values by declaring user config file environment variable `ORKAN_FFMPEG_USER_CONFIG`
Example: `ORKAN_FFMPEG_USER_CONFIG=path\to\usr\config.bat`

From this file you can:
- customize ffmpeg binaries location: `set FFMPEG_HOME=path\to\ffmpeg-static`
- change log file location: `set LOG_FILE=path\to\file.log`
- extend Autoloader locations: `set APP_TOOLS_PATH=path\to\user\tools` (same format as Windows %PATH%)
- this way you can basically change every option from default `src\_config.bat` 

### Autoloader:
The `autoload.bat` is the main entry point for any tool located on `%APP_TOOLS_PATH%`.
Usage: `autoload.bat <tool_*.bat> [arg1 ... arg8]`
Check autoload.bat header section for more info.

### Send To:
1. Create shortcut in `%USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo`
    - to load any tool with autoloader use: `autoload.bat tool_mp4.bat ...args`
    - to load specific tool use absolute path: `D:\...\src\tool_mp4.bat ...args`
2. Right click on your media file, choose: Send To > Convert to mp4

## Batch processing:
Proccess multiple files from different locations at once with `convert.bat` tool.
Command: `autoload.bat convert.bat files.bat`

In `files.bat`: 
```batch
@echo off

REM Convert all *.ts to *.mp4 in X:\media\videos
echo ffmpeg_mp4.bat "X:\media\videos\*.ts" 28 24.97

REM Convert all *.avi to *.mp3 in D:\clips
echo ffmpeg_mp3.bat "D:\clips\*.avi"
```

## About
### Requirements
* [ffmpeg.exe](https://ffmpeg.org/)

### Author
[Orkan](https://github.com/orkan)

### Updated
Sun, 16 Jul 2023 10:36:40 +02:00

### License
MIT
