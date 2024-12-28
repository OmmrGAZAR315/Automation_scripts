@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "
) else (
    set "PROJECT_PATH=%~2"
)

:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"

set "DB_PASS=%~2"
if not defined DB_PASS (
    set /p "DB_PASS=Please enter db password: "
    if "!DB_PASS!"=="" set "DB_PASS=Learnovia_2025*modern2025"
)

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

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'"
echo.

echo server databse selected is:
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' %PROJECT_PATH%/.env"


echo.
echo.
:: Prompt for front destination
if "%~1"=="" (
    set /p "DB=Please enter the database name: "
) else (
    set "DB=%~1"
)

if "%DB%"=="" (
    echo "Database name is required"
    pause
    exit
)
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% " sudo sed -i 's/^DB_DATABASE=.*/DB_DATABASE=%DB%/' %PROJECT_PATH%/.env "

echo Database name changed successfully

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' %PROJECT_PATH%/.env"

pause
endlocal