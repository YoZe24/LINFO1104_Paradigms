OZC = ozc
OZENGINE = ozengine

DBPATH= database/database.txt
NOGUI= "--nogui" # set this variable to --nogui if you don't want the GUI

SRC=$(wildcard *.oz)
OBJ=$(SRC:.oz=.ozf)

OZFLAGS = --nowarnunused

all: $(OBJ)

run: all
	@echo RUN program.ozf
	@$(OZENGINE) program.ozf --db $(DBPATH) $(NOGUI)

run_example: all
	@echo RUN example/Example.ozf
	@$(OZENGINE) example/Example.ozf --db $(DBPATH) $(NOGUI)

%.ozf: %.oz
	@echo OZC $@
	@$(OZC) $(OZFLAGS) -c $< -o $@

.PHONY: clean

clean:
	@echo rm $(OBJ)
	@rm -rf $(OBJ)
