@echo off
chcp 65001 >nul 2>nul
setlocal enableextensions enabledelayedexpansion
set mathcver.version=0.1.0

:7-zip.check
where 7z >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto 7-zip.install
goto git.check

:git.check
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 echo Warning: Git not found!
goto mathcver.begin

:7-zip.install
IF 7-zip.installed 1 goto error.7-zip.verify
echo Installing 7-zip...
powershell wget -O %temp%\7z1805.exe https://www.7-zip.org/a/7z1805-x64.exe
%temp%\7z1805.exe /S /D="C:\Program Files\7-Zip"
IF ERRORLEVEL 1 goto error.7-zip.install
set 7-zip.installed 1
goto 7-zip.check

:mathcver.begin
if "%1"=="help" goto mathcver.help
if "%1"=="about" goto mathcver.about
if "%1"=="pack" goto mathcver.pack
if "%1"=="unpack" goto mathcver.unpack
if "%1"=="" goto mathcver.help
echo Unknown mathcver command!
echo See 'mathcver help' to see available commands.
exit 1

:mathcver.about
echo Mathcad versioning tool %mathcver.version%
echo created by Kryštof Černý @CornyjK
exit

:mathcver.help
rem cover help of some commands...
if not "%2"=="" goto error.mathcver.help.na
echo Mathcad versioning tool %mathcver.version%
echo.
echo usage: mathcver ^<command^> ^<arguments^>
echo.
echo Available commands:
echo about - about this script
echo help - displays this help or help about command
echo unpack - unpacks mcdx sheet
echo pack - packs mcdx sheet
exit

:mathcver.unpack
If Not Exist "%cd%\%2" goto error.mathcver.unpack.nonexistant

ren "%2" "%2" >nul 2>nul
IF ERRORLEVEL 1 goto error.mathcver.unpack.used

7z x %2 -o%2 -y -aoa
IF ERRORLEVEL 0 goto mathcver.unpack.success
echo An error occured!
exit 1

:mathcver.unpack.success
echo Unpack successful!
rem place verifying code here!
exit

:error.7-zip.install
echo Can't install 7-zip!
echo Try restarting your machine or installing 7-zip manually.
exit 1

:error.7-zip.verify
echo Can't detect 7-zip after successful installation!
echo Try restarting your machine, installing 7-zip or adding 7-zip to path manually.
exit 1

:error.mathcver.unpack.used
echo Something already uses desired file!
echo Close all apps that use your sheet.
exit 1

:error.mathcver.unpack.nonexistant
echo Desired file does not exist!
echo Check your arguments.
exit 1

:error.mathcver.help.na
echo Help about this command does not exist!
echo There is probably nothing more to ask...
exit 1