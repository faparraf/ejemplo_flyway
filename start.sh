#!/bin/bash

set -e -u

driver_found="$(docker info -f '{{.Driver}}')"

if [ "${driver_found}" != aufs ]
then
  echo "El Storage Driver de Docker no es aufs: '${driver_found}'"
  echo "Presiona ENTER para continuar por tu propia cuenta"
  read
fi

if ! type wget > /dev/null
then
  echo wget no encontrado
  echo instalar wget antes de continuar
  exit 1
fi

if ! type psql > /dev/null
then
  echo psql no encontrado
  echo instalar postgresql-client/postgresql/postgres-client antes de continuar
  exit 1
fi

if ! type md5sum > /dev/null
then
  echo md5sum no encontrado
  echo instalar md5dum antes de continuar
  exit 1
fi

cleanup() {
  rm -f /tmp/$$.esquemas
}

trap cleanup EXIT

./bin/get_flyway.sh
docker-compose build
docker-compose up -d postgres
export COREDB_URL="${COREDB_URL:-jdbc:postgresql://postgres/test}"
export COREDB_USER="${COREDB_USER:-test}"
export COREDB_PASSWORD="${COREDB_PASSWORD:-test}"

if [ "${COREDB_URL}" = "jdbc:postgresql://postgres/test" ] &&
   [ "${COREDB_USER}" = "test" ] &&
   [ "${COREDB_PASSWORD}" = test ]
then
  ALL_DEFAULTS=yes
fi

if [ -z "${COREDB_SCHEMA_NAME:-}" ]
then
  for esquema in esquemas/*
  do
    if [ -d "${esquema}" ]
    then
      basename "${esquema}"
    fi
  done | cat -n > /tmp/$$.esquemas
  echo
  echo esquemas
  echo
  cat /tmp/$$.esquemas
  echo
  echo -n "cual esquema (numero): "
  read n
  selection="$(awk '$1=='"${n}"'{print $2}' /tmp/$$.esquemas)"
  export COREDB_SCHEMA_NAME="${selection}"
fi

echo
echo usando
echo "COREDB_URL=${COREDB_URL}"
echo "COREDB_USER=${COREDB_USER}"
echo "COREDB_PASSWORD=${COREDB_PASSWORD}"
echo "COREDB_SCHEMA_NAME=${COREDB_SCHEMA_NAME}"
echo
sleep 5

if [ "${ALL_DEFAULTS:-no}" = yes ]
then
  ./drone/fix_postgis.sh
fi

docker-compose up migrate
