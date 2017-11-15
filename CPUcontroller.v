module CPUcontroller(instruction, ALU0, ALU1, ALU2, ALU3, mux1, mux2, mux3, op, PCmux);
	input [31:0] instruction;
	output [2:0] ALU0, ALU1, ALU2, ALU3;
	output mux1, op;
	output [1:0] mux2, mux3, PCmux;
	
	wire [25:0] address;
	wire [15:0] immediate;
	wire [5:0] opcode, funct;
	wire [4:0] rs, rt, rd, shamt;
	
	assign opcode = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign shamt = instruction[10:6];
	assign funct = instruction[5:0];
	assign immediate = instruction[15:0];
	assign address = instruction[25:0];
	