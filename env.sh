#!/bin/bash
export ORACLE_HOME=/opt/oracle/instantclient_21_12
export PATH=$ORACLE_HOME:$ORACLE_HOME/sdk:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH

export ORA_DB=`cat "ora_db"`
export ORA_USER=`cat "ora_user"`
export ORA_PASS=`cat "ora_pass"`

export LANG=cs_CZ.UTF-8
export LC_ALL=cs_CZ.UTF-8
export NLS_LANG="CZECH_CZECH REPUBLIC.AL32UTF8"

