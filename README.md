# Database Applications (KIV/DBA): Embedded SQL Examples

This repository provides a step-by-step introduction to Oracle Embedded SQL in C.

It starts with basic C programs and database connection, then covers SQLCA, host variables, VARCHAR pseudotypes, indicator variables, error handling, static SQL, cursors, embedded PL/SQL, transactions, locking, and dynamic SQL, including ANSI Method 4.

All examples are small, focused, and based on a single table, so they can be used easily.



## Install

See [INSTALL.md](INSTALL.md) for setup instructions.



## Common example table: `ESQL_STUDENT`

All examples use a single shared table:

- `ESQL_STUDENT(student_id, full_name, city, grade, note)`

Run this script first:

- `examples/sql/00-sql-create-esql-student.sql`

The table should contain the following data:

| STUDENT_ID | FULL_NAME | CITY    | GRADE | NOTE         |
|------------|-----------|---------|-------|--------------|
| 1          | Alice     | Praha   | 1.5   | excellent    |
| 2          | Bob       | Brno    | 2     |              |
| 3          | Tomas     | Ostrava |       | needs topic  |
| 4          | Jana      | Brno    | 2.7   |              |



## Build notes

These examples are Pro*C source files (`.pc`), not plain C source files.

Most examples use the following environment variables:

- `ORA_USER`
- `ORA_PASS`
- `ORA_DB`

Example:

```bash
export ORA_USER=tomas
export ORA_PASS=secret
export ORA_DB=oracle.example.com:1521/STUDENTS
```



### Precompile and build

The exact include and library paths depend on your Oracle client installation.

Example of manual precompilation and compilation:

```bash
/opt/oracle/instantclient_21_12/sdk/proc config=proc.cfg iname=examples/common/db_common.pc oname=build/db_common.c
gcc -c build/db_common.c -Iexamples/common -I/opt/oracle/instantclient_21_12/sdk/include  -o build/db_common.o

/opt/oracle/instantclient_21_12/sdk/proc config=proc.cfg iname=examples/02-c-oracle-connection-hardcoded/main.pc oname=build/02-c-oracle-connection-hardcoded.c

gcc -o build/02-c-oracle-connection-hardcoded build/02-c-oracle-connection-hardcoded.c build/db_common.o -Iexamples/common -I/opt/oracle/instantclient_21_12/sdk/include  -L/opt/oracle/instantclient_21_12 -Wl,-rpath,/opt/oracle/instantclient_21_12 -lclntsh
```

Note: Embedded PL/SQL example (`10-c-plsql-anonymous-block`) requires semantic checking:

```bash
proc iname=10-c-plsql-anonymous-block/main.pc sqlcheck=semantics userid=$ORA_USER/$ORA_PASS@$ORA_DB
```

or use proc.cfg with that option:

```bash
/opt/oracle/instantclient_21_12/sdk/proc config=proc.cfg iname=examples/10-c-plsql-anonymous-block/main.pc oname=build/10-c-plsql-anonymous-block.c
```

The ANSI Dynamic SQL Method 4 example may require additional Pro*C options, like `dynamic=ansi` and `type_code=ansi`. 



## Recommended order of examples

- [`00-c-empty-main`](examples/00-c-empty-main/main.pc)
- [`01-c-hello-world`](examples/01-c-hello-world/main.pc)
- [`02-c-oracle-connection-hardcoded`](examples/02-c-oracle-connection-hardcoded/main.pc)
- [`03-c-oracle-connection-env`](examples/03-c-oracle-connection-env/main.pc)
- [`04-c-sqlca-and-error-handling-minimal`](examples/04-c-sqlca-and-error-handling-minimal/main.pc)
- [`05-c-varchar-and-indicator`](examples/05-c-varchar-and-indicator/main.pc)
- [`06-c-static-dml`](examples/06-c-static-dml/main.pc)
- [`07-c-cursor-fetch-explicit`](examples/07-c-cursor-fetch-explicit/main.pc)
- [`08-c-cursor-whenever-not-found`](examples/08-c-cursor-whenever-not-found/main.pc)
- [`09-c-cursor-current-of`](examples/09-c-cursor-current-of/main.pc)
- [`10-c-plsql-anonymous-block`](examples/10-c-plsql-anonymous-block/main.pc)
- [`11-c-transaction-savepoint-rollback`](examples/11-c-transaction-savepoint-rollback/main.pc)
- [`12-c-locking-for-update`](examples/12-c-locking-for-update/main.pc)
- [`13-c-dynamic-sql-method1`](examples/13-c-dynamic-sql-method1/main.pc)
- [`14-c-dynamic-sql-method2`](examples/14-c-dynamic-sql-method2/main.pc)
- [`15-c-dynamic-sql-method3`](examples/15-c-dynamic-sql-method3/main.pc)

You can run the full example set using `playbook.sh`.

The locking example (`12-c-locking-for-update`) waits for a keystroke. While it
is running, try to acquire the same lock from another terminal by running the
dedicated locking playbook script (`playbook-only-locking-example.sh`). 


