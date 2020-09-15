#!/bin/sh
set -e

UID=${UID:-1000}
GID=${GID:-1000}

function fixperms {
  chown -R ${UID}:${GID} /data /opt/instagram-bridge
}

cd /opt/instagram-bridge

if [ ! -f /data/config.yaml ]; then
  cp ./config/sample.yaml /data/config.yaml
  echo "Didn't find a config file."
  echo "Copied default config file to /data/config.yaml"
  echo "Modify that config file to your liking."
  echo "Start the container again after that to generate the registration file."
  fixperms
  exit
fi

if [ ! -f /data/appservice-registration-instagram.yaml ]; then
  node app.js -r -u "http://localhost:9000" -c /data/config.yaml
  mv ./appservice-registration-instagram.yaml /data/appservice-registration-instagram.yaml
  echo "Didn't find a registration file."
  echo "Generated one for you."
  echo "Copy that over to synapses app service directory."
  fixperms
  exit
fi

fixperms

cp /data/appservice-registration-instagram.yaml ./

exec "$@"
