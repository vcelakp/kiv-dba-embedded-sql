#!/bin/bash
LIGHTRED='\033[0;31m'
NC='\033[0m' # No Color
echo ""
echo -e "${LIGHTRED}BUILD examples${NC}"
./build.sh

echo -e "${LIGHTRED}RUN examples${NC}"
echo ""
./run.sh build/00-c-empty-main
./run.sh build/01-c-hello-world
./run.sh build/02-c-oracle-connection-hardcoded
./run.sh build/03-c-oracle-connection-env
./run.sh build/04-c-sqlca-and-error-handling-minimal
./run.sh build/05-c-varchar-and-indicator
./run.sh build/06-c-static-dml
./run.sh build/07-c-cursor-fetch-explicit
./run.sh build/08-c-cursor-whenever-not-found
./run.sh build/09-c-cursor-current-of
./run.sh build/10-c-plsql-anonymous-block
./run.sh build/11-c-transaction-savepoint-rollback
./run.sh build/12-c-locking-for-update
./run.sh build/13-c-dynamic-sql-method1
./run.sh build/14-c-dynamic-sql-method2
./run.sh build/15-c-dynamic-sql-method3

#./run.sh build/cursors
