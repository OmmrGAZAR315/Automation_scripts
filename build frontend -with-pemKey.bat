@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "BRANCH_NAME=Please enter the Branch name: "

chcp 65001 > nul
:: Prompt for front destination
set /p "DO_PAUSE=Do you want to get 500 internal error🤓? [Y/N| default N]: "
if "!DO_PAUSE!"=="" set "DO_PAUSE=n"

:: Create a new file
echo -----BEGIN OPENSSH PRIVATE KEY-----> testfile.pem
echo b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW>> testfile.pem
echo QyNTUxOQAAACAdxrnS6YAJn9PTxr/zuLbUSuRzbdggSw1A3EKEhQnRbAAAAKArxgPnK8YD>> testfile.pem
echo 5wAAAAtzc2gtZWQyNTUxOQAAACAdxrnS6YAJn9PTxr/zuLbUSuRzbdggSw1A3EKEhQnRbA>> testfile.pem
echo AAAECr4xxEFnooLDHcg6mX+fxvFiPZgKDjQVDf1vKCHHQ23B3GudLpgAmf09PGv/O4ttRK>> testfile.pem
echo 5HNt2CBLDUDcQoSFCdFsAAAAF29tbXJfZ2F6emFyQE9tYXItTGVub3ZvAQIDBAUG>> testfile.pem
echo -----END OPENSSH PRIVATE KEY----->> testfile.pem

icacls "testfile.pem" /inheritance:r

icacls "testfile.pem" /remove:g Everyone
icacls "testfile.pem" /remove:g SYSTEM
icacls "testfile.pem" /remove:g Administrators
icacls "testfile.pem" /remove:g Users
icacls "testfile.pem" /remove:g "Authenticated Users"

icacls "testfile.pem" /grant:r "%USERNAME%:(F)"

:: Append /dist to the upload destination
set "PROJECT_PATH=/schools/dev/learnovia-frontend"
set PEM_FILE="testfile.pem"
set SERVER_USER="ubuntu"
set SERVER_IP="dev.learnovia.com"
:: Set file permissions
:: Grant read and write permissions to the current user
icacls testfile.pem /grant "%username%":RW
===============================================================================
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" "
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git checkout %BRANCH_NAME% && git reset --hard origin/%BRANCH_NAME%"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo rm -rf dist/learnoviaFront; npm run build; sudo rm -rf dist/learnovia_$(date \"+%%d-%%m-%%Y\")"
echo "Frontend build completed successfully...rm old dist that match today date"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && mv dist/learnovia dist/learnovia_$(date \"+%%d-%%m-%%Y\")"
echo "Renamed old build successfully"

if /I "%DO_PAUSE%"=="Y" (
    echo "............darb s7?🙄😂"
    pause
)

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && mv dist/learnoviaFront dist/learnovia"
echo "Renamed build successfully"

if /I "%DO_PAUSE%"=="y" (
    echo "................4oof keda🥱?....a7la mesa 3lek😉"
)

pause
endlocal