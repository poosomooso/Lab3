#!/bin/bash

if [ $1 == "test" ]; then
	make test
	./alu.t.o
	./instructiondecoder.t.o
	./regfile.t.o
	./signextend.t.o
elif [ $1 == "cpu" ]; then
	make cpu
	./cpu.t.o
fi
