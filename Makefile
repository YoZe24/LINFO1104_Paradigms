OZC = ozc
OZENGINE = ozengine

DBPATH= database/database.txt
NOGUI= "--nogui"
ANS= autoplay/test_answers.txt

SRC=$(wildcard *.oz)
OBJ=$(SRC:.oz=.ozf)

OZFLAGS = --nowarnunused

all: $(OBJ)

run: all
	@echo RUN program.ozf
	@$(OZENGINE) program.ozf --db $(DBPATH) $(NOGUI) --ans $(ANS)

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
