@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "BRANCH_NAME=Please enter the Branch name: "

chcp 65001 > nul
:: Prompt for front destination
set /p "DO_PAUSE=Do you want to get 500 internal error🤓? [Y/N| default N]: "
if "!DO_PAUSE!"=="" set "DO_PAUSE=n"

:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/dev/learnovia-frontend"
set PEM_FILE="D:\learnovia.pem"
set SERVER_USER="ubuntu"
set SERVER_IP="shahadat.learnovia.com"
===============================================================================
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" "
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git checkout %BRANCH_NAME%; git reset --hard origin/%BRANCH_NAME%"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo rm -rf dist/learnoviaFront"

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo npm run build;"

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo rm -rf dist/learnovia_$(date \"+%%d-%%m-%%Y\")"
echo "Frontend build completed successfully...rm old dist that match today date"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && mv dist/learnovia dist/learnovia_$(date \"+%%d-%%m-%%Y\")"
echo "Renamed old build successfully"

if /I "%DO_PAUSE%"=="Y" (
    echo "............darb s7?🙄😂"
    pause
)

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && cp -R dist/learnoviaFront dist/learnovia"
echo "Renamed build successfully"

if /I "%DO_PAUSE%"=="Y" (
    echo "................4oof keda🥱?....a7la mesa 3lek😉"
)

pause
endlocal