#!/bin/sh
apk add jq bash curl
wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
NODE_VERSION=$(jq -r '.[0].version' /tmp/release.json);
wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-current.tar.xz
tar -xJf "/tmp/node-current.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
ln -s /usr/local/bin/node /usr/local/bin/nodejs
npm install --global yarn nodemon pm2

node --version
npm --version
yarn --version
nodemon --version
pm2 --version