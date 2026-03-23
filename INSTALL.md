# INSTALL

## Setting up Embedded SQL with Oracle Instant Client and Pro\*C on Linux

This guide describes how to set up an environment for Oracle Embedded SQL development with Oracle Instant Client, SDK, and Pro\*C.

## 1. Download Oracle Instant Client packages

Go to the Oracle Instant Client Downloads page and download the following ZIP packages for your platform, architecture, and Oracle version:

- **Basic Package (ZIP)** – required to run OCI, OCCI, and JDBC-OCI applications
- **SDK Package (ZIP)** – header files and example makefiles for development
- **Precompiler Package (ZIP)** – includes the `proc` precompiler

All three ZIP files must match:

- the same operating system
- the same architecture
- the same Oracle version

Example for Linux x86_64 and Oracle 21:

```bash
ls
instantclient-basic-linux.x64-21.12.0.0.0dbru.el9.zip
instantclient-sdk-linux.x64-21.12.0.0.0dbru.el9.zip
instantclient-precomp-linux.x64-21.12.0.0.0dbru.zip
```

## 2. Unpack the packages

```bash
cd /opt/oracle
unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.el9.zip
unzip instantclient-sdk-linux.x64-21.12.0.0.0dbru.el9.zip
unzip instantclient-precomp-linux.x64-21.12.0.0.0dbru.zip
ls
# instantclient_21_12
sudo chmod -R a+rX instantclient_21_12/
```

The SDK contains header files, and the precompiler package provides the `proc` executable.

## 3. Install `libaio`

Oracle client libraries require Linux asynchronous I/O support.

On Debian/Ubuntu systems:

```bash
sudo apt install libaio1t64
```

If the package provides `libaio.so.1t64` but not `libaio.so.1`, create a symbolic link and refresh the linker cache:

```bash
sudo ln -s /lib/x86_64-linux-gnu/libaio.so.1t64 /lib/x86_64-linux-gnu/libaio.so.1
sudo ldconfig
ldconfig -p | grep libaio
```

## 4. Set environment variables

```bash
export ORACLE_HOME=/opt/oracle/instantclient_21_12
export PATH=$ORACLE_HOME:$ORACLE_HOME/sdk:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
```

These variables can also be set in a shell initialization file or in a helper script such as `env.sh`.

## 5. Verify that `proc` works

Run:

```bash
proc
```

Expected output is similar to:

```text
Pro*C/C++: Release 21.0.0.0.0 - Production
Version 21.12.0.0.0
Copyright (c) 1982, 2023, Oracle and/or its affiliates.
All rights reserved.
System default option values taken from:
/opt/oracle/instantclient_21_12/precomp/admin/pcscfg.cfg
```

## 6. Check the default Pro\*C configuration

Inspect the default configuration file used by the precompiler:

```bash
cat /opt/oracle/instantclient_21_12/precomp/admin/pcscfg.cfg
```

This file contains default include paths and other precompiler options.

To list the include search paths really used by GCC, run:

```bash
echo | gcc -x c -E -Wp,-v - 2>&1
```

which output shows:

```text
ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/15/include-fixed/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/15/include-fixed"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/15/../../../../x86_64-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-linux-gnu/15/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
# 0 "<stdin>"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "<stdin>"
```

So, list of search paths is as follows:

```text
/usr/lib/gcc/x86_64-linux-gnu/15/include
/usr/local/include
/usr/include/x86_64-linux-gnu
/usr/include
```


## 7. Create your own `proc.cfg`

It is recommended to prepare a local configuration file and pass it explicitly using `config=proc.cfg`.

A minimal configuration may look like this:

```text
PARSE=FULL
CODE=ANSI_C
INCLUDE=(/opt/oracle/instantclient_21_12/sdk/include,
/usr/local/include,
/usr/lib/gcc/x86_64-linux-gnu/15/include,
/usr/include/x86_64-linux-gnu,
/usr/include)
```

Note: Remember to mention also the path to SDK (here `/opt/oracle/instantclient_21_12/sdk/include`).

### Recommended development configuration

For development, it is useful to add SQL checking and line mapping:

```text
PARSE=FULL
CODE=ANSI_C
SQLCHECK=SYNTAX
LINES=YES
INCLUDE=(/opt/oracle/instantclient_21_12/sdk/include,
/usr/local/include,
/usr/lib/gcc/x86_64-linux-gnu/15/include,
/usr/include/x86_64-linux-gnu,
/usr/include)
```

### Meaning of important options

- `PARSE=FULL` enables full parsing by the precompiler;
- `CODE=ANSI_C` generates ANSI C compatible output;
- `SQLCHECK=NONE` only transforms SQL, no SQL checking;
- `SQLCHECK=SYNTAX` checks SQL syntax without connecting to the database;
- `SQLCHECK=SEMANTICS` checks syntax and database object meaning;
- `SQLCHECK=FULL` includes semantic checking and privilege checking;
- `LINES=YES` inserts `#line` directives into generated `.c` files so compiler and debugger messages point to the original `.pc` file.

Note: `SQLCHECK=SEMANTICS` is default in examples. 


## 8. Precompile the first example

Generic template looks like:

```bash
proc config=proc.cfg iname=examples/hello/main.pc oname=examples/hello/main.c
```

which transforms `main.pc` into `main.c`.

For the real examples (e.g. `02-c-oracle-connection-hardcoded`) use correct paths to the example `main.pc` file and build directory to place its `*.c` version:

```bash
proc config=proc.cfg iname=examples/02-c-oracle-connection-hardcoded/main.pc oname=build/02-c-oracle-connection-hardcoded.c
```

## 9. Compile the generated C file

```bash
gcc -o build/02-c-oracle-connection-hardcoded examples/02-c-oracle-connection-hardcoded/main.c \
  -I$(ORACLE_HOME)/sdk/include \
  -L$(ORACLE_HOME) \
  -Wl,-rpath,$(ORACLE_HOME) \
  -lclntsh
```

### Meaning of the compiler options

- `gcc` invokes the C compiler
- `-o build/02-c-oracle-connection-hardcoded` sets the output executable name
- `examples/02-c-oracle-connection-hardcoded/main.c` the generated C source file
- `-I$(ORACLE_HOME)/sdk/include` adds the Oracle header file path
- `-L$(ORACLE_HOME)` adds the library search path for the linker
- `-Wl,-rpath,$(ORACLE_HOME)` stores the runtime library path in the executable
- `-lclntsh` links the Oracle client shared library

## 10. Run the program

```bash
source env.sh
./build/02-c-oracle-connection-hardcoded
```

Possible output:

```text
Connection failed: 4294955134
```

This confirms that the executable starts correctly, the Oracle client library is available, and the application reaches the database connection logic.
