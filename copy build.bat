@echo off
setlocal

:: Prompt for front destination
if "%~1"=="" (
    set /p "FROM_PATH=Please enter the front project path [default: SCHOOL_NAME]: "
) else (
    set "FROM_PATH=%~1"
)

:: Prompt for front destination
if "%~2"=="" (
    set /p "TO_PATH=Please enter the TARGET front project path [default: SCHOOL_NAME]: "
) else (
    set "TO_PATH=%~2"
)

set "FROM_PATH=/schools/%FROM_PATH%/learnovia-frontend/dist"
set "TO_PATH=/schools/%TO_PATH%/learnovia-frontend/dist"


set "PEM_FILE=%~3"
if "%PEM_FILE%"=="" (
    set /p "PEM_FILE=Please enter the PEM file path: "
    if "%PEM_FILE%"=="" set "PEM_FILE=D:\learnovia.pem"
)


:: Set default values if not provided
set "SERVER_USER=%~4"
if "%SERVER_USER%"=="" (
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    if "%SERVER_USER%"=="" set "SERVER_USER=ubuntu"
)


set "SERVER_IP=%~5"
if "%SERVER_IP%"=="" (
    set /p "SERVER_IP=Please enter the server IP [default: 98.81.160.170]: "
    if "%SERVER_IP%"=="" set "SERVER_IP=dev.learnovia.com"
)

===============================================================================

:: Extract the file name from the file path
for %%F in ("%FILE_PATH%") do (
    set "FILE_NAME=%%~nxF"
    set "ARCHIVE_NAME=%%~xF"  :: Get the file extension
)


ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo mv %TO_PATH%/learnovia %TO_PATH%/learnovia_$(date \"+%%d-%%m-%%Y\") && sudo cp -r %FROM_PATH%/learnovia %TO_PATH%/learnovia"
	

pause
endlocal