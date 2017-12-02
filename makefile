cpu: cpu.t.v
	iverilog -o cpu.t.o cpu.t.v

test: alu.t.v instructiondecoder.t.v regfile.t.v signextend.t.v datamemory.t.v
	iverilog -o alu.t.o alu.t.v
	iverilog -o instructiondecoder.t.o instructiondecoder.t.v
	iverilog -o regfile.t.o regfile.t.v
	iverilog -o signextend.t.o signextend.t.v
	iverilog -o datamemory.t.o datamemory.t.v

clean:
	rm *.o
