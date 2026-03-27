#!/bin/bash
set -euo pipefail

LIGHTGREEN='\033[0;32m'
NC='\033[0m'

source env.sh

TARGET="${1-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: ./embedded-sql-run.sh build/<example-name>" >&2
  exit 2
fi

echo -e "${LIGHTGREEN}##################################################${NC}"
echo -e "${LIGHTGREEN}## EXAMPLE  ${TARGET}${NC}"
echo -e "${LIGHTGREEN}##${NC}"
echo -e "${LIGHTGREEN}## ORA_DB   ${ORA_DB}${NC}"
echo -e "${LIGHTGREEN}## ORA_USER ${ORA_USER}${NC}"
echo -e "${LIGHTGREEN}## ORA_PASS ****hidden****${NC}"
echo -e "${LIGHTGREEN}##################################################${NC}"
echo
"./${TARGET}"
