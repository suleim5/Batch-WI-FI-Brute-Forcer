@echo off
set allowed_char_list="ABCDEFGHIJKLMNOPRSTUVYZWXQabcdefghijklmnoprstuvyzwxq0123456789-_"
cd BF_Files
title The WI-FI Brute Forcer - Developed By TUX
set /a attempt=1
del attempt.xml
del infogate.xml
cls
set targetwifi=No WI-FI Selected
set interface_description=Not Selected
set interface_id=Not Selected
set interface_mac=Not Selected
set interface_state=notdefined
setlocal enabledelayedexpansion
mode con: cols=80 lines=35
color 0f

call :interface_detection

if !interface_number!==1 (
    echo.
    call colorchar.exe /0b " Interface Detection"
    echo.
    call colorchar.exe /0e " Only '1' Interface Found!"
    echo.
    call colorchar.exe /0f " !interface_1_description!("
    call colorchar.exe /09 "!interface_1_mac!"
    call colorchar.exe /0f ")"
    echo.
    echo Making !interface_1_description! as default Interface...
    set interface_id=!interface_1!
    set interface_description=!interface_1_description!
    set interface_mac=!interface_1_mac!
    timeout /t 3 >nul
)

if !interface_number! gtr 1 (
    echo.
    call colorchar.exe /0b " Interface Detection"
    echo.
    call colorchar.exe /0e " Multiple '!interface_number!' Interfaces Found!"
    timeout /t 3 >nul
    call :interface_selection
)

if !interface_number!==0 (
    echo.
    call colorchar.exe /0b " Interface Detection"
    echo.
    call colorchar.exe /0e " WARNING"
    echo No interfaces found on this device!!
    echo Press any key to continue...
    timeout /t 5 >nul
    cls
)

goto :main

:main
set mainmenuchoice=
cls
echo.
echo  [---------------------------------------------------------------------------]
echo.                              ______________
echo                           ___/              \_
echo                 \_       /       _  __________\       _/
echo                   \     /         \/           \     /
echo                        /     \     \            \
echo              \_       /  \    \     \______      \       _/
echo                \      \   \    \     \___//      /      /
echo                        \__/\__/ \___/  __/      /
echo                         \             /        /
echo                \_        \                    /        _/
echo                  \        \                  /        /
echo                            \________________/
echo.
echo  [---------------------------------------------------------------------------]
call colorchar.exe /0b "                      Brute Force Manager Version 1.1.2 "
echo.
call colorchar.exe /0e "                              Developed By TUX"
echo.
echo  [---------------------------------------------------------------------------]
echo.

call colorchar.exe /0b "   Target - " 
echo !targetwifi!
call colorchar.exe /0b "   Interface - "
echo !interface_description!
echo.
echo    Type "help" for more info

call colorbox.exe /0F 1 19 76 25
echo.
echo.
call :userinput
set /p mainmenuchoice=

if !mainmenuchoice!==exit (
    exit
)

if !mainmenuchoice!==help (
    cls
    echo.
    call colorchar.exe /0b " Help Page"
    echo.
    echo.
    echo  - help             : Prints this page
    echo  - wifiscan         : Performs a WI-FI scan
    echo  - interface        : Select an interface for attack
    echo  - attack           : Attacks on selected WI-FI
    echo.
    echo  For more informaton, please read "readme.txt".
    echo.
    echo.
    echo  Other projects of TUX:
    echo  "https://www.bytechonline.wordpress.com"
    echo.
    echo  This project's UI has been made possible with TheBATeam group plugins.
    echo  "https://www.thebateam.org/"
    echo.
    echo  Press any key to continue...
    pause >nul
    cls
    goto :main
)

if !mainmenuchoice!==interface (
    cls
    call :interface_detection
    call :interface_selection
    cls
    goto :main
)

if !mainmenuchoice!==wifiscan (
    del infogate.xml
    call :wifiscan
    call :exporter !target

