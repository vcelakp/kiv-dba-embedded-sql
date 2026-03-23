#!/bin/bash
LIGHTGREEN='\033[0;32m'
NC='\033[0m'
source env.sh

echo -e "${LIGHTGREEN}##################################################${NC}"
echo -e "${LIGHTGREEN}## RUN: $1${NC}"
echo -e "${LIGHTGREEN}##      ORA_DB=$ORA_DB${NC}"
echo -e "${LIGHTGREEN}##      ORA_USER=$ORA_USER${NC}"
echo -e "${LIGHTGREEN}##      ORA_PASS=****password****${NC}"
echo -e "${LIGHTGREEN}##################################################${NC}"
echo
./$1
echo
