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
echo 1. Backup Brave Browser (Histori Bookmark)
echo 2. Restore Brave Browser (Histori Bookmark)
echo 3. Backup WiFi Passwords
echo 4. Restore WiFi Passwords
echo 5. Backup Windows Settings
echo 6. Restore Windows Settings
echo 7. Exit
echo ===========================================
set /p choice=Choose an option [1-7]: 

if "%choice%"=="1" goto backup_brave
if "%choice%"=="2" goto restore_brave
if "%choice%"=="3" goto backup_wifi
if "%choice%"=="4" goto restore_wifi
if "%choice%"=="5" goto backup_settings
if "%choice%"=="6" goto restore_settings
if "%choice%"=="7" exit
goto main_menu

:backup_brave
cls
echo Backing up Brave Browser...
set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default"
set "brave_backup_folder=%backup_folder%\Brave"
mkdir "%brave_backup_folder%"

for %%f in (History Bookmarks Cookies "Login Data" "Web Data" Preferences "Secure Preferences") do (
    if exist "%brave_profile%\%%f" (
        xcopy "%brave_profile%\%%f" "%brave_backup_folder%" /Y
        echo %%f backed up successfully!
    ) else (
        echo File "%%f" not found. Skipping...
    )
)

if exist "%brave_profile%\Extensions" (
    xcopy "%brave_profile%\Extensions" "%brave_backup_folder%\Extensions" /E /Y
    echo Extensions backed up successfully!
) else (
    echo Folder "Extensions" not found. Skipping...
)

echo Backup complete! Files saved to %brave_backup_folder%.
pause
goto main_menu


:restore_brave
cls
echo Restoring Brave Browser...
set "brave_profile=C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser-Nightly\User Data\Default"
set "brave_backup_folder=%backup_folder%\Brave"

for %%f in (History Bookmarks Cookies "Login Data" "Web Data" Preferences "Secure Preferences") do (
    if exist "%brave_backup_folder%\%%f" (
        xcopy "%brave_backup_folder%\%%f" "%brave_profile%" /Y
        echo %%f restored successfully!
    ) else (
        echo File "%%f" not found in backup. Skipping...
    )
)

if exist "%brave_backup_folder%\Extensions" (
    xcopy "%brave_backup_folder%\Extensions" "%brave_profile%\Extensions" /E /Y
    echo Extensions restored successfully!
) else (
    echo Folder "Extensions" not found in backup. Skipping...
)

echo Restore complete!
pause
goto main_menu



:backup_wifi
cls
echo Backing up WiFi passwords...
mkdir "%backup_folder%\WiFi"
netsh wlan export profile key=clear folder="%backup_folder%\WiFi"
echo Backup complete! Files saved to %backup_folder%\WiFi.
pause
goto main_menu

:restore_wifi
cls
echo Restoring WiFi passwords...
for %%i in ("%backup_folder%\WiFi\*.xml") do (
    netsh wlan add profile filename="%%i"
)
echo Restore complete!
pause
goto main_menu

:backup_settings
cls
echo Backing up Windows Settings...
set "settings_backup_folder=%backup_folder%\Settings"
mkdir "%settings_backup_folder%"
reg export HKCU "%settings_backup_folder%\HKCU_Settings.reg"
echo Backup complete! Registry saved to %settings_backup_folder%.
pause
goto main_menu

:restore_settings
cls
echo Restoring Windows Settings...
set "settings_backup_folder=%backup_folder%\Settings"
reg import "%settings_backup_folder%\HKCU_Settings.reg"
echo Restore complete!
pause
goto main_menu
