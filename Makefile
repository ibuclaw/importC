# Use details from dmd/posix.mak
DMD_DIR=../dmd
include $(DMD_DIR)/src/osmodel.mak
DMD=$(DMD_DIR)/generated/$(OS)/$(BUILD)/$(MODEL)/dmd
ifeq (,$(BUILD))
BUILD=release
endif

IN_KEYWORDS = src/keywords.c.in
IN_HEADERS = $(wildcard src/stdc/*.h.in) \
	     $(wildcard src/sys/linux/*.h.in) \
	     $(wildcard src/sys/sys/linux/netinet/*.h.in) \
	     $(wildcard src/sys/sys/linux/sys/*.h.in) \
	     $(wildcard src/sys/posix/*.h.in) \
	     $(wildcard src/sys/sys/posix/arpa/*.h.in) \
	     $(wildcard src/sys/sys/posix/net/*.h.in) \
	     $(wildcard src/sys/sys/posix/netinet/*.h.in) \
	     $(wildcard src/sys/sys/posix/stdc/*.h.in) \
	     $(wildcard src/sys/sys/posix/sys/*.h.in) \
	     $(wildcard src/etc/*.h.in)
OUT_HEADERS = $(subst src/,generated/,$(patsubst %.h.in,%.c,$(IN_HEADERS)))
OUT_DIRECTORIES = $(sort $(dir $(OUT_HEADERS)))
TEST_RESULTS = $(patsubst %.c,%.o,$(OUT_HEADERS))

all: check
check: all-generated $(TEST_RESULTS)
all-generated: $(OUT_DIRECTORIES) $(OUT_HEADERS)

generated/%.c: $(IN_KEYWORDS) src/%.h.in
	cat $^ | gcc -E -P -x c -o $@ -

generated/%.o: generated/%.c
	$(DMD) -c -vcolumns $^ -of$@

$(OUT_DIRECTORIES):
	mkdir -pv $@

clean:
	rm -rfv ./generated
