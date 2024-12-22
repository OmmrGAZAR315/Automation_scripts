@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
) else (
    set "BRANCH_NAME=%~1"
)


:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/dev/learnovia-frontend"
set PEM_FILE="D:\learnovia.pem"
set SERVER_USER="ubuntu"
set SERVER_IP="dev.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" "
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git checkout %BRANCH_NAME% && git reset --hard origin/%BRANCH_NAME%"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo rm -rf dist/learnoviaFront; npm run build; sudo rm -rf dist/learnovia_$(date \"+%%d-%%m-%%Y\")"
echo "Frontend build completed successfully...rm old dist that match today date"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && mv dist/learnovia dist/learnovia_$(date \"+%%d-%%m-%%Y\"); mv dist/learnoviaFront dist/learnovia"
echo "Renamed build successfully"
pause
endlocal