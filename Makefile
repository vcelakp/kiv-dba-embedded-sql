SHELL := /bin/bash

ORACLE_HOME ?= /opt/oracle/instantclient_21_12
CC ?= gcc
PROC ?= $(ORACLE_HOME)/sdk/proc
MKDIR_P ?= mkdir -p
RM := rm -rf
PROC_RUNTIME_CFG_DIR ?= /tmp

SRC_DIR := examples
BUILD_DIR := build
COMMON_PC := $(SRC_DIR)/common/db_common.pc
COMMON_C := $(BUILD_DIR)/db_common.c
COMMON_O := $(BUILD_DIR)/db_common.o
PROC_CFG := $(BUILD_DIR)/proc.cfg

export ORACLE_HOME
export LD_LIBRARY_PATH := $(ORACLE_HOME):$(LD_LIBRARY_PATH)
export PATH := /usr/bin:/bin:$(ORACLE_HOME):$(ORACLE_HOME)/sdk:$(PATH)

CFLAGS ?= -O0 -g
CFLAGS += -I$(SRC_DIR)/common -I$(ORACLE_HOME)/sdk/include
LDFLAGS += -L$(ORACLE_HOME) -Wl,-rpath,$(ORACLE_HOME)
LDLIBS += -lclntsh

GCC_INCLUDE_DIR := $(shell $(CC) -print-file-name=include)
GCC_MULTIARCH := $(shell $(CC) -dumpmachine)
PROC_INCLUDE := $(ORACLE_HOME)/sdk/include,/usr/local/include,$(GCC_INCLUDE_DIR),/usr/include/$(GCC_MULTIARCH),/usr/include,$(SRC_DIR)/common

EXAMPLES := $(patsubst $(SRC_DIR)/%/,%,$(dir $(wildcard $(SRC_DIR)/*/main.pc)))
BINS := $(addprefix $(BUILD_DIR)/,$(EXAMPLES))
GENERATED_C := $(addsuffix .c,$(BINS))

.PHONY: all clean check-oracle print-config
.SECONDARY: $(COMMON_C) $(GENERATED_C)

all: check-oracle $(BINS)

print-config:
	@echo "ORACLE_HOME=$(ORACLE_HOME)"
	@echo "PROC=$(PROC)"
	@echo "PROC_INCLUDE=$(PROC_INCLUDE)"
	@if [ -n "$$ORA_DB" ]; then echo "ORA_DB=$$ORA_DB"; else echo "ORA_DB=<unset>"; fi
	@if [ -n "$$ORA_USER" ]; then echo "ORA_USER=<set>"; else echo "ORA_USER=<unset>"; fi
	@if [ -n "$$ORA_PASS" ]; then echo "ORA_PASS=<set>"; else echo "ORA_PASS=<unset>"; fi

check-oracle:
	@test -d "$(ORACLE_HOME)" || (echo "ERROR: ORACLE_HOME=$(ORACLE_HOME) neexistuje." >&2; exit 1)
	@test -x "$(PROC)" || (echo "ERROR: nenalezen Pro*C precompiler v $(PROC)." >&2; exit 1)
	@test -n "$$ORA_USER" || (echo "ERROR: chybi ORA_USER. Nejdrive nactete env.sh nebo pouzijte build.sh/playbook.sh." >&2; exit 1)
	@test -n "$$ORA_PASS" || (echo "ERROR: chybi ORA_PASS. Nejdrive nactete env.sh nebo pouzijte build.sh/playbook.sh." >&2; exit 1)
	@test -n "$$ORA_DB" || (echo "ERROR: chybi ORA_DB. Nejdrive nactete env.sh nebo pouzijte build.sh/playbook.sh." >&2; exit 1)

$(BUILD_DIR):
	@$(MKDIR_P) $(BUILD_DIR)

$(PROC_CFG): | $(BUILD_DIR)
	@printf '%s\n' \
	  'PARSE=FULL' \
	  'CODE=ANSI_C' \
	  'SQLCHECK=SEMANTICS' \
	  'LINES=YES' \
	  'INCLUDE=($(PROC_INCLUDE))' > $(PROC_CFG)

define proc_compile
	@tmp_cfg="$$(mktemp "$(PROC_RUNTIME_CFG_DIR)/proc.XXXXXX.cfg")"; \
	chmod 600 "$$tmp_cfg"; \
	cat "$(PROC_CFG)" > "$$tmp_cfg"; \
	printf '%s\n' "userid=$$ORA_USER/$$ORA_PASS@$$ORA_DB" >> "$$tmp_cfg"; \
	cleanup() { rm -f "$$tmp_cfg"; }; \
	trap cleanup EXIT INT TERM; \
	"$(PROC)" config="$$tmp_cfg" iname="$1" oname="$2"
endef

$(COMMON_C): $(COMMON_PC) $(PROC_CFG) | $(BUILD_DIR)
	$(call proc_compile,$<,$@)

$(COMMON_O): $(COMMON_C)
	$(CC) -c $< $(CFLAGS) -o $@

$(BUILD_DIR)/%.c: $(SRC_DIR)/%/main.pc $(PROC_CFG) | $(BUILD_DIR)
	@echo ""
	@echo -e "\e[1;34mBuild $(BUILD_DIR)/$*\e[0m"
	@echo -e "\e[1;34m############################################################\e[0m"
	$(call proc_compile,$<,$@)

$(BUILD_DIR)/%: $(BUILD_DIR)/%.c $(COMMON_O)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	@echo ""

clean:
	$(RM) $(BUILD_DIR)
