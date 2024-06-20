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
    clear
    echo "nodeJS: $(node --version)"
    echo "NPM: $(npm --version)"

    rm -vfr /usr/local/bin/nod* /usr/local/bin/yar* /tmp/node-*
    echo -e  "\n${I_OK}    GET New Version ...                                                         ${I_OK}\n";
    wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/node-release.json 
    jq -r '[.[]| select(.lts==false)]' /tmp/node-release.json > /tmp/node-release-current.json 
    NODE_VERSION=$(jq -r '.[0].version' /tmp/node-release-current.json);
    NODE_DATE=$(jq -r '.[0].date' /tmp/node-release-current.json);

    echo -e  "\n${I_OK}    Install Current Version ...                                                 ${I_OK}\n";
    echo -e  "\tCurrent NodeJS: ${NODE_VERSION} | ${NODE_DATE}"
    wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-current.tar.xz
    tar -xJf "/tmp/node-current.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
    ln -s /usr/local/bin/node /usr/local/bin/nodejs

    corepack enable
    clear

    echo -e  "\n${I_OK}    Installing Updates ...                                                      ${I_OK}\n";
    npx npm-check --global --update-all
    yarn set version stable

    echo -e  "\n${I_OK}    versions ...                                                                ${I_OK}\n";
    echo -e "nodeJS:\t\t$(node --version)"
    echo -e "NPM:\t\t$(npm --version)"
    echo -e "yarn:\t\t$(yarn --version)\n"
    npm -g ls
fi