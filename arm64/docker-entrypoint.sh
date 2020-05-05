#!/bin/sh
if [ ! -d "/downloads" ]; then
 echo "init downloads folder"
 mkdir /downloads
fi
if [ ! $FIRST_INIT ]; then
 echo "setting..."
 ./main config set -savedir=/downloads
 echo "export FIRST_INIT=1" >> /etc/profile
fi
exec "$@"
