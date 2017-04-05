#!/bin/bash

set -e -u

url="COREDB_${CI_BRANCH}_URL"
user="COREDB_${CI_BRANCH}_USER"
password="COREDB_${CI_BRANCH}_PASSWORD"

case "${CI_BRANCH}"
in
  ambiente_pruebas)
    if ! passed master
    then
      echo no se hace despliegue pues no se ha pasado el ambiente de integracion continua
      exit 1
    fi
  ;;
  ambiente_produccion)
    if ! passed ambiente_pruebas
    then
      echo no se hace despliegue pues no se ha pasado el ambiente de pruebas
      exit 1
    fi
  ;;
esac

for migracion in migraciones/*.conf
do
  source $migracion
  export COREDB_URL="${!url:-}"
  export COREDB_USER="${!user:-}"
  export COREDB_PASSWORD="${!password:-}"
  COREDB_SCHEMA_NAME="${migracion%.conf}"
  export COREDB_SCHEMA_NAME="${COREDB_SCHEMA_NAME#migraciones/*_}"
  echo "COREDB_URL=${COREDB_URL}"
  echo "COREDB_USER=${COREDB_USER}"
  echo "COREDB_PASSWORD=$(sed 's|.|***|g' <<< "${COREDB_PASSWORD}")"
  echo "COREDB_SCHEMA_NAME=${COREDB_SCHEMA_NAME}"
  migrate
done

# archivo flag que se sube a s3
date > "${CI_COMMIT}-done"
