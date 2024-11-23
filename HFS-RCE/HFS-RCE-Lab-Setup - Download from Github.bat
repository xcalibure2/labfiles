@echo off
:: Define variables
set "PING_TARGET=8.8.8.8"

:: Step 1: Check internet connectivity
echo [*] Checking internet connectivity...
ping -n 1 %PING_TARGET% >nul 2>&1
if %errorlevel% neq 0 (
	
    echo [-] No internet connection. Exiting.
    exit /b 1
)

echo [+] Internet connection is OK.


:: Step 2: Download multiple files
call :DownloadFile "https://github.com/xcalibure2/labfiles/raw/refs/heads/main/HFS-RCE/hfs23.exe" "C:\Tools\hfs23.exe"
call :DownloadFile "https://github.com/xcalibure2/labfiles/raw/refs/heads/main/HFS-RCE/nssm.exe" "C:\Tools\nssm.exe"


:: Step 3: Execute subsequent commands
echo [*] Running subsequent commands...

:: Command 1 : create HFS service using nssm
echo [*] Creating HFS Service...
C:\Tools\nssm.exe install HFS "C:\Tools\hfs23.exe"
if %errorlevel% neq 0 (
	
    echo [-] Service creation failed. Exiting.
    exit /b 1
)

echo [+] HFS Service created successfully.


:: Command 2 : Start HFS Service
echo [*] Starting HFS Service...
C:\Tools\nssm.exe start HFS
if %errorlevel% neq 0 (
	
    echo [-] Service HFS failed to start. Exiting.
    exit /b 1
)

echo [+] HFS Service started successfully.


:: Check service status
echo [*] Checking service status... Please wait 5 seconds, don't kill the execution.

:: Service name
set "SERVICE_NAME=HFS"
set "SERVICE_STATUS="

:: Query the service status
for /f "tokens=3" %%A in ('sc query "%SERVICE_NAME%" ^| find "STATE"') do set "SERVICE_STATUS=%%A"

:: Trim leading/trailing spaces
set "SERVICE_STATUS=%SERVICE_STATUS:~0,15%"

:: Debug: Display captured status
:: echo Service status: "%SERVICE_STATUS%"

:: Verify if the service is running
if /i "%SERVICE_STATUS%"=="4" (
	
    echo [+] The service "%SERVICE_NAME%" is running.
	
) else (
	
    echo The service "%SERVICE_NAME%" is not running or returned a different status: %SERVICE_STATUS%.
    exit /b 1
)

:: Finish

echo [+] All steps completed successfully.
exit /b 0

:: Function: DownloadFile
:: Arguments:
::   %1 - URL of the file to download
::   %2 - Destination file path
:DownloadFile
echo [*] Downloading file from %1 to %2...
powershell -Command "Invoke-WebRequest -Uri '%~1' -OutFile '%~2'"
if %errorlevel% neq 0 (
	
    echo [-] Failed to download file: %1. Exiting.
    exit /b 1
)

echo File downloaded successfully: %2

goto :EOF
