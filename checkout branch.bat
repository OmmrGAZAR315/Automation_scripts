@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "BRANCH_NAME=Please enter the Branch name: "

:: Prompt for front destination
set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "

::promt for stash pop
set /p "STASH_POP=Do you want to stash pop? [y/n]: "
if "!STASH_POP!"=="" set "STASH_POP=n"


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
:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"
set "SERVER_IP=%SERVER_IP%.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" && git checkout %BRANCH_NAME% && git reset --hard origin/%BRANCH_NAME%"

if "!STASH_POP!"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git stash pop"
)	

pause
endlocal