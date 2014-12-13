COMMANDS = $(shell ls *.usage | sed 's/.usage//')
COMMANDS += pip
COMMANDS += $(foreach py, 2 3 3.4 3.3 2.7, pip$(py))
COMMANDS += ipython
COMMANDS += $(foreach py,  2 3, ipython$(py))

TARGETS = $(foreach command, $(COMMANDS), build/$(command).usage)

all: $(TARGETS)

clean:
	rm -r build

build:
	mkdir -p build

define processtemplate
	sed "s/@$1@/$2/g" $< > $@
endef
define replaceversiontemplate
	$(call processtemplate,$1,$1$2)
endef

define pipusage
	$(call replaceversiontemplate,pip,$1)
endef

build/pip%.usage: templates/pip.usage | build
	$(call pipusage,$*)
build/pip.usage: templates/pip.usage | build
	$(call pipusage,)

define ipythonusage
	$(call replaceversiontemplate,ipython,$1)
endef

build/ipython%.usage: templates/ipython.usage | build
	$(call ipythonusage,$*)
build/ipython.usage: templates/ipython.usage | build
	$(call ipythonusage,)

build/%.usage: %.usage | build
	cp $< $@
