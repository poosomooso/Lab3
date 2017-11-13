`include "instructiondecoder.v"

module DecoderTester();

reg[31:0] instruction;
wire[5:0] opcode;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm;
wire[25:0] addr;
wire[5:0] funct;

InstructionDecoder dut(instruction, opcode, rs, rt, rd, imm, addr, funct);

initial begin
instruction = 32'b00000010101001111110100000100000; #100
if ((opcode != 6'b000000) || (rs != 5'b10101) || (rt != 5'b00111) || (rd != 5'b11101) || (funct != 6'b100000))
	$display("test 1 failed");

instruction = 32'b00100010101001111110101100100011; #100
if ((opcode != 6'b001000) || (rs != 5'b10101) || (rt != 5'b00111) || (imm != 16'b1110101100100011))
	$display("test 2 failed");

instruction = 32'b00001010101001111110101100100011; #100
if ((opcode != 6'b000010) || (addr != 35'b10101001111110101100100011))
	$display("test 3 failed");

end

endmodule