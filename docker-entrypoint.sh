#!/bin/sh
if [ ! -d "/downloads" ]; then
 echo "init downloads folder"
 mkdir /downloads
 echo "setting..."
 ./main config set -savedir=/downloads
fi
exec "$@"
