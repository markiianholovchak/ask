#!/bin/bash

MY_NAME=${MY_NAME:-"Markiian Holovchak"}
APP_URL=${APP_URL:-"https://github.com/jkanclerz/computer-programming-4/releases/download/v1.29/my-ecommerce-0.1.jar"}
APP_DIR=/opt/ecommerce
APP_NAME=${APP_NAME:-ecommerce}

echo "hello ${MY_NAME}"

PACKAGES_TO_BE_INSTALLED="mc cowsay tree"
dnf install -y -q ${PACKAGES_TO_BE_INSTALLED}

## Install java
dnf install -y -q java-17-amazon-corretto

mkdir -p ${APP_DIR}

## install .jar

wget ${APP_URL} -O ${APP_DIR}/app.jar

# java -Dserver.port=80 -jar ${APP_DIR}/app.jar

##configure systemd
## /ect/systemd/system/ecommerce.service

serviceTemplate="
[Unit]
Description=${APP_NAME}
After=network-online.target

[Service]
Type=simple
User=root
ExecStart=java -Dserver.port=80 -jar ${APP_DIR}/app.jar
Restart=always

[Install]
WantedBy=multi-user.target
"

echo -e "$serviceTemplate" > /etc/systemd/system/${APP_NAME}.service

systemctl daemon-reload
systemctl enable ${APP_NAME}
systemctl restart ${APP_NAME}



cowsay "it works"