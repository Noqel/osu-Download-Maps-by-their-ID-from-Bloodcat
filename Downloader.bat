@echo off
set idkvar=1
set loop=1
for /F "delims=" %%i in (BeatmapIDs.txt) do set "lastline=%%i"
set line=1
mkdir mapdownloads
:start
 set "xprvar="
for /F "skip=%line% delims=" %%i in (BeatmapIDs.txt) do if not defined xprvar set "xprvar=%%i"
if "%xprvar%"=="Beatmap IDs:" goto point
:download
cd mapdownloads
cls
echo Downloading Song %line%
powershell -Command "Invoke-WebRequest -OutFile: "map%line%.osz" -Uri "https://api.chimu.moe/v1/download/%xprvar%?n=1""
FOR %%R in (map%line%.osz) DO IF %%~zR NEQ 0 goto further
set /a loop=%loop%+1
if %loop% EQU 3 goto further
goto download
:further
set loop=1
cd..
if "%xprvar%"=="%lastline%" goto end
:point 
set /a line=1+%line%
goto start
:end
cd mapdownloads
cls
if NOT EXIST map%line%.osz set /a line=%line%-1
if %line% equ 0 goto realend
if NOT EXIST map%line%.osz goto end
start map%line%.osz
cls
if %idkvar% EQU 1 timeout /t 7
timeout /t 3
if %line% EQU 1 goto realend
set /a line=%line%-1
set idkvar=2
goto end
:realend
cd..
rmdir mapdownloads
cls
echo Finished
