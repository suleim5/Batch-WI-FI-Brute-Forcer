@echo off
setlocal enabledelayedexpansion

rem Set environment variables
set "interface_number=0"
set "temp_interface_num_for_index=1"
set "interface_1="
set "interface_2="
set "interface_3="
set "interface_4="
set "interface_5="

rem Start the interface detection process
:interface_detection
echo Detecting Wi-Fi interfaces...
for /f "tokens=1-4*" %%a in ('netsh wlan show interfaces ^| findstr /L Name') do (
    echo Checking interface: %%c %%d
    if %%c==Wi-Fi (
        if not "%%d"=="" (
            set interface_index=%%d
            set interface_!temp_interface_num_for_index!=WI-FI !interface_index!
            set /a temp_interface_num_for_index+=1
            set /a interface_number+=1
        )
        else (
            set interface_1=WI-FI
            set /a temp_interface_num_for_index+=1
            set /a interface_number+=1
        )
    )
)

echo Detected Interfaces: !interface_number!
if !interface_number! lss 1 (
    echo No Wi-Fi interfaces found. Exiting...
    goto :end
)

rem Prompt the user to select an interface
echo.
echo Available Interfaces:
for /l %%i in (1,1,!interface_number!) do (
    echo Interface %%i: !interface_%%i!
)

rem Ask the user to select an interface
set /p "interface_choice=Please select an interface (1-%interface_number%): "
if not "!interface_choice!" geq "1" (
    echo Invalid choice. Exiting...
    goto :end
)
if !interface_choice! gtr !interface_number! (
    echo Invalid choice. Exiting...
    goto :end
)

set "selected_interface=!interface_!interface_choice!!"
echo You selected: !selected_interface!

rem Start the Wi-Fi scan process
:wifiscan
echo Scanning for available Wi-Fi networks...
netsh wlan show networks mode=bssid > wifilist.txt

rem Check if the scan was successful
if not exist wifilist.txt (
    echo Scan failed. Exiting...
    goto :end
)

rem Display available networks
echo Available networks:
type wifilist.txt
echo.

rem Ask user to select a Wi-Fi network to connect to
set /p "ssid_choice=Enter the SSID to connect to: "
if "!ssid_choice!"=="" (
    echo Invalid SSID. Exiting...
    goto :end
)

rem Disconnect from any existing Wi-Fi connection
netsh wlan disconnect interface="!selected_interface!" >nul
if errorlevel 1 (
    echo Error disconnecting from Wi-Fi interface. Exiting...
    goto :end
)

rem Connect to the chosen Wi-Fi network
netsh wlan connect name="!ssid_choice!" interface="!selected_interface!" >nul
if errorlevel 1 (
    echo Failed to connect to !ssid_choice!. Exiting...
    goto :end
)

echo Connected to !ssid_choice! successfully.

rem Proceed to attack phase or other actions
:attack
echo Preparing for attack...
rem Example attack command (you should replace this with the actual attack logic)
rem Example: running a script or a tool for the attack
rem attack_tool.exe --target !ssid_choice!

echo Attack phase (example) completed.

rem Cleanup and end
:end
echo Cleaning up...
if exist wifilist.txt del wifilist.txt
if exist attempt.xml del attempt.xml
echo Done.
pause
exit
