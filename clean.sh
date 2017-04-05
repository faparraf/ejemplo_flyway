#!/bin/bash

set -e -u

docker-compose stop
docker-compose rm -f
SUDO=
[ "$(uname -s)" = "Linux" ] && SUDO=sudo
$SUDO rm -rf data cache
