REPLACE_EXE = replace() \
	{ \
	  local src cmd; \
	  src=$$(printf "%s\n" $< $> | head -n 1); \
	  cmd=$$(basename $@ .usage); \
	  sed "s/@$$1@/$$cmd/g" $$src > $@; \
	}; replace

all:

clean:
	rm -rf build

BUILD=build/.dir

# set the time to something really so that the symlinks are never out of date
$(BUILD):
	mkdir -p $$(dirname $@)
	touch -t 198001010101 $@

USAGE != ls *.usage
USAGE := $(USAGE:%=build/%)
all: $(USAGE)

$(USAGE): $(BUILD)
	SRC=$$(basename $@); test -f $$SRCS && ln -s ../$$SRC $@

PIP != echo build/pip{,2,3,3.4,3.3,2.7}.usage
all: $(PIP)
$(PIP): templates/pip.usage $(BUILD)
	$(REPLACE_EXE) pip

NOSE != echo build/nosetests{,-{2.7,3.4}}.usage
all: $(NOSE)
$(NOSE): templates/nosetests.usage $(BUILD)
	$(REPLACE_EXE) nosetests

IPYTHON != echo build/ipython{,2,3}.usage
all: $(IPYTHON)
$(IPYTHON): templates/ipython.usage $(BUILD)
	$(REPLACE_EXE) ipython
