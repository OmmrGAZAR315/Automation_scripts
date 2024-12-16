@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
) else (
    set "BRANCH_NAME=%~1"
)


:: Prompt for front destination
if "%~2"=="" (
    set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "
) else (
    set "PROJECT_PATH=%~2"
)

:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"


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
    set /p "SERVER_IP=Please enter the server IP [default: dev]: "
    if "!SERVER_IP!"=="" set "SERVER_IP=dev"
)
set "SERVER_IP=%SERVER_IP%.learnovia.com"

===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" && git checkout %BRANCH_NAME% && git reset --hard origin/%BRANCH_NAME%"
	

pause
endlocal