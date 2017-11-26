
/*

add:	000000 100000
addi:	001000
sub:	000000 100011
j		000010
jal:	000011
jr:		000000 001000
bne:	000101
xori:	001110
sw:		101011
lw:		100011
slt:	000000 101010

*/

`include "alu.v"

`define arith 	6'b000000
`define addi 	6'b001000
`define j 		6'b000010
`define jal		6'b000011
`define bne		6'b000101
`define xori	6'b001110
`define sw		6'b101011
`define lw		6'b100011

`define add 	6'b100000
`define sub 	6'b100010
`define jr 		6'b001000
`define slt 	6'b101010


module CPUcontroller (
	input [5:0] opcode, funct,
	output reg [2:0] ALU3, 
	output reg dataWriteMuxSlt, writeback, notBNE, // writeback chooses where the output goes
	output reg [1:0] operand2MuxSlt, regWriteAddrSlt, PCmux,
	output reg reg_we, dm_we
);
	
	//for adders
	// ALU0 <= `opADD; 
	// ALU1 <= `opADD;
	// ALU2 <= `opADD;

	always @ (*) begin

	$display("opcode: %b",opcode);
	$display("funct: %b",funct);
		casex(opcode)
			`addi: begin
				dataWriteMuxSlt <= 1'd1;
				operand2MuxSlt <= 2'd2;
				regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd2;
				notBNE<=1'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd0;
				ALU3 <= `opADD;
			end
			`j: begin
				// dataWriteMuxSlt <= 1'd1;
				// operand2MuxSlt <= 2'd2;
				// regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd1;
				notBNE<=1'd1;
				reg_we <= 1'd0;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				// ALU3 <= opADD;
			end
			`jal: begin
				dataWriteMuxSlt <= 1'd0;
				// operand2MuxSlt <= 2'd2;
				regWriteAddrSlt <= 2'd2;
				PCmux <= 2'd1;
				notBNE<=1'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				// ALU3 <= opADD;
			end
			`bne: begin
				// dataWriteMuxSlt <= 1'd1;
				// operand2MuxSlt <= 2'd2;
				// regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd2;
				notBNE<=1'd0;
				reg_we <= 1'd0;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				ALU3 <= `opSUB;
			end
			`xori: begin
				dataWriteMuxSlt <= 1'd1;
				operand2MuxSlt <= 2'd1;
				regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd2;
				notBNE<=1'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd0;
				ALU3 <= `opXOR;
			end
			`sw: begin
				// dataWriteMuxSlt <= 1'd1;
				operand2MuxSlt <= 2'd2;
				// regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd2;
				notBNE<=1'd1;
				reg_we <= 1'd0;
				dm_we<= 1'd1;
				// writeback <= 1'd0;
				ALU3 <= `opADD;
			end
			`lw: begin
				dataWriteMuxSlt <= 1'd1;
				operand2MuxSlt <= 2'd2;
				regWriteAddrSlt <= 2'd0;
				PCmux <= 2'd2;
				notBNE<=1'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd1;
				ALU3 <= `opADD;
			end
			`arith: begin
				case(funct)
					`add: begin
						dataWriteMuxSlt <= 1'd1;
						operand2MuxSlt <= 2'd0;
						regWriteAddrSlt <= 2'd1;
						PCmux <= 2'd2;
						notBNE<=1'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= `opADD;
					end
					`sub: begin
						dataWriteMuxSlt <= 1'd1;
						operand2MuxSlt <= 2'd0;
						regWriteAddrSlt <= 2'd1;
						PCmux <= 2'd2;
						notBNE<=1'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= `opSUB;
					end
					`jr: begin
						// dataWriteMuxSlt <= 1'd1;
						// operand2MuxSlt <= 2'd2;
						// regWriteAddrSlt <= 2'd0;
						PCmux <= 2'd0;
						notBNE<=1'd1;
						reg_we <= 1'd0;
						dm_we<= 1'd0;
						// writeback <= 1'd0;
						// ALU3 <= opADD;
					end
					`slt: begin
						dataWriteMuxSlt <= 1'd1;
						operand2MuxSlt <= 2'd0;
						regWriteAddrSlt <= 2'd1;
						PCmux <= 2'd2;
						notBNE<=1'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= `opSLT;
					end
				endcase

			end
			default: begin
				reg_we <= 1'd0;
				dm_we<= 1'd0;
			end
		endcase
		// $display("dataWriteMuxSlt : %b",dataWriteMuxSlt);
		// $display("operand2MuxSlt : %b",operand2MuxSlt);
		// $display("regWriteAddrSlt : %b",regWriteAddrSlt);
		// $display("PCmux : %b",PCmux);
		// $display("notBNE : %b",notBNE);
		// $display("reg_we : %b",reg_we);
		// $display("dm_we : %b",dm_we);
		// $display("writeback : %b",writeback);
		// $display("ALU3 : %b",ALU3);
	end
		
endmodule