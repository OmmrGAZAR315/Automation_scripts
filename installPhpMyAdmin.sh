#!/bin/bash

# Variables from script parameters
PMA_URL="${1:-https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz}"

# Download and extract phpMyAdmin
echo "Downloading phpMyAdmin..."
wget -q $PMA_URL -O phpmyadmin.tar.gz

if [ $? -ne 0 ]; then
    echo "Failed to download phpMyAdmin. Please check the URL."
    exit 1
fi

echo "Decompressing phpMyAdmin..."
tar -xzf phpmyadmin.tar.gz

# Extracted folder might have a version number in its name, let's handle it
PMA_DIR=$(tar -tzf phpmyadmin.tar.gz | head -1 | cut -f1 -d"/")

# Move to /usr/share/phpmyadmin
echo "Moving phpMyAdmin to /usr/share/phpmyadmin..."
sudo mv $PMA_DIR /usr/share/phpmyadmin

# Clean up the tarball
rm phpmyadmin.tar.gz

# Copy config.sample.inc.php to config.inc.php
echo "Setting up phpMyAdmin configuration..."
sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php

# Generate a random Blowfish secret using OpenSSL
BLOWFISH_SECRET=$(openssl rand -base64 32)

# Replace the $cfg['blowfish_secret'] in config.inc.php with the generated key
echo "Inserting Blowfish secret into phpMyAdmin configuration..."
sudo sed -i "s|\$cfg\['blowfish_secret'\] = ''|\$cfg\['blowfish_secret'\] = '$BLOWFISH_SECRET'|" /usr/share/phpmyadmin/config.inc.php


# Test Nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration is successful. Reloading Nginx..."
    sudo systemctl reload nginx
else
    echo "Nginx configuration failed. Please check the configuration file."
    exit 1
fi

echo "phpMyAdmin setup is complete!"
