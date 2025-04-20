@echo off
set /p "SERVER=Enter server name [***.learnovia.com]: "
ssh -i  D:\learnovia.pem -o StrictHostKeyChecking=no ubuntu@%SERVER%.learnovia.com

if  %ERRORLEVEL% NEQ 0 (
    echo Command failed with exit code %ERRORLEVEL%.
    ssh-keygen -R %SERVER%.learnovia.com
)