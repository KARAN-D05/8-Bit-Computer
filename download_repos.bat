@echo off
setlocal enabledelayedexpansion
title KARAN-D05 - Repo Downloader

:: ─────────────────────────────────────────
::  Repo list
:: ─────────────────────────────────────────
set "REPO[1]=Computing_Machinery_from_Scrath"
set "REPO[2]=Assembler"
set "REPO[3]=Gate-Level-Perceptron"
set "REPO[4]=8-Bit-Computer"
set "REPO[5]=Artificial-Neuron"
set "BASE_URL=https://github.com/KARAN-D05"
set "BRANCH=main"

:MENU
cls
echo ============================================
echo   KARAN-D05  ^|  Repository Downloader
echo ============================================
echo.
echo   [1]  Computing_Machinery_from_Scrath
echo   [2]  Assembler
echo   [3]  Gate-Level-Perceptron
echo   [4]  8-Bit-Computer
echo   [5]  Artificial-Neuron
echo   [A]  Download ALL repos
echo   [Q]  Quit
echo.
echo  Enter one number, several (e.g. 1 3 5),
echo  A for all, or Q to quit.
echo ============================================
echo.
set /p "CHOICE=  Your choice: "

:: Quit
if /i "%CHOICE%"=="Q" (
    echo.
    echo  Goodbye!
    timeout /t 2 >nul
    exit /b 0
)

:: All
if /i "%CHOICE%"=="A" (
    set "CHOICE=1 2 3 4 5"
)

:: ─────────────────────────────────────────
::  Download selected repos
:: ─────────────────────────────────────────
set "DOWNLOADED=0"
set "FAILED=0"

for %%T in (%CHOICE%) do (
    :: Validate token is 1-5
    set "VALID=0"
    for /L %%I in (1,1,5) do (
        if "%%T"=="%%I" set "VALID=1"
    )
    if "!VALID!"=="0" (
        echo.
        echo  [!] "%%T" is not a valid option — skipping.
    ) else (
        set "RNAME=!REPO[%%T]!"
        set "ZIP_URL=!BASE_URL!/!RNAME!/archive/refs/heads/!BRANCH!.zip"
        set "OUT_FILE=!RNAME!.zip"

        echo.
        echo  [>>] Downloading !RNAME! ...
        curl -L -o "!OUT_FILE!" "!ZIP_URL!" --progress-bar

        if !ERRORLEVEL! EQU 0 (
            echo  [OK] Saved as !OUT_FILE!
            set /a DOWNLOADED+=1

            :: Auto-unzip if possible
            echo  [>>] Extracting ...
            powershell -NoProfile -Command ^
                "Expand-Archive -Path '!OUT_FILE!' -DestinationPath '!RNAME!' -Force" ^
                2>nul
            if !ERRORLEVEL! EQU 0 (
                del "!OUT_FILE!" >nul 2>&1
                echo  [OK] Extracted to folder: !RNAME!
            ) else (
                echo  [!!] Could not auto-extract. ZIP file kept: !OUT_FILE!
            )
        ) else (
            echo  [ERR] Failed to download !RNAME!. Check your internet connection.
            set /a FAILED+=1
        )
    )
)

echo.
echo ============================================
echo   Done!  Downloaded: %DOWNLOADED%   Failed: %FAILED%
echo ============================================
echo.
pause
goto MENU
