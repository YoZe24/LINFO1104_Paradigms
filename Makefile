OZC = ozc
OZENGINE = ozengine

DBPATH= database/database.txt
NOGUI= "--nogui" # --nogui
ANS= autoplay/test_answers.txt

SRC=$(wildcard *.oz)
OBJ=$(SRC:.oz=.ozf)

OZFLAGS = --nowarnunused

all: $(OBJ)

run_basic: all
	@echo RUN program_basic.ozf
	@$(OZENGINE) program_basic.ozf --db $(DBPATH) $(NOGUI) --ans $(ANS)

run_extensions: all
	@echo RUN program_extensions.ozf
	@$(OZENGINE) program_extensions.ozf --db $(DBPATH) $(NOGUI) --ans $(ANS)

run_example: all
	@echo RUN example_code/Example.ozf
	@$(OZENGINE) example_code/Example.ozf --db $(DBPATH) $(NOGUI)

%.ozf: %.oz
	@echo OZC $@
	@$(OZC) $(OZFLAGS) -c $< -o $@

.PHONY: clean

clean:
	@echo rm $(OBJ)
	@rm -rf $(OBJ)
