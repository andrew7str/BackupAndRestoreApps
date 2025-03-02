@echo off
title Backup Restore Utility By : Mr.exe
color 0A

:setup
cls
echo ===========================================
echo          Backup  Restore Utility
echo ===========================================
echo Please specify the folder to store backups:
set /p backup_folder=Enter the backup folder path: 
if not exist "%backup_folder%" (
    mkdir "%backup_folder%"
    echo Folder created: %backup_folder%
) else (
    echo Using existing folder: %backup_folder%
)
pause

:main_menu
cls
echo ===========================================
echo          Backup  Restore Utility
echo ===========================================
echo Backup Folder: %backup_folder%
echo ===========================================
echo 1. Backup Brave Browser (Cookies, History, Passwords)
echo 2. Restore Brave Browser
echo 3. Backup WiFi Passwords
echo 4. Restore WiFi Passwords
echo 5. Backup Windows Settings
echo 6. Restore Windows Settings
echo 7. Backup IDM Settings
echo 8. Restore IDM Settings
echo 9. Backup Chrome Settings (Cookies, History, Passwords)
echo 10. Restore Chrome Settings
echo 11. Backup Firefox Settings (Cookies, History, Passwords)
echo 12. Restore Firefox Settings
echo 13. Exit
echo ===========================================
set /p choice=Choose an option [1-13]: 

if "%choice%"=="1" goto backup_brave
if "%choice%"=="2" goto restore_brave
if "%choice%"=="3" goto backup_wifi
if "%choice%"=="4" goto restore_wifi
if "%choice%"=="5" goto backup_settings
if "%choice%"=="6" goto restore_settings
if "%choice%"=="7" goto backup_idm
if "%choice%"=="8" goto restore_idm
if "%choice%"=="9" goto backup_chrome
if "%choice%"=="10" goto restore_chrome
if "%choice%"=="11" goto backup_firefox
if "%choice%"=="12" goto restore_firefox
if "%choice%"=="13" exit
goto main_menu

:backup_brave
cls
echo Checking if Brave is running...
tasklist | findstr /I "brave.exe" >nul && (
    echo Brave is running. Please close it before proceeding.
    pause
    goto main_menu
)

echo Backing up Brave Browser...
if exist "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default" (
    set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default"
) else (
    set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default"
)
set "brave_backup_folder=%backup_folder%\Brave"
if not exist "%brave_backup_folder%" mkdir "%brave_backup_folder%"

for %%f in ("Cookies" "History" "Login Data") do (
    if exist "%brave_profile%\%%f" (
        xcopy "%brave_profile%\%%f" "%brave_backup_folder%\" /C /Y >nul
        echo %%f backed up successfully!
    ) else (
        echo WARNING: File "%%f" not found. It may be missing or locked.
    )
)

echo Backup complete!
pause
goto main_menu

:restore_brave
cls
echo Restoring Brave Browser...
if exist "C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default" (
    set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default"
) else (
    set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default"
)

for %%f in ("Cookies" "History" "Login Data") do (
    if exist "%backup_folder%\Brave\%%f" (
        xcopy "%backup_folder%\Brave\%%f" "%brave_profile%\" /C /Y >nul
        echo %%f restored successfully!
    ) else (
        echo WARNING: File "%%f" not found in backup. Skipping...
    )
)

echo Restore complete!
pause
goto main_menu


:backup_chrome
cls
echo Backing up Google Chrome...
set "chrome_profile=C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default"
set "chrome_backup_folder=%backup_folder%\Chrome"
mkdir "%chrome_backup_folder%"

for %%f in ("Cookies" "History" "Login Data") do (
    if exist "%chrome_profile%\%%f" (
        xcopy "%chrome_profile%\%%f" "%chrome_backup_folder%" /Y
        echo %%f backed up successfully!
    ) else (
        echo File "%%f" not found. Skipping...
    )
)

echo Backup complete!
pause
goto main_menu

:restore_chrome
cls
echo Restoring Google Chrome...
for %%f in ("Cookies" "History" "Login Data") do (
    if exist "%backup_folder%\Chrome\%%f" (
        xcopy "%backup_folder%\Chrome\%%f" "%chrome_profile%" /Y
        echo %%f restored successfully!
    ) else (
        echo File "%%f" not found in backup. Skipping...
    )
)

echo Restore complete!
pause
goto main_menu

:backup_firefox
cls
echo Backing up Mozilla Firefox...
set "firefox_profile=C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles"
set "firefox_backup_folder=%backup_folder%\Firefox"
mkdir "%firefox_backup_folder%"

for %%f in ("cookies.sqlite" "places.sqlite" "logins.json" "key4.db") do (
    if exist "%firefox_profile%\%%f" (
        xcopy "%firefox_profile%\%%f" "%firefox_backup_folder%" /Y
        echo %%f backed up successfully!
    ) else (
        echo File "%%f" not found. Skipping...
    )
)

echo Backup complete!
pause
goto main_menu

:restore_firefox
cls
echo Restoring Mozilla Firefox...
for %%f in ("cookies.sqlite" "places.sqlite" "logins.json" "key4.db") do (
    if exist "%backup_folder%\Firefox\%%f" (
        xcopy "%backup_folder%\Firefox\%%f" "%firefox_profile%" /Y
        echo %%f restored successfully!
    ) else (
        echo File "%%f" not found in backup. Skipping...
    )
)

echo Restore complete!
pause
goto main_menu
