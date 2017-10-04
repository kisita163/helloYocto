Sample makefile for LE920A4 native binary building

Prerequisite:
    - Update makefile to specify cross compiler directory:
    COMPILER_REPOSITORY := /home/$(USER)/mdm9628_tools
    - Install and configure ADB
    - Connect target with USB cable

Makefile targets:
    make clean    clear previous build
    make          cross compile binary
    make install  cross compile binary, then copy it to the target
    make run      cross compile binary, copy it to the target, and run it
    make gdb      cross compile binary, copy it to the target, and remote debug it with target gdbserver and host gdb
    make cgdb     cross compile binary, copy it to the target, and remote debug it with target gdbserver and host cgdb
    make ddd      cross compile binary, copy it to the target, and remote debug it with target gdbserver and host ddd
    make nemiver  cross compile binary, copy it to the target, and remote debug it with target gdbserver and host nemiver
