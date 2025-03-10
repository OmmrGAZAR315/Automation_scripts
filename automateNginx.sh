#!/bin/bash

school=$1
framework=$2

case "$3" in
    fix)
    certbotFailed=$3
    ;;
    *)
    path=${3%/}
    ;;
esac
if [ "$#" -lt 3 ]; then
    echo "Wrong inputs"
    echo "<school> <framework> <project_path|fix to fix certbot> <customized domain (optional)> <enable_certbot (optional)>"
    exit 1
fi

domain=${4:-}						    #domain name otherwise school
isCertbotEnabled=${5:-}					    #true


restartNginx(){
    if sudo nginx -t; then
        echo "Nginx configuration restarted."
        sudo systemctl restart nginx
    else
        echo "Nginx configuration test failed."
        exit
    fi
}

createSymbolLink(){
    if [ ! -e "$enabled_file" ]; then
        sudo ln -s "$config_file" "$enabled_file"
    else
        echo "Symlink already exists: $enabled_file"
    fi

echo "Configuration file created and symlink added: $enabled_file"

}

certBotDomain(){
    if [ -n "$isCertbotEnabled" ]; then
        sudo certbot --nginx -d "${1}.learnovia.com"
    fi
}

logsPath(){
    if [ -d "$path/application" ]; then
        logs_path=$path"/logs"
        path=$path"/application"
        else
        logs_path=$path"/../logs"$1
    fi
    if [ ! -d "$logs_path"  ]; then
        mkdir -p $logs_path
    fi
}

isDomainPassed(){
    if [ -n "$domain" ]; then
        serverName=$domain
    else
        serverName=$1".learnovia.com"
    fi
echo $serverName
}

fixCertbot(){
sed -i '$d' "$config_file"

# Check if the SSL directory exists
if [ ! -d "/etc/letsencrypt/live/${serverName}" ]; then
    echo "/etc/letsencrypt/live/${serverName} does not exist"
    exit 1
fi 

# Append new configuration to the config file
sudo tee -a "$config_file" > /dev/null <<EOL
listen 443 ssl; # managed by Certbot
ssl_certificate /etc/letsencrypt/live/${serverName}/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/${serverName}/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    listen 80;
    server_name ${serverName}; # Ensure serverName is just the domain
    if (\$host = ${serverName}) {
        return 301 https://\$host\$request_uri; # managed by Certbot
    }
    return 404; # managed by Certbot
}
EOL

echo "Certbot configuration in ${config_file} fixed"
restartNginx
exit 0
}
####################################################
fileName="${school}-${framework}"

if [ ! -d "/etc/nginx/sites-available/$school" ]; then
    mkdir "/etc/nginx/sites-available/"$school
fi
config_file="/etc/nginx/sites-available/${school}/learnovia-"$fileName
enabled_file="/etc/nginx/sites-enabled/learnovia-"$fileName

case "$framework" in
    all)
        path=$path"/learnvoia-fe"
        ;&
    angular)
        serverName=$(isDomainPassed $school)
        if [ -n "$certbotFailed" ]; then
          fixCertbot $fixCertbot
        fi
        logsPath 'A'
        sudo tee "$config_file" > /dev/null <<EOL
server {
    server_name $serverName;

    root $path/dist/learnovia;
    access_log $logs_path/nginx-access.log;
    error_log $logs_path/nginx-error.log;

    error_page   500 502 503 504  /50x.html;

    index index.html index.htm;

    charset utf-8;

    gzip on;
    gzip_min_length 1000;
    gzip_buffers 4 32k;
    gzip_proxied any;
    gzip_types application/javascript application/json application/manifest+json application/octet-stream application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype font/woff font/woff2 image/svg+xml text/css text/csv text/javascript text/plain text/xml;
    gzip_vary on;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    location / {
      try_files \$uri \$uri/ /index.html;
    }

    location = /50x.html {
      root   /usr/share/nginx/html;
    }
}
EOL
        createSymbolLink
        restartNginx
        certBotDomain $school
    ;;
    all)
        path=$path"/learnvoia-be"
        ;&
    laravel)
        serverName=$(isDomainPassed $school"api")
        if [ -n "$certbotFailed" ]; then
          fixCertbot $fixCertbot
        fi
        logsPath 'L' 
        sudo tee "$config_file" > /dev/null <<EOL
server {

    server_name $serverName;

    root $path/public;
    access_log $logs_path/nginx-access.log;
    error_log $logs_path/nginx-error.log;

    add_header X-Frame-Options "" always;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    fastcgi_read_timeout 300;
    client_max_body_size 512M;

    index index.html index.htm index.php;
    charset utf-8;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    error_page 404 /index.php;

    # Handle main application paths
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # PHP Processing for All PHP Files
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;

        # Use mapped variables for SCRIPT_FILENAME and REQUEST_URI
        # fastcgi_param SCRIPT_FILENAME $script_filename;
        # fastcgi_param REQUEST_URI $request_url;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
    location /phpmyadmin {
    alias /usr/share/phpmyadmin;
    index index.php;
    try_files \$uri \$uri/ =404;

       location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
            fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME \$request_filename;
            include fastcgi_params;
        }
    }
}
EOL
        createSymbolLink
        restartNginx
        certBotDomain $school"api"
    ;;
*)
    echo "Unsupported framework: $framework"
    exit
    ;;
esac
