#!/bin/bash

set -e -u

export PGPASSFILE=/tmp/$$.pgpassfile

echo 127.0.0.1:5432:gis:test:test > "${PGPASSFILE}"
chmod 0600 "${PGPASSFILE}"

cleanup() {
  rm -f "${PGPASSFILE}"
}

trap cleanup EXIT

for i in {1..15}
do
  last="$(psql -t -A -0 -h 127.0.0.1 -U test gis <<< 'SELECT 1' || true)"
  [ "${last}" = 1 ] && break
  [ "$i" = 15 ] && exit 1
  sleep 3
done

psql -h 127.0.0.1 -U test gis << 'EOF'
CREATE DATABASE test;
\c test
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE USER crud_user WITH PASSWORD 'crud_user';
GRANT CONNECT ON DATABASE test TO crud_user;
GRANT TEMPORARY ON DATABASE test TO crud_user;
CREATE USER coasverage_app WITH PASSWORD 'coasverage_app';
GRANT CONNECT ON DATABASE test TO coasverage_app;
GRANT TEMPORARY ON DATABASE test TO coasverage_app;
EOF
