
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
`define arith 	6'b000000
`define addi 	6'b001000
`define j 		6'b000010
`define jal		6'b000011
`define bne		6'b000101
`define xori	6'b001110
`define sw		6'b101011
`define lw		6'b100011

`define add 	6'b100000
`define sub 	6'b100011
`define jr 		6'b001000
`define slt 	6'b101010


module CPUcontroller (
	input [5:0] opcode, funct,
	output reg [2:0] ALU0, ALU1, ALU2, ALU3,
	output reg mux1, writeback, // writeback chooses where the output goes
	output reg [1:0] mux2, mux3, PCmux,
	output reg reg_we, dm_we
);
	
	//for adders
	// ALU0 <= `opADD; 
	// ALU1 <= `opADD;
	// ALU2 <= `opADD;

	always @ (*) begin

		case(opcode)
			`addi: begin
				mux1 <= 1'd1;
				mux2 <= 2'd2;
				mux3 <= 2'd0;
				PCmux <= 2'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd0;
				ALU3 <= opADD;
			end
			`j: begin
				// mux1 <= 1'd1;
				// mux2 <= 2'd2;
				// mux3 <= 2'd0;
				PCmux <= 2'd2;
				reg_we <= 1'd0;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				// ALU3 <= opADD;
			end
			`jal: begin
				mux1 <= 1'd0;
				// mux2 <= 2'd2;
				// mux3 <= 2'd0;
				PCmux <= 2'd2;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				// ALU3 <= opADD;
			end
			`bne: begin
				// mux1 <= 1'd1;
				// mux2 <= 2'd2;
				// mux3 <= 2'd0;
				PCmux <= 2'd2;
				reg_we <= 1'd0;
				dm_we<= 1'd0;
				// writeback <= 1'd0;
				ALU3 <= opSUB;
			end
			`xori: begin
				mux1 <= 1'd1;
				mux2 <= 2'd2;
				mux3 <= 2'd1;
				PCmux <= 2'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd0;
				ALU3 <= opXOR;
			end
			`sw: begin
				// mux1 <= 1'd1;
				mux2 <= 2'd2;
				// mux3 <= 2'd0;
				PCmux <= 2'd1;
				reg_we <= 1'd0;
				dm_we<= 1'd1;
				// writeback <= 1'd0;
				ALU3 <= opADD;
			end
			`lw: begin
				mux1 <= 1'd1;
				// mux2 <= 2'd2;
				mux3 <= 2'd0;
				PCmux <= 2'd1;
				reg_we <= 1'd1;
				dm_we<= 1'd0;
				writeback <= 1'd1;
				ALU3 <= opADD;
			end
			`arith: begin
				case(funct)
					`add: begin
						mux1 <= 1'd1;
						mux2 <= 2'd0;
						mux3 <= 2'd1;
						PCmux <= 2'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= opADD;
					end
					`sub: begin
						mux1 <= 1'd1;
						mux2 <= 2'd0;
						mux3 <= 2'd1;
						PCmux <= 2'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= opSUB;
					end
					`jr: begin
						// mux1 <= 1'd1;
						// mux2 <= 2'd2;
						// mux3 <= 2'd0;
						PCmux <= 2'd0;
						reg_we <= 1'd0;
						dm_we<= 1'd0;
						// writeback <= 1'd0;
						// ALU3 <= opADD;
					end
					`slt: begin
						mux1 <= 1'd1;
						mux2 <= 2'd0;
						mux3 <= 2'd1;
						PCmux <= 2'd1;
						reg_we <= 1'd1;
						dm_we<= 1'd0;
						writeback <= 1'd0;
						ALU3 <= opSLT;
					end
				endcase

			end
		endcase
	end
		
endmodule