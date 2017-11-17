#!/bin/bash

if [ $1 == "test" ]; then
	iverilog -o alu.t.o alu.t.v
	./alu.t.o
	iverilog -o instructiondecoder.t.o instructiondecoder.t.v
	./instructiondecoder.t.o
	iverilog -o regfile.t.o regfile.t.v
	./regfile.t.o
	iverilog -o signextend.t.o signextend.t.v
	./signextend.t.o
elif [ $1 == "cpu" ]; then
	iverilog -o cpu.t.o cpu.t.v
	./cpu.t.o
fi
