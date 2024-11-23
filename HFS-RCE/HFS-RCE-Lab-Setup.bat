::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHY/JxdHcAyELznpSLAE7Yg=
::fBE1pAF6MU+EWHreyHY/JxdHcAqRL2b0A60ZiA==
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdFe5
::ZR41oxFsdFKZSTk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJG2L+04jFA9RXxDPKjn0A60ZiA==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off

:: Step 1: move extracted binaries to C:\Tools folder

call :MoveFile "%USERPROFILE%\Downloads\hfs23.exe" "c:\Tools\hfs23.exe"
call :MoveFile "%USERPROFILE%\Downloads\nssm.exe" "c:\Tools\nssm.exe"


:: Step 2: Create and start HFS Service
:: Command 1 : create HFS service using nssm
echo [*] Creating HFS Service...
C:\Tools\nssm.exe install HFS "C:\Tools\hfs23.exe" >NUL
if %errorlevel% neq 0 (
	
    echo [-] Service creation failed. Exiting.
    exit /b 1
)

echo [+] HFS Service created successfully.


:: Command 2 : Start HFS Service
echo [*] Starting HFS Service...
C:\Tools\nssm.exe start HFS >NUL
if %errorlevel% neq 0 (
	
    echo [-] Service HFS failed to start. Exiting.
    exit /b 1
)

echo [+] HFS Service started successfully.


:: Check service status
echo [*] Checking service status...

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

:: Function to move a file
:MoveFile
setlocal
set "SOURCE=%1"
set "DEST=%2"

:: Check if source file exists
if not exist "%SOURCE%" (
    echo File not found: %SOURCE%
    endlocal
    exit /b 1
)

:: Ensure destination folder exists
set "DEST_FOLDER=%~dp2"
if not exist "%DEST_FOLDER%" (
    mkdir "%DEST_FOLDER%"
)

:: Move the file
move /Y "%SOURCE%" "%DEST%" >NUL

:: Check if the move was successful
if errorlevel 1 (
    echo Failed to move the file: %SOURCE%
)

endlocal
exit /b

goto :EOF
