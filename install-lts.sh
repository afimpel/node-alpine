#!/bin/sh
UUID=$(id -u)
UUID=$(( UUID + 0 ))
I_OK="✔"
I_KO="✖️"


NC='\e[0m'
if [ $UUID != 0 ]; then
        echo "${I_KO}    Start the Script as 'root' for it to work properly    ${I_KO}";
        exit 1;
else
    apk add jq bash curl
    rm -f /usr/local/bin/nod* /usr/local/bin/yar*
    wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
    jq -r '[.[]| select(.lts!=false)]' /tmp/release.json > /tmp/release-lts.json 
    NODE_VERSION=$(jq -r '.[0].version' /tmp/release-lts.json);
    NODE_DATE=$(jq -r '.[0].date' /tmp/release-lts.json);
    clear
    echo -e "LTS NodeJS: ${NODE_VERSION} | ${NODE_DATE} \n"
    echo -e "Install LTS Version ... \n"
    wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-lts.tar.xz
    tar -xJf "/tmp/node-lts.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
    ln -s /usr/local/bin/node /usr/local/bin/nodejs
    clear
    echo "nodeJS: $(node --version)"
    echo "NPM: $(npm --version)"
    corepack enable

    echo -e  "\nInstall nodemon and update npm ... \n"
    npm install --global nodemon npm
    yarn set version stable

    echo -e "\n versions ..."
    echo "nodeJS: $(node --version)"
    echo "NPM: $(npm --version)"
    echo "yarn: $(yarn --version)"
    echo "nodemon: $(nodemon --version)"
fi