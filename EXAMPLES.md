 # Database Applications (KIV/DBA): Embedded SQL Examples

- [`00-c-empty-main`](examples/00-c-empty-main/main.pc)  
  **Goal:** Understand the minimal structure of a C program.  
  **Practice:** the `main` function and the program exit status.  
  **Key elements:** `int main()`, `return 0;`

- [`01-c-hello-world`](examples/01-c-hello-world/main.pc)  
  **Goal:** Compile and run a simple C program that writes to standard output.  
  **Practice:** basic console output and program structure.  
  **Key elements:** `#include <stdio.h>`, `printf(...)`, `main`

- [`02-c-oracle-connection-hardcoded`](examples/02-c-oracle-connection-hardcoded/main.pc)  
  **Goal:** Learn the simplest Oracle connection from a C program using Embedded SQL.  
  **Practice:** host variables, `CONNECT`, checking `sqlca.sqlcode`, and disconnecting from the database.  
  **Key elements:** `EXEC SQL BEGIN DECLARE SECTION`, `EXEC SQL CONNECT`, `sqlca`, `ROLLBACK WORK RELEASE`

- [`03-c-oracle-connection-env`](examples/03-c-oracle-connection-env/main.pc)  
  **Goal:** Connect to Oracle using credentials loaded from environment variables instead of hard-coded values.  
  **Practice:** combining standard C code with Embedded SQL and copying values into host variables.  
  **Key elements:** `getenv(...)`, `strncpy(...)`, `EXEC SQL CONNECT`, `COMMIT WORK RELEASE`

- [`04-c-sqlca-and-error-handling-minimal`](examples/04-c-sqlca-and-error-handling-minimal/main.pc)  
  **Goal:** Understand the role of `sqlca` and basic runtime error handling.  
  **Practice:** reading Oracle return codes, detecting failed SQL operations, and printing diagnostic output.  
  **Key elements:** `EXEC SQL INCLUDE sqlca`, `sqlca.sqlcode`, error check after SQL statement

- [`05-c-varchar-and-indicator`](examples/05-c-varchar-and-indicator/main.pc)  
  **Goal:** Work with Oracle string data and nullable columns in Embedded SQL.  
  **Practice:** the pseudotype `VARCHAR`, indicator variables, and handling `NULL` values correctly.  
  **Key elements:** `VARCHAR`, `.len`, `.arr`, `short indicator`, `SELECT ... INTO`

- [`06-c-static-dml`](examples/06-c-static-dml/main.pc)  
  **Goal:** Perform basic static data manipulation in Embedded SQL.  
  **Practice:** `INSERT`, `UPDATE`, `DELETE`, `SELECT ... INTO`, transaction completion with `COMMIT` or `ROLLBACK`.  
  **Key elements:** static SQL statements, host variables, `COMMIT WORK`, `ROLLBACK WORK`

- [`07-c-cursor-fetch-explicit`](examples/07-c-cursor-fetch-explicit/main.pc)  
  **Goal:** Learn explicit cursor processing step by step.  
  **Practice:** declaring a cursor, opening it, fetching rows one by one, and closing it.  
  **Key elements:** `DECLARE CURSOR`, `OPEN`, `FETCH`, `CLOSE`

- [`08-c-cursor-whenever-not-found`](examples/08-c-cursor-whenever-not-found/main.pc)  
  **Goal:** Handle end-of-data conditions in a cursor loop in a cleaner way.  
  **Practice:** using `WHENEVER NOT FOUND` instead of checking the return code manually after each `FETCH`.  
  **Key elements:** `EXEC SQL WHENEVER NOT FOUND`, `FETCH` loop, end-of-result processing

- [`09-c-cursor-current-of`](examples/09-c-cursor-current-of/main.pc)  
  **Goal:** Update or delete the row currently referenced by a cursor.  
  **Practice:** row-level processing with `FOR UPDATE` and `WHERE CURRENT OF`.  
  **Key elements:** `FOR UPDATE`, `WHERE CURRENT OF`, cursor-based row update

- [`10-c-plsql-anonymous-block`](examples/10-c-plsql-anonymous-block/main.pc)  
  **Goal:** Embed a PL/SQL block inside a C program.  
  **Practice:** passing values between C host variables and PL/SQL, and executing procedural database logic.  
  **Key elements:** `EXEC SQL EXECUTE`, `BEGIN ... END;`, PL/SQL block, host variable binding

- [`11-c-transaction-savepoint-rollback`](examples/11-c-transaction-savepoint-rollback/main.pc)  
  **Goal:** Understand transaction control beyond simple `COMMIT` and `ROLLBACK`.  
  **Practice:** creating savepoints and rolling back only part of a transaction.  
  **Key elements:** `SAVEPOINT`, `ROLLBACK TO SAVEPOINT`, transaction boundaries

- [`12-c-locking-for-update`](examples/12-c-locking-for-update/main.pc)  
  **Goal:** Observe row locking and concurrent access behavior.  
  **Practice:** locking rows with `FOR UPDATE` and understanding what happens before and after `COMMIT` or `ROLLBACK`.  
  **Key elements:** `SELECT ... FOR UPDATE`, transaction lock, concurrent session behavior

- [`13-c-dynamic-sql-method1`](examples/13-c-dynamic-sql-method1/main.pc)  
  **Goal:** Introduce the simplest form of dynamic SQL in Embedded SQL.  
  **Practice:** executing a SQL statement that is prepared from a string known at runtime.  
  **Key elements:** dynamic SQL, SQL text in C string, `PREPARE`, `EXECUTE`

- [`14-c-dynamic-sql-method2`](examples/14-c-dynamic-sql-method2/main.pc)  
  **Goal:** Use dynamic SQL with input bind variables.  
  **Practice:** preparing a statement once and supplying values at execution time.  
  **Key elements:** `PREPARE`, bind variables, `EXECUTE ... USING`

- [`15-c-dynamic-sql-method3`](examples/15-c-dynamic-sql-method3/main.pc)  
  **Goal:** Use dynamic SQL for queries that return rows.  
  **Practice:** preparing a dynamic `SELECT`, declaring a cursor for it, opening it, fetching rows, and closing it.  
  **Key elements:** dynamic `SELECT`, `PREPARE`, cursor for dynamic statement, `OPEN`, `FETCH`, `CLOSE`
