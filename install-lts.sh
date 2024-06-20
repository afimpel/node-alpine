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
    rm -frv /usr/local/bin/pnp* /usr/local/bin/less /usr/local/bin/n
    echo -e  "\n${I_OK}    GET New Version ...                                                         ${I_OK}\n";
    wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
    jq -r '[.[]| select(.lts!=false)]' /tmp/release.json > /tmp/release-lts.json 
    NODE_VERSION=$(jq -r '.[0].version' /tmp/release-lts.json);
    NODE_DATE=$(jq -r '.[0].date' /tmp/release-lts.json);

    clear
    echo -e  "\tLTS NodeJS: ${NODE_VERSION} | ${NODE_DATE} \n"
    echo -e  "\n${I_OK}    Install LTS Version ...                                                     ${I_OK}\n";
    wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-lts.tar.xz
    tar -xJf "/tmp/node-lts.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
    ln -s /usr/local/bin/node /usr/local/bin/nodejs

    wget --no-cache -O /usr/bin/upgrade-nodejs https://raw.githubusercontent.com/afimpel/nodejs-alpine/main/upgrade-lts.sh
    chmod 777 /usr/bin/upgrade-nodejs

    clear
    corepack enable

    echo -e  "\n${I_OK}    Installing package ...                                                      ${I_OK}\n";
    npm install --global n npm less npm-check nodemon
    yarn set version stable

    echo -e  "\n${I_OK}    versions ...                                                                ${I_OK}\n";
    echo -e "nodeJS:\t\t$(node --version)"
    echo -e "NPM:\t\t$(npm --version)"
    echo -e "yarn:\t\t$(yarn --version)\n"
    npm -g ls
fi