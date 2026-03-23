#ifndef DB_COMMON_H
#define DB_COMMON_H

#include <sqlca.h>

void connect_or_die(void);
void disconnect_commit(void);
void disconnect_rollback(void);
void print_sql_error(const char *where);

#endif
