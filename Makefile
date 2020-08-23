# Makefile

# rem:
# $@ is a macro that refers to the target
# $< is a macro that refers to the first dependency
# $^ is a macro that refers to all dependencies
# $+ is like $^ but exactly won't ignore dublicates

SRC     := ./Buildup
BUILD   := ./build
OBJ		:= $(BUILD)/obj
BIN		:= $(BUILD)/bin
SRCS    := $(wildcard $(SRC)/*.S)
OBJS    := $(patsubst $(SRC)/%.S,$(OBJ)/%.o,$(SRCS))
EXES    := $(patsubst $(SRC)/%.S,$(BIN)/%,$(SRCS))

.PHONY: all clean

all: $(EXES)

$(BIN)/%: $(OJB)/%.o | $(BIN)
	gcc -o $@ $<

$(OBJ)/%.o: $(SRC)/%.S | $(OBJ)
	as -o $@ $<

$(OBJ) $(BIN):					# Dirs need to be made
	mkdir $(BUILD)
    mkdir $@

clean:
	rm -vf build/*
