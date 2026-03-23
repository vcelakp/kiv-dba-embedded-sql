
ORACLE_HOME := /opt/oracle/instantclient_21_12
CC := gcc
PROC := $(ORACLE_HOME)/sdk/proc
MKDIR_P := /bin/mkdir -p

SRC_DIR := examples
BUILD_DIR := build

export ORACLE_HOME
export LD_LIBRARY_PATH := $(ORACLE_HOME):$(LD_LIBRARY_PATH)
export PATH := /usr/bin:/bin:$ORACLE_HOME:$ORACLE_HOME/sdk:$PATH

CFLAGS  := -Iexamples/common -I$(ORACLE_HOME)/sdk/include 
#CFLAGS += -finput-charset=UTF-8 -fexec-charset=UTF-8

LDFLAGS := -L$(ORACLE_HOME) -Wl,-rpath,$(ORACLE_HOME)
LDLIBS  := -lclntsh

# All examples in ./examples/<name>/main.pc
EXAMPLES := $(patsubst $(SRC_DIR)/%/,%,$(dir $(wildcard $(SRC_DIR)/*/main.pc)))

# executables into ./build/: build/hello1 ...
BINS := $(addprefix $(BUILD_DIR)/,$(EXAMPLES))

.PHONY: all clean
all: $(BINS)

# ./build/<name> is based on ./examples/<name>/main.pc
$(BUILD_DIR)/%: $(SRC_DIR)/%/main.pc
	@echo ""
	@echo "\e[1;34mBuild $(BUILD_DIR)/$*\e[0m"
	@echo "\e[1;34m############################################################\e[0m"
	@$(MKDIR_P) $(BUILD_DIR)
	$(PROC) config=proc.cfg iname=examples/common/db_common.pc oname=build/db_common.c
	$(PROC) config=proc.cfg iname=$< oname=$(BUILD_DIR)/$*.c
	$(CC) -c build/db_common.c $(CFLAGS) -o build/db_common.o
	$(CC) -o $@ $(BUILD_DIR)/$*.c build/db_common.o $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	@echo ""

clean:
	rm -rf $(BUILD_DIR)
