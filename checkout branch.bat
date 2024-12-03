@echo off
setlocal

:: Prompt for front destination
if "%~1"=="" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
) else (
    set "BRANCH_NAME=%~1"
)


:: Prompt for front destination
if "%~2"=="" (
    set /p "PROJECT_PATH=Please enter the front project path [default: /schools/SCHOOL_NAME/learnovia-backend]: "
) else (
    set "PROJECT_PATH=%~2"
)

:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"


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


ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" && git reset HEAD --hard && sudo git checkout -f %BRANCH_NAME%"
	

pause
endlocal