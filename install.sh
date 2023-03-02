#!/bin/sh
apk add jq bash curl
rm -f /usr/local/bin/nod* /usr/local/bin/yar*
wget --no-cache https://unofficial-builds.nodejs.org/download/release/index.json -O /tmp/release.json 
NODE_VERSION=$(jq -r '.[0].version' /tmp/release.json);

echo "Install Current Version ..."
wget --no-cache "https://unofficial-builds.nodejs.org/download/release/$NODE_VERSION/node-$NODE_VERSION-linux-x64-musl.tar.xz" -O /tmp/node-current.tar.xz
tar -xJf "/tmp/node-current.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
ln -s /usr/local/bin/node /usr/local/bin/nodejs
echo "nodeJS: $(node --version)"
echo "NPM: $(npm --version)"
corepack enable

echo "Install nodemon and update npm ..."
npm install --global nodemon npm
yarn set version stable

echo "versions ..."
echo "nodeJS: $(node --version)"
echo "NPM: $(npm --version)"
echo "yarn: $(yarn --version)"
echo "nodemon: $(nodemon --version)"
