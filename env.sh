#!/bin/bash

read_secret_file() {
  local explicit_path="$1"
  shift
  local candidate

  if [[ -n "$explicit_path" && -f "$explicit_path" ]]; then
    tr -d '\r\n' < "$explicit_path"
    return 0
  fi

  for candidate in "$@"; do
    if [[ -n "$candidate" && -f "$candidate" ]]; then
      tr -d '\r\n' < "$candidate"
      return 0
    fi
  done

  return 1
}

export ORACLE_HOME=/opt/oracle/instantclient_21_12
export PATH="$ORACLE_HOME:$ORACLE_HOME/sdk:$PATH"
export LD_LIBRARY_PATH="$ORACLE_HOME:${LD_LIBRARY_PATH:-}"

export ORA_DB="$(read_secret_file "${ORA_DB_FILE:-}" /run/secrets/ora_db ora_db)"
export ORA_USER="$(read_secret_file "${ORA_USER_FILE:-}" /run/secrets/ora_user ora_user)"
export ORA_PASS="$(read_secret_file "${ORA_PASS_FILE:-}" /run/secrets/ora_pass ora_pass)"

export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8
export NLS_LANG="CZECH_CZECH REPUBLIC.AL32UTF8"
