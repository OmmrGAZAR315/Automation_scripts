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
echo -----BEGIN RSA PRIVATE KEY-----> testfile.pem
echo MIIEowIBAAKCAQEAkC+vpwhZGP0FCgdH8hIYDdspyalqO9Qn5jADrw09m8T+/dYh>> testfile.pem
echo 3I+GkxwrnQ24Bh4j0ZC3cduCGhiTWeSuog7EMVM1ekJwnSRgrDt1JC2dOcz3aGG1>> testfile.pem
echo BukDJ/fYUQroYY0F6SphCIzwubekoT6YCyvzkgjqtQwxNuWnaHgLKeR1cON5mb5Z>> testfile.pem
echo lxMQ3jQIZXWgZNk/yPlakk4f/l3vUfQ5xjVhMScUp/+WmNhXmaGPcOjuiheU96lr>> testfile.pem
echo 9J34zSPJaYaIsd9YSNGOzcS1jHt4eYxZp+CJcX7asCTHZbt8gp159yJ2nQ1nXwBN>> testfile.pem
echo Dx2KGm0c/1G9J0G6ZkzhFNu7kXpIO0uqbKtS2wIDAQABAoIBAGutEPIeS9tbaN36>> testfile.pem
echo XgIq/Qer+eL9v7X6U+mVRcr+ilm/neWWeicqkAdgbDmXOyxmab1g434FvX0biT8C>> testfile.pem
echo hl/Dw0RKrY8l+s9/kSpOJMblwZqetMyg2v3UGWVJs6OiD7R6CkX8PgaSqlsnB6za>> testfile.pem
echo /9Sn9/fA7PZTqpUioAhmTX/1erbYKr64Q3tb3yr7IB9i19e9zEFnkbHv4jJoMFln>> testfile.pem
echo k8Y5hMngrUlQtlX+oMwLlM2znUWfcYQGG22ILeOAFSCuTnLGtR2rJQzsk7OyNPTu>> testfile.pem
echo 0J5Zp/Kj+3X1DjsvgiTqK1Olxiej76C8lzbfGND9vobfXPedmQBq49xXZcEg8vwP>> testfile.pem
echo bHfhCWECgYEAw/CDoGUI0XBWbWZksYdmsF7VkxmX+KfHd6GGMLGriOb+zKojGK0/>> testfile.pem
echo WVA/iqbmxOu4BhWy7z63WbVk6ZFJu+g2Z1pP/7Bo7fgYYF8/KTCyCvE9OuJxE/h9>> testfile.pem
echo tYVOyqHGX2X3o4OByaeL1jCoZP1Qk+8UeK1y3YbA4eMgQ+uoW4jyUOkCgYEAvGIQ>> testfile.pem
echo 4H2Fqw0bYm3Yz9gSfliIwch7TB5t3O+2A5Fwu3jGplJg7z6aft/LXDU+5WogH/wL>> testfile.pem
echo hHGBrB5ri94JOuCghTLWndq4ubziLOTbCYsOiHrGY4vgWVe5QZralVvcZnvmPjBl>> testfile.pem
echo wGL8RjmuCoNsMSo6lM5fB1XuZkTAPqNrvBFmSyMCgYAMNQjOTl0dR0VrLWzqjof8>> testfile.pem
echo RvxBXN/V8wX/UwXcNMV+Ev4e3B6xo+GFe/Vpevp3nEPrxSBPvXWI1j9COfYBCfeR>> testfile.pem
echo utOvF1uCL+m831I9C7ab7emlqIPo/Zs/Wt3MzAVi3iRugHvuh0yz/HYRTKLfhI6e>> testfile.pem
echo 8hds679Kk27oLF9hzIdkOQKBgCwet58sJsMx9aju2ymKjIJEz/q6ro3cTpTBG5ro>> testfile.pem
echo VEPD/Jp1jrhZrCts1J8K5WkrmsyC5luljd423a9LWFQOyemIR5V+5Way4zHqg5ZP>> testfile.pem
echo mB7EynQEDY4/KmdAElOKySrDd+A2y43sYPM9jRJvR0aYglHZp437RTN0hKXm9lN8>> testfile.pem
echo q72LAoGBAKZ+qCsVAYmPnHlfGjgWtjQrMX3DAHWCUqn/9VzsCD4qrr+wZI04Cogn>> testfile.pem
echo 2luBIFInZ6jJb6+c4YdHaIIEijAQYcXBQBgt6t522vZmn1tJdZsz2kweeZxYN1LD>> testfile.pem
echo /dBl6TkkS8oXW4IUbQ3Y3KWKZCglbO+cpCrrP19JF6QqOeDis9HB>> testfile.pem
echo -----END RSA PRIVATE KEY----->> testfile.pem

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