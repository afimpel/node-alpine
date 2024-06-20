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
    rm -frv /usr/local/bin/nod* /usr/local/bin/yar* /tmp/node-* /usr/local/lib/node_modules
    wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
    jq -r '[.[]| select(.lts==false)]' /tmp/release.json > /tmp/release-current.json 
    NODE_VERSION=$(jq -r '.[0].version' /tmp/release-current.json);
    NODE_DATE=$(jq -r '.[0].date' /tmp/release-current.json);

    clear
    echo -e  "\tCurrent NodeJS: ${NODE_VERSION} | ${NODE_DATE} \n"
    echo -e  "\n${I_OK}    Install Current Version ...                                                 ${I_OK}\n";
    wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-current.tar.xz
    tar -xJf "/tmp/node-current.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
    ln -s /usr/local/bin/node /usr/local/bin/nodejs

    wget --no-cache -O /usr/bin/upgrade-nodejs https://raw.githubusercontent.com/afimpel/nodejs-alpine/main/upgrade-current.sh
    chmod 777 /usr/bin/upgrade-nodejs

    clear
    corepack enable


    echo -e  "\n${I_OK}    Installing package ...                                                      ${I_OK}\n";
    npm install --global n npm pnpm less npm-check nodemon
    yarn set version stable

    echo -e  "\n${I_OK}    versions ...                                                                ${I_OK}\n";
    echo "nodeJS: $(node --version)"
    echo "NPM: $(npm --version)"
    echo "yarn: $(yarn --version)"
fi