#!/bin/sh
set -e
dir=`dirname "$0"`
cd "$dir"

set -x
cp tools/docker-bash /usr/local/bin/
cp tools/docker-ssh /usr/local/bin/
cp tools/baseimage-docker-nsenter /usr/local/bin/
mkdir -p /usr/local/share/baseimage-docker
cp image/services/sshd/keys/insecure_key /usr/local/share/baseimage-docker/
chmod 644 /usr/local/share/baseimage-docker/insecure_key
# force set permissions for source key
#chmod 600 image/services/sshd/keys/insecure_key
