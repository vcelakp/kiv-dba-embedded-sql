#!/bin/bash
set -euo pipefail

LIGHTRED='\033[0;31m'
NC='\033[0m' # No Color

source env.sh

echo ""
echo -e "${LIGHTRED}BUILD examples${NC}"
make clean
make

