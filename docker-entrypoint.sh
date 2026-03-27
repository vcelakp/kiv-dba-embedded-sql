#!/bin/bash
set -e

cd /embedded-sql

if [[ -f ./env.sh ]]; then
  source ./env.sh
fi

if [[ $# -eq 0 ]]; then
  exec /bin/bash -i
else
  exec "$@"
fi
