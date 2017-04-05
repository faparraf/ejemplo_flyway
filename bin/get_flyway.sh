#!/bin/bash

set -e -u

FLYWAY_VERSION="${FLYWAY_VERSION:-4.0.3}"
FLYWAY_MD5SUM="${FLYWAY_MD5SUM:-45e43135fed71f0a709da7c6d929aa6d}"
FLYWAY_DOWNLOAD_URL="https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz"

mkdir -p cache

pushd cache

if [ -e flyway-commandline.tar.gz ]
then
  md5sum -c <<< "${FLYWAY_MD5SUM} flyway-commandline.tar.gz" || rm -fv flyway-commandline.tar.gz
fi

if [ ! -e flyway-commandline.tar.gz ]
then
  wget "${FLYWAY_DOWNLOAD_URL}" -q -O flyway-commandline.tar.gz
fi

popd
