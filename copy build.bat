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
if not defined PEM_FILE (
    set /p "PEM_FILE=Please enter the PEM file path: "
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
)

REM Set SERVER_USER from the 4th argument
set "SERVER_USER=%~4"
if not defined SERVER_USER (
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
)

REM Set SERVER_IP from the 5th argument
set "SERVER_IP=%~5"
if not defined SERVER_IP (
    set /p "SERVER_IP=Please enter the server IP [default: 98.81.160.170]: "
    if "!SERVER_IP!"=="" set "SERVER_IP=dev.learnovia.com"
)
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo mv %TO_PATH%/learnovia %TO_PATH%/learnovia_$(date \"+%%d-%%m-%%Y\") && sudo cp -r %FROM_PATH%/learnovia %TO_PATH%/learnovia"
	

pause
endlocal