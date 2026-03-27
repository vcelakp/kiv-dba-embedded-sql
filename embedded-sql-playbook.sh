#!/bin/bash
LIGHTRED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${LIGHTRED}RUN examples${NC}"
echo ""
./embedded-sql-run.sh build/00-c-empty-main
./embedded-sql-run.sh build/01-c-hello-world
./embedded-sql-run.sh build/02-c-oracle-connection-hardcoded
./embedded-sql-run.sh build/03-c-oracle-connection-env
./embedded-sql-run.sh build/04-c-sqlca-and-error-handling-minimal
./embedded-sql-run.sh build/05-c-varchar-and-indicator
./embedded-sql-run.sh build/06-c-static-dml
./embedded-sql-run.sh build/07-c-cursor-fetch-explicit
./embedded-sql-run.sh build/08-c-cursor-whenever-not-found
./embedded-sql-run.sh build/09-c-cursor-current-of
./embedded-sql-run.sh build/10-c-plsql-anonymous-block
./embedded-sql-run.sh build/11-c-transaction-savepoint-rollback
./embedded-sql-run.sh build/12-c-locking-for-update
./embedded-sql-run.sh build/13-c-dynamic-sql-method1
./embedded-sql-run.sh build/14-c-dynamic-sql-method2
./embedded-sql-run.sh build/15-c-dynamic-sql-method3

#./embedded-sql-run.sh build/cursors
