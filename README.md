![ffmpeg-logo](https://user-images.githubusercontent.com/129182/109426413-f506b680-79ed-11eb-9792-c09119ed708a.jpg)

# ork-ffmpeg `v2.2.0`
Convert your media files quickly with FFmpeg library.

---

The main idea is to limit the command line switches passed to FFmpeg.exe while keeping full control of the conversion process.
Use Windows context menu (Send To) or drag&drop features to quickly convert your media.
Use convert.bat tool to batch proccess multiple media files from different locations at once.

## Installation

### Environment variables:
Change default config values by setting `ORKAN_FFMPEG_USER_CONFIG` environment variable pointing to user config file:
`set ORKAN_FFMPEG_USER_CONFIG=path\to\usr\config.bat`

Change ffmpeg binaries path:
`set FFMPEG_HOME=path\to\ffmpeg-static`

Change log file:
`set LOG_FILE=path\to\file.log`

### Autoloader:
The `autoload.bat` loads user config and also is used as the main entry point to load any tool located on `%APP_TOOLS_PATH%`.
This environment variable can be extended by user config. It has the same format as Windows %PATH% variable (ie. dir paths separated by semicolon)
Usage: `autoload.bat <tool_*.bat> [arg1 ... arg8]`
More info can be found in autoload.bat header section.

### Send To:
1. Create shortcut in `%USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo`
    - to load any tool with autoloader use: `autoload.bat tool_mp4.bat ...args`
    - to load specific tool use absolute path: `D:\...\src\tool_mp4.bat ...args`
2. Right click on your media file, choose: Send To > Convert to mp4

## Batch processing:
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
Mon, 13 Feb 2023 17:12:07 +01:00

### License
MIT
