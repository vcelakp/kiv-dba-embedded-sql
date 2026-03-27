#!/bin/bash

export ORA_DB_SECRET_FILE="./ora_db"
export ORA_USER_SECRET_FILE="./ora_user"
export ORA_PASS_SECRET_FILE="./ora_pass"

EMBEDDED_SQL_IMAGE=kiv-dba/embedded-sql:local docker compose run --rm embedded-sql
