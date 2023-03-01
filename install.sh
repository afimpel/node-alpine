#!/bin/sh
apk add jq bash curl
wget https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
NODE_VERSION=$(jq -r '.[1].casa.venta' /tmp/release.json);
wget "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-current.tar.xz
tar -xJf "/tmp/node-current.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
ln -s /usr/local/bin/node /usr/local/bin/nodejs
curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --rc

node --version
npm --version
yarn --version