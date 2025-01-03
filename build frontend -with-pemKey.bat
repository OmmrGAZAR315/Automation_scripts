@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
) else (
    set "BRANCH_NAME=%~1"
)

:: Create a new file
echo -----BEGIN RSA PRIVATE KEY----- > testfile.pem
echo MIIEowIBAAKCAQEAiHlwlZQyKRtFmyNRM3UHx7F9LeyOfFKoMEgzTCMypO7QpCjt >> testfile.pem
echo yoLmsAHUJHp2RG9eWwJLIruw7lIJh8rojHczww2ZO6AL22g9/3hrG+kh94XKuwIg >> testfile.pem
echo IFlP48MsuY+gpPVEzZ82BEg1RiurcOyLwK7WweKhuExJOhvnGEvSpGUpb2ZLlOmE >> testfile.pem
echo 268EsM5Hb5FWd58iOdfEGqL3Xfi6DV1NXulTZ3LR4oNQxfX3LLgDjMquC85+EoyJ >> testfile.pem
echo rwdr8JU9MxUjQ+ej7Ur2M7vEesgVZWiPp4rbQ3zxFNDZ0JNA3/Rn7t22BrTAvT2r >> testfile.pem
echo PtAyn4nMVAbsxxLF+KgsdyoBPGXMnuzfIVhTeQIDAQABAoIBAGKO2Ric4rC/CkCk >> testfile.pem
echo e8LelJTJgC6HNMth4iakLa+hh7SG51R2XmwupqybVXpWmkyH5Styd5KI25jw1AMm >> testfile.pem
echo LVUrzMzjaDMgPQ/hs0xoyWlprucTzznIqizScxh4XjdQG2Kl4l9gyGDFSPv5E6HE >> testfile.pem
echo opSvb1ar9cCkDwoRFo58S43/pLHWrQpQrVgUlModI5AmslBA8godHzPosE6C6kAZ >> testfile.pem
echo feUHAQKT80tg0i2elYW99kd7E3QxtcZyTVjyLwzbC10LAEBpp0DTe01Ve2SfeXUM >> testfile.pem
echo PLUViUNVAcU2SSAylJXhx7UAjnxYNYBEHAf7fq2EKZXbro86FKAbZ1v7qbYDkS2j >> testfile.pem
echo v6bj1oECgYEA1W4QmDIhuUPIHKgta1CU5PK67nY4mVSqaEfMj7eMOL7PA+B1Lkfw >> testfile.pem
echo 9tDPerV0T/1BDgna9sHuCI2qJEQ2ssTJrK0kMkOhRDAfe/uRmwsDOBY+2kYrLCrW >> testfile.pem
echo 6ZbCgZDWBD5iovL+CApFDVlnxui0wgasH9nGzShNpPEso+wXYpfO++kCgYEAo7Hz >> testfile.pem
echo ZGxP765VA9rCIm1B7aQ80kLxBDbdQexnLFFnv61Yijipzn0r7ymG3BO4jm12Xl92 >> testfile.pem
echo qo0VBI/cW1lbtuWr0pjTvia9jid5X5Kf8URYslrdk6ObnwpnN1Uwous+0d5wiYBP >> testfile.pem
echo dmWkomeKFreIFMPDCjeySlG6NysoVKlPJfgSMRECgYEAsgYZr2l5ebgRDd417GKN >> testfile.pem
echo n57bz5YqxbK6ZTsmZOY7/wUhVeF+vLjjRGyN85OxThs3jUcpLlQ6gUXxGkkPuvOs >> testfile.pem
echo KO1O2OJSfLcLO/Zt0H5SFBFyIc0Pq8qb8sF+wmYWLfn/el3nCLvQNz9Q8bgfNgws >> testfile.pem
echo vHCBg5TPlvpYOu7t3p4z1ykCgYBPQO7oZhBlqO/8R8PKSz+qQOQ5oLN0KOQC8OQa >> testfile.pem
echo 7ubeRJ0jfr+n+65zwpVKpDmsq46trmaTuG6+oLA9ggwHhzcjZV7PJ46K7s2y2hia >> testfile.pem
echo BU80Ow4gVwwXej/y6En99wuZLKsrx3WxixCkmKCg0wcNlqItpj2qAdu4rip+ouJx >> testfile.pem
echo LaQRIQKBgA8Gaa1A1b9DfqFvRwzKu0UtJLNWP2DyUI7FqSUIcdrVXaRk2qa/Tbor >> testfile.pem
echo kOXVBjTjpzhXtC+TwgjPxaMDJ6Uz9Kt0WRigoDrGqrbA5JFBAFhV0DCkPnbwnHhx >> testfile.pem
echo 8cokjbnjkqcHslI+XHkhGD/a4yBjOocLRd0XDx3WM5Rp6I6Necyw >> testfile.pem
echo -----END RSA PRIVATE KEY-----  >> testfile.pem


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
pause
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && mv dist/learnoviaFront dist/learnovia"
echo "Renamed build successfully"
pause
endlocal