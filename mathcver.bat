@echo off
chcp 65001 >nul 2>nul
setlocal enableextensions enabledelayedexpansion
set mathcver.version=0.1.0

:check.7-zip
where 7z >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto install.7-zip
goto check.git

:check.git
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 echo Warning: Git not found!
goto mathcver.begin

:install.7-zip
IF 7-zip.installed 1 goto error.verify.7-zip
echo Installing 7-zip...
powershell wget -O %temp%\7z1805.exe https://www.7-zip.org/a/7z1805-x64.exe
%temp%\7z1805.exe /S /D="C:\Program Files\7-Zip"
IF ERRORLEVEL 1 goto error.install.7-zip
set 7-zip.installed 1

:mathcver.begin
if "%1"=="help" goto mathcver.help
if "%1"=="about" goto mathcver.about
if "%1"=="pack" goto mathcver.pack
if "%1"=="unpack" goto mathcver.unpack
pause

:mathcver.about
echo Mathcad versioning tool %mathcver.version%
echo created by Kryštof Černý @CornyjK
exit

:mathcver.help
echo Mathcad versioning tool %mathcver.version%
echo.
echo usage: mathcver ^<command^> ^<arguments^>
echo.
echo Available commands:
echo about - about this script
echo help - displays this help
echo unpack - unpacks mcdx sheet
echo pack - packs mcdx sheet
exit

:mathcver.unpack
7z x %2 




:error.install.7-zip
echo Can't install 7-zip!
echo Try restarting your machine or installing 7-zip manually.
exit

:error.verify.7-zip
echo Can't detect 7-zip after successful installation!
echo Try restarting your machine, installing 7-zip or adding 7-zip to path manually.
exit