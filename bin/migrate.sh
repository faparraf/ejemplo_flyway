#!/bin/bash

set -e -u

# http://stackoverflow.com/a/3352015/687480
trim() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
  echo -n "$var"
}

if [ -z "$(trim "${COREDB_URL:-}")" ]
then
  echo no esta definido COREDB_URL > /dev/stderr
  exit 1
fi

if [ -z "$(trim "${COREDB_USER:-}")" ]
then
  echo no esta definido COREDB_USER > /dev/stderr
  exit 1
fi

if [ -z "$(trim "${COREDB_PASSWORD:-}")" ]
then
  echo no esta definido COREDB_PASSWORD > /dev/stderr
  exit 1
fi

if [ -z "$(trim "${COREDB_SCHEMA_NAME:-}")" ]
then
  echo no esta definido COREDB_SCHEMA_NAME > /dev/stderr
  exit 1
fi

set -a
source migraciones.conf
set +a

flyway_target="COREDB_${COREDB_SCHEMA_NAME}_TARGET"
flyway_target="${!flyway_target:-current}"

PARAMS="
  -url=${COREDB_URL}
  -user=${COREDB_USER}
  -password=${COREDB_PASSWORD}
  -schemas=${COREDB_SCHEMA_NAME}
  -locations=filesystem:/drone/src/ejemplo_flyway/esquemas/${COREDB_SCHEMA_NAME}
  -target=${flyway_target}
"

c=1
max_loop=15
while ! /flyway/flyway info $PARAMS
do
  sleep 3
  c=$((c+1))
  if [ $c -gt $max_loop ]
  then
    echo error conectando a la base de datos > /dev/stderr
    exit 1
  fi
done

/flyway/flyway migrate $PARAMS
rm -f /tmp/migrate.info.$$.log
/flyway/flyway info $PARAMS | tee -a /tmp/migrate.info.$$.log

if [ "${flyway_target}" != current ]
then
  if ! egrep "^| ${flyway_target} +| .* | Success +|$" /tmp/migrate.info.$$.log > /dev/null
  then
    rm -f /tmp/migrate.info.$$.log
    echo no success
    exit 1
  fi
fi

rm -f /tmp/migrate.info.$$.log
