@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "BRANCH_NAME=Please enter the Branch name: "

:: Prompt for front destination
set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "

set /p "PULL_DEV=pull deve? [y/n]:"

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

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git rev-parse --abbrev-ref HEAD"

if "%BRANCH_NAME%"=="" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
)

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git fetch --all --prune && git stash push -m \"Checkout script branch $(git rev-parse --abbrev-ref HEAD)\" && git reset --hard HEAD  && git checkout %BRANCH_NAME% && git reset --hard origin/%BRANCH_NAME%"

@REM ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo find . -type d \( -name 'vendor' -o -name 'storage' -o -name 'public' -o -name 'override'  \) -prune -o \( -type f -name '*.php' -o -type d \) -exec chmod 757 {} + -exec chown ubuntu:ubuntu {} +;"


if "!STASH_POP!"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git stash pop"
)	

if "!BRANCH_NAME!"=="dev_report" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) && if [ \"$CURRENT_BRANCH\" = \"dev_report\" ]; then git config pull.rebase false; git pull origin development; fi"
    echo.
    echo.
    set /p "PERM_NAME=Please enter the permission name: "
    if "!PERM_NAME!"=="" (
        echo "Permission name is required"
        set /p "PERM_NAME=Please enter the permission name: "
        echo /!PERM_NAME!/
    )
    if not "!PERM_NAME!"=="" (
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "grep 'report_card/.*/first-term' %PROJECT_PATH%/app/Http/Controllers/TermsReportController.php"
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sed -i 's|report_card/.*/first-term|report_card/!PERM_NAME!/first-term|' %PROJECT_PATH%/app/Http/Controllers/TermsReportController.php"
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "grep 'report_card/.*/first-term' %PROJECT_PATH%/app/Http/Controllers/TermsReportController.php"
        @REM ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% 'sed -i 's|'permission_name' => 'report_card/.*'/|'permission_name' => 'report_card/!PERM_NAME!/|' %PROJECT_PATH%/app/Http/Controllers/EvaluationReportController.php"
    )
)

if "!PULL_DEV!"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git reset --hard; git pull origin development -f; git status"
)

pause
endlocal