module CPUcontroller(instruction, clk, ALU0, ALU1, ALU2, ALU3, mux1, mux2, mux3, op, PCmux);
	input [31:0] instruction;
	output [2:0] ALU0, ALU1, ALU2, ALU3;
	output mux1, op;
	output [1:0] mux2, mux3, PCmux;
	
	wire [25:0] address;
	wire [15:0] immediate;
	wire [5:0] opcode, funct;
	wire [4:0] rs, rt, rd, shamt;
	reg [3:0] action_type;
	reg [5:0] counter;
	
	assign opcode = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign shamt = instruction[10:6];
	assign funct = instruction[5:0];
	assign immediate = instruction[15:0];
	assign address = instruction[25:0];
	
	always @ (posedge clk)
		if (counter == 0 && {Conditions for J}) begin
			counter <= 1;
			action_type <= 4'b0001;
		end else if (counter == 0 && {Conditions for BNE}) begin
			counter <= 1;
			action_type <= 4'b0010;
		end else if (counter == 0 && {Conditions for JAL}) begin
			counter <= 1;
			action_type <= 4'b0011;
		end else if (counter == 0 && {Conditions for Add}) begin
			counter <= 1;
			action_type <= 4'b0100;
		end else if (counter == 0 && {Conditions for Addi}) begin
			counter <= 1;
			action_type <= 4'b0101;
		end else if (counter == 0 && {Conditions for Xori}) begin
			counter <= 1;
			action_type <= 4'b0110;
		end else if (counter == 0 && {Conditions for LW}) begin
			counter <= 1;
			action_type <= 4'b0111;
		end else if (counter == 0 && {Conditions for SW}) begin
			counter <= 1;
			action_type <= 4'b1000;
		end else if (counter == 0 && {Conditions for JR}) begin
			counter <= 1;
			action_type <= 4'b1001;
		end else if (counter == 0 && {Conditions for Sub}) begin
			counter <= 1;
			action_type <= 4'b1010;
		end else if (counter == 0 && {Conditions for SLT}) begin
			counter <= 1;
			action_type <= 4'b1011;
		end else if (counter == {ceiling}) begin
			counter <= 0;
			action_type <= 0;
		