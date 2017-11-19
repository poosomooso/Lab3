`define rtype 6'd0
`define jtype 6'b00001z

// 001000 addi
// 000101 bne
// 100011 lw
// 101011 sw
// 001110 xori

module InstructionDecoder (
	input[31:0] instruction,
	output reg[5:0] opcode,
	output reg[4:0] rs,
	output reg[4:0] rt,
	output reg[4:0] rd,
	output reg[15:0] imm,
	output reg[25:0] addr,
	output reg[5:0] funct
);

always @(instruction) begin
	$display("instruction: %h",instruction);

	opcode = instruction[31:26];

	casex(opcode)
		`rtype: begin
			rs = instruction[25:21];
			rt = instruction[20:16];
			rd = instruction[15:11];
			funct = instruction[5:0];
		end
		`jtype: begin
			addr = instruction[25:0];
		end
		default: begin
			rs = instruction[25:21];
			rt = instruction[20:16];
			imm = instruction[15:0];
		end
	endcase
end

endmodule