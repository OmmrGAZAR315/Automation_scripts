@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "FROM_PATH=Please enter the front project path [default: SCHOOL_NAME]: "

:: Prompt for front destination
set /p "TO_PATH=Please enter the TARGET front project path [default: SCHOOL_NAME]: "

set "FROM_PATH=/schools/%FROM_PATH%/frontend/dist"
set "TO_PATH=/schools/%TO_PATH%/frontend/dist"


:: prompt for config
set /p "CUSTOM=DO YOU WANT TO USE CONFIG? [y/n]: "
if "!CUSTOM!"=="" set "CUSTOM=n"

if /I "!CUSTOM!" == "y" (
    set /p "PEM_FILE=Please enter the PEM file path: "
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    set /p "SERVER_IP=Please enter the server IP [default: dev]: "
) else (
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
    if "!SERVER_IP!"=="" set "SERVER_IP=dev"
)
set "SERVER_IP=%SERVER_IP%.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mkdir -p %TO_PATH%"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo mv %TO_PATH%/learnovia %TO_PATH%/learnovia_$(date \"+%%d-%%m-%%Y\"); sudo cp -r %FROM_PATH%/learnovia %TO_PATH%/learnovia"


pause
endlocal