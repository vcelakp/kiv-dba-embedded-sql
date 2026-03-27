# Database Applications (KIV/DBA): Embedded SQL Examples

This repository provides a step-by-step introduction to Oracle Embedded SQL in C.

It starts with basic C programs and database connection, then covers SQLCA, host variables, VARCHAR pseudotypes, indicator variables, error handling, static SQL, cursors, embedded PL/SQL, transactions, locking, and dynamic SQL, including ANSI Method 4.

All examples are small, focused, and based on a single table, so they can be used easily.

## Common example table: `ESQL_STUDENT`

All examples use a single shared table:

- `ESQL_STUDENT(student_id, name, city, grade, note)`

Run this script first:

- `examples/sql/00-sql-create-embedded-sql-student.sql`

The table should contain the following data:

| STUDENT_ID | FULL_NAME | CITY    | GRADE | NOTE         |
|------------|-----------|---------|-------|--------------|
| 1          | Alice     | Praha   | 1.5   | excellent    |
| 2          | Bob       | Brno    | 2     |              |
| 3          | Tomas     | Ostrava |       | needs topic  |
| 4          | Jana      | Brno    | 2.7   |              |

## Examples

See [EXAMPLES](EXAMPLES.md) for the list of all prepared examples.

## Run all examples

First, you have to create local files:

- `ora_user`
- `ora_pass`
- `ora_db`

Tip: Make copy of `ora_db.default`, `ora_pass.default`, `ora_user.default` files and change content on their first line.

Each of file is used by examples through the following environment neccessary variables:

```bash
export ORA_DB_SECRET_FILE="./ora_db"
export ORA_USER_SECRET_FILE="./ora_user"
export ORA_PASS_SECRET_FILE="./ora_pass"
```

Optionaly you can use even files out of git repository:

```bash
export ORA_DB_SECRET_FILE="$HOME/.config/kiv-dba/ora_db"
export ORA_USER_SECRET_FILE="$HOME/.config/kiv-dba/ora_user"
export ORA_PASS_SECRET_FILE="$HOME/.config/kiv-dba/ora_pass"
```

Next, use `./embedded-sql-build.sh` followed by `./embedded-sql-playbook.sh` to build and then run the full set of examples.

The locking example (`12-c-locking-for-update`) pauses and waits for a
keystroke. While it is running, feel free to open another docker/terminal and run the dedicated
locking example (`embedded-sql-playbook-locking-example.sh`) as a parallel process to observe concurrent row
locking behavior.

## How to use?

The easiest way is definitely using Docker.

### Use Docker approach

#### Run all examples directly

```bash
EMBEDDED_SQL_IMAGE=kiv-dba/embedded-sql:local docker compose run --rm embedded-sql embedded-sql-playbook.sh
```

#### Use Docker image interactively

First, go to the [Oracle Instant Client
Downloads](https://www.oracle.com/database/technologies/instant-client/downloads.html)
page and download three ZIP packages for `linux` with `64 bits`:

- **Basic Package (ZIP)** required to run OCI, OCCI, and JDBC-OCI applications
- **SDK Package (ZIP)** header files and example makefiles for development
- **Precompiler Package (ZIP)** includes the `proc` precompiler

All three ZIP files must match `linux` and `64 bits` and the same Oracle version.

Next, compose docker image and run it:

```bash
EMBEDDED_SQL_IMAGE=kiv-dba/embedded-sql:local docker compose run --rm embedded-sql 
```

Everything is prepared when you can see prompt thats looks like:

```bash
Embedded SQL container ready.
PWD: /embedded-sql
Oracle env: ORA_DB=students.kiv.zcu.cz:1521/STUDENTS ORA_USER=vcelak ORA_PASS=<set>
Docker container embedded-sql:/embedded-sql#
```

Finaly, in running docker image, execute `./embedded-sql-build.sh` followed by `./embedded-sql-playbook.sh` to build and then run the full set of examples.

#### Notes

Pro*C examples are Pro*C source files (`.pc`), not plain C source files.
Docker image has `vim` editor with preconfigured highlighting of Pro*C files (`.pc`).

### Set own locally installed Pro*C environment

See [INSTALL](INSTALL.md) for setup instructions.

The exact include and library paths depend on your Oracle client installation environment.

Example of manual precompilation and compilation:

```bash
# Shared db_common
proc config=proc.cfg \ 
     iname=examples/common/db_common.pc \ 
     oname=build/db_common.c
gcc -c build/db_common.c \ 
    -Iexamples/common -I/opt/oracle/instantclient_21_12/sdk/include \ 
    -o build/db_common.o

# Example 02-c-oracle-connection-hardcoded
proc config=proc.cfg \ 
     iname=examples/02-c-oracle-connection-hardcoded/main.pc \ 
     oname=build/02-c-oracle-connection-hardcoded.c 
gcc -o build/02-c-oracle-connection-hardcoded \ 
    build/02-c-oracle-connection-hardcoded.c \ 
    build/db_common.o \ 
    -Iexamples/common -I/opt/oracle/instantclient_21_12/sdk/include \ 
    -L/opt/oracle/instantclient_21_12 \ 
    -Wl,-rpath,/opt/oracle/instantclient_21_12 \ 
    -lclntsh
```

Note 1: Embedded PL/SQL example (`10-c-plsql-anonymous-block`) requires `sqlcheck=semantics` checking option:

```bash
proc iname=10-c-plsql-anonymous-block/main.pc \ 
     sqlcheck=semantics \ 
     userid=$ORA_USER/$ORA_PASS@$ORA_DB
```

or use proc.cfg with that option:

```bash
proc config=proc.cfg \ 
     iname=examples/10-c-plsql-anonymous-block/main.pc \ 
     oname=build/10-c-plsql-anonymous-block.c
```

Note 2: The ANSI Dynamic SQL Method 4 example may require additional Pro*C options, like `dynamic=ansi` and `type_code=ansi`.
