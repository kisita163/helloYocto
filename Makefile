BINARY_NAME:= hello

all: $(BINARY_NAME)

# $@ target
# $< first dependency
# $^ all dependencies
# $? all dependencies more recent than the target

COMPILER_REPOSITORY := /home/$(USER)/mdm9628_tools
COMPILER_PREFIX     := arm-oe-linux-gnueabi/arm-oe-linux-gnueabi-

CC      := $(COMPILER_REPOSITORY)/toolchain/usr/bin/$(COMPILER_PREFIX)gcc
SYSROOT := $(COMPILER_REPOSITORY)/sysroot
CFLAGS  := --sysroot=$(SYSROOT) -Dposix -ggdb -O2 -Wall -Werror -Wlogical-op -Wtype-limits -Wsign-conversion -Wsign-compare -Wshadow -Wpointer-arith -Wstrict-prototypes -I .
LDFLAGS := --sysroot=$(SYSROOT) -lpthread

$(BINARY_NAME): $(BINARY_NAME).o
	$(CC) $(LDFLAGS) $^ -o $@

$(BINARY_NAME).o: $(BINARY_NAME).c
	$(CC) $(CFLAGS) -c $<

clean:
	@rm -f $(BINARY_NAME)
	@find . -name \*~ -print | xargs rm -rf
	@find . -name \*.o -print | xargs rm -rf

adb_shell_enable:
	adb wait-for-device
	adb push ../adb_credentials /var/run/

install: $(BINARY_NAME) adb_shell_enable
	@echo Copying to target
	adb push $(BINARY_NAME) /cache

run: install adb_shell_enable
	@echo Starting $(BINARY_NAME) on the target
	adb shell "killall $(BINARY_NAME)"
	adb shell "/cache/$(BINARY_NAME)"

gdbsetup:
	if [ ! -f /home/$(USER)/.gdbinit ] ; then cp gdbinit_le920a4 /home/$(USER)/.gdbinit ; fi

gdbserver: adb_shell_enable install
	@echo Enable ADB port forwarding
	adb forward tcp:1234 tcp:1234
	@echo Starting gdbserver on the target
	adb shell "killall gdbserver"
	adb shell "killall $(BINARY_NAME)"
	adb shell "gdbserver hostname:1234 /cache/$(BINARY_NAME)" &
	sleep 1

gdb: install gdbsetup gdbserver
	@echo Starting host gdb
	$(COMPILER_REPOSITORY)/toolchain/usr/bin/$(COMPILER_PREFIX)gdb $(BINARY_NAME)

cgdb: install gdbsetup gdbserver
	@echo Starting host debugger cgdb
	cgdb -d $(COMPILER_REPOSITORY)/toolchain/usr/bin/$(COMPILER_PREFIX)gdb $(BINARY_NAME)

ddd: install gdbsetup gdbserver
	@echo Starting host debugger ddd
	ddd --debugger $(COMPILER_REPOSITORY)/toolchain/usr/bin/$(COMPILER_PREFIX)gdb $(BINARY_NAME)

nemiver: install gdbsetup gdbserver
	@echo Starting host debugger nemiver
	nemiver --gdb-binary=$(COMPILER_REPOSITORY)/toolchain/usr/bin/$(COMPILER_PREFIX)gdb $(BINARY_NAME)

.PHONY: clean
