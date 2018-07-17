@echo off
chcp 65001 >nul 2>nul
setlocal enableextensions enabledelayedexpansion
set mcdxver_version=0.1.0

:7-zip_check
where 7z >nul 2>nul
IF %ERRORLEVEL% NEQ 0 goto 7-zip_install
goto git_check

:git_check
where git >nul 2>nul
IF %ERRORLEVEL% NEQ 0 echo Warning: Git not found!
goto mcdxver_begin

:7-zip_install
IF 7-zip_installed 1 goto error_7-zip_verify
echo Installing 7-zip_..
powershell wget -O %temp%\7z1805.exe https://www.7-zip_org/a/7z1805-x64.exe
%temp%\7z1805.exe /S /D="C:\Program Files\7-Zip"
IF ERRORLEVEL 1 goto error_7-zip_install
set 7-zip_installed 1
goto 7-zip_check

:mcdxver_begin
if "%1"=="help" goto mcdxver_help
if "%1"=="about" goto mcdxver_about
if "%1"=="pack" goto mcdxver_pack
if "%1"=="unpack" goto mcdxver_unpack
if "%1"=="" goto mcdxver_help
echo Unknown mcdxver command!
echo See 'mcdxver help' to see available commands.
exit 1

:mcdxver_about
echo Mathcad versioning tool %mcdxver_version%
echo created by Kryštof Černý @CornyjK
exit

:mcdxver_help
rem cover help of some commands...
if not "%2"=="" goto error_mcdxver_help_na
echo Mathcad versioning tool %mcdxver_version%
echo.
echo usage: mcdxver ^<command^> ^<arguments^>
echo.
echo Available commands:
echo about - about this script
echo help - displays this help or help about command
echo unpack - unpacks mcdx sheet
echo pack - packs mcdx sheet
exit

:mcdxver_unpack
set mcdxver_unpack_source=%2

If Not Exist "%cd%\%mcdxver_unpack_source%" goto error_mcdxver_unpack_nonexistant

ren "%mcdxver_unpack_source%" "%mcdxver_unpack_source%" >nul 2>nul
IF ERRORLEVEL 1 goto error_mcdxver_unpack_used

SET mcdxver_unpack_target-tmp=%mcdxver_unpack_source:~0,-5%
SET mcdxver_unpack_target=%mcdxver_unpack_target-tmp%.mcdxver

7z x %mcdxver_unpack_source% -o%mcdxver_unpack_target% -y -aoa >nul 2>nul

IF not ERRORLEVEL 0 goto error_undefined
echo Mcdx unpacked, now unpacking pages!
set mcdxver_unpack_pages_page=0
goto mcdxver_unpack_pages_loop

:mcdxver_unpack_pages_loop
If Exist "%cd%\%mcdxver_unpack_target%\mathcad\xaml\FlowDocument%mcdxver_unpack_pages_page%.XamlPackage" (
    7z x %cd%\%mcdxver_unpack_target%\mathcad\xaml\FlowDocument%mcdxver_unpack_pages_page%.XamlPackage -o%cd%\%mcdxver_unpack_target%\mathcad\xaml\FlowDocument%mcdxver_unpack_pages_page% -y -aoa  >nul 2>nul
    set /a "mcdxver_unpack_pages_page+=1"
    goto mcdxver_unpack_pages_loop
)
set /a mcdxver_unpack_pages_pages=mcdxver_unpack_pages_page + 1
echo Done, %mcdxver_unpack_pages_pages% pages total.
rem place verifying code here!
exit

:error_7-zip_install
echo Can't install 7-zip!
echo Try restarting your machine or installing 7-zip manually.
exit 1

:error_7-zip_verify
echo Can't detect 7-zip after successful installation!
echo Try restarting your machine, installing 7-zip or adding 7-zip to path manually.
exit 1

:error_mcdxver_unpack_used
echo Something already uses desired file!
echo Close all apps that use your sheet.
exit 1

:error_mcdxver_unpack_nonexistant
echo Desired file does not exist!
echo Check your arguments.
exit 1

:error_mcdxver_help_na
echo Help about this command does not exist!
echo There is probably nothing more to ask...
exit 1

:error_undefined
echo Unknown error occured!
echo You may contact author for help.
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