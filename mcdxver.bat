@echo off
chcp 65001 >nul 2>nul
setlocal enableextensions enabledelayedexpansion
set mcdxver-version=0.1.0

:7-zip-check
where 7z >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto 7-zip-install
goto git-check

:git-check
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 echo Warning: Git not found!
goto mcdxver-begin

:7-zip-install
IF 7-zip-installed 1 goto error-7-zip-verify
echo Installing 7-zip-..
powershell wget -O %temp%\7z1805.exe https://www.7-zip-org/a/7z1805-x64.exe
%temp%\7z1805.exe /S /D="C:\Program Files\7-Zip"
IF ERRORLEVEL 1 goto error-7-zip-install
set 7-zip-installed 1
goto 7-zip-check

:mcdxver-begin
if "%1"=="help" goto mcdxver-help
if "%1"=="about" goto mcdxver-about
if "%1"=="pack" goto mcdxver-pack
if "%1"=="unpack" goto mcdxver-unpack
if "%1"=="" goto mcdxver-help
echo Unknown mcdxver command!
echo See 'mcdxver help' to see available commands.
exit 1

:mcdxver-about
echo Mathcad versioning tool %mcdxver-version%
echo created by Kryštof Černý @CornyjK
exit

:mcdxver-help
rem cover help of some commands...
if not "%2"=="" goto error-mcdxver-help-na
echo Mathcad versioning tool %mcdxver-version%
echo.
echo usage: mcdxver ^<command^> ^<arguments^>
echo.
echo Available commands:
echo about - about this script
echo help - displays this help or help about command
echo unpack - unpacks mcdx sheet
echo pack - packs mcdx sheet
exit

:mcdxver-unpack
set mcdxver-unpack-source=%2

If Not Exist "%cd%\%mcdxver-unpack-source%" goto error-mcdxver-unpack-nonexistant

ren "%mcdxver-unpack-source%" "%mcdxver-unpack-source%" >nul 2>nul
IF ERRORLEVEL 1 goto error-mcdxver-unpack-used

SET mcdxver-unpack-target-tmp=%mcdxver-unpack-source:~0,-5%
SET mcdxver-unpack-target=%mcdxver-unpack-target-tmp%.mcdxver

7z x %mcdxver-unpack-source% -o%mcdxver-unpack-target% -y -aoa

IF ERRORLEVEL 0 (
    echo Mcdx unpacked, now doing the files!
    set mcdxver-unpack-pages-loop-active=1
    set mcdxver-unpack-pages-page=0
    goto mcdxver-unpack-pages-loop
)
echo An error occured!
exit 1

:mcdxver-unpack-pages-loop
if "%mcdxver-unpack-pages-loop-active"=="1" (
    If Exist "%cd%\%mcdxver-unpack-target%\mathcad\xaml\FlowDocument%mcdxver-unpack-pages-page%.XamlPackage" goto error-mcdxver-unpack-nonexistant
    7z x %cd%\%mcdxver-unpack-target%\mathcad\xaml\FlowDocument%mcdxver-unpack-pages-page%.XamlPackage -o%cd%\%mcdxver-unpack-target%\mathcad\xaml\FlowDocument%mcdxver-unpack-pages-page% -y -aoa
    goto mcdxver-unpack-pages-loop
)
rem place verifying code here!
exit

:error-7-zip-install
echo Can't install 7-zip!
echo Try restarting your machine or installing 7-zip manually.
exit 1

:error-7-zip-verify
echo Can't detect 7-zip after successful installation!
echo Try restarting your machine, installing 7-zip or adding 7-zip to path manually.
exit 1

:error-mcdxver-unpack-used
echo Something already uses desired file!
echo Close all apps that use your sheet.
exit 1

:error-mcdxver-unpack-nonexistant
echo Desired file does not exist!
echo Check your arguments.
exit 1

:error-mcdxver-help-na
echo Help about this command does not exist!
echo There is probably nothing more to ask...
exit 1

:strlen <resultVar> <stringVar>
rem stolen from: https://stackoverflow.com/questions/5837418/how-do-you-get-the-string-length-in-a-batch-file
(   
    setlocal EnableDelayedExpansion
    set "s=!%~2!#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" ( 
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)