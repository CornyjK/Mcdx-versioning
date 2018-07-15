@echo off
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
pause

:mathcver.help
echo Mathcad versioning tool %mathcver.version%
echo usage: mathcver <command>
exit

:error.install.7-zip
echo Can't install 7-zip!
echo Try restarting your machine or installing 7-zip manually.
exit

:error.verify.7-zip
echo Can't detect 7-zip after successful installation!
echo Try restarting your machine, installing 7-zip or adding 7-zip to path manually.
exit

pause