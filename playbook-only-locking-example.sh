#!/bin/bash
LIGHTRED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${LIGHTRED}RUN examples${NC}"
echo ""
./run.sh build/12-c-locking-for-update

# EOF
