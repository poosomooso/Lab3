`include "dff.v"
`include "instruction_memory.v"
`include "instructiondecoder.v"
`include "CPUcontroller.v"
`include "adder.v"
`include "alu.v"
`include "datamemory.v"
`include "signextend.v"
`include "regfile.v"


module CPU (
	input clk,
	output[1023:0] registers
);

reg we_on = 0'b1;
reg we_off = 0'b0;

// pc & instruction mem
wire[31:0] pc_next, pc_curr;
wire[31:0] instruction;
// instruction decoder
wire[31:0] instruction;
wire[5:0] opcode;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm;
wire[25:0] addr;
wire[5:0] funct;

dff pc #(32) (
	.clk(clk),   
	.ce(we_on),
	.dataIn(pc_next),
	.dataOut(pc_curr));

wire [31:0] alu1Out;	
	
ALU alu1 (
	.result(alu1Out),
	.carryout(oneBitThrowaway),
	.zero(oneBitThrowaway),
	.overflow(oneBitThrowaway),
	.operandA(pc_curr),
	.operandB(32'b4),
	.command(alu1Slt));

instruction_memory instr_mem (
	.regWE(we_off),
	.Addr(pc_curr),
	.DataIn(32'b0),
	.DataOut(instruction));

instructiondecoder instr_decoder (
	.instruction(instruction),
	.opcode(opcode),
	.rs(rs),
	.rt(rt),
	.rd(rd),
	.imm(imm),
	.addr(addr),
	.funct(funct));

// controller
wire [2:0] alu0Slt, alu1Slt, alu2Slt, alu3Slt;
wire mux1, writeback;
wire [1:0] mux2, mux3, PCmux;
wire reg_we, dm_we;

CPUcontroller controller (
	.opcode(opcode),
	.funct(funct),
	.ALU0(alu0Slt),
	.ALU1(alu1Slt),
	.ALU2(alu2Slt),
	.ALU3(alu3Slt),
	.mux1(mux1),
	.mux2(mux2),
	.mux3(mux3),
	.writeback(writeback),
	.PCmux(PCmux),
	.reg_we(reg_we),
	.dm_we(dm_we));

wire[31:0] ra;
wire[31:0] rb;
wire[31:0] rw;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[4:0] throwaway;

fourToOneMux #(.DATA_WIDTH(5)) multiplexer3(
	.out(WriteRegister),
	.in1(rt),
	.in2(rd),
	//.in3(WHAT GOES HERE?)
	.in4(throwaway),
	.slt(mux3));

twoToOneMux multiplexer1(
	.out(WriteData),
	.in1(alu3Out),
	.in2(writebackOut),
	.slt(mux1));
	
regfile register_file (
	.ReadData1(ReadData1),
	.ReadData2(ReadData2),
	.AllOutputs(registers),
	.WriteData(WriteData),
	.ReadRegister1(rs),
	.ReadRegister2(rt),
	.WriteRegister(WriteRegister),
	.RegWrite(reg_we),
	.Clk(clk));
	
twoToOneMux opMultiplexer (
	.out(opOut),
	.in1(alu3Out),
	.in2(dmOut),
	.slt(writebackOut));
	
wire [31:0] thirtyTwoBitThrowaway;
wire [31:0] signExtendImmediate;
	
fourToOneMux multiplexer2 (
	.out(mux2Out),
	.in1(ReadData2),
	.in2(immediate),
	.in3(signExtendImmediate),
	.in4(thirtyTwoBitThrowaway),
	.slt(mux2));
	
wire oneBitThrowaway;
wire [2:0] alu3SLT;

ALU alu2 (
	.result(alu2Out),
	.carryout(oneBitThrowaway),
	.zero(mux0),
	.overflow(oneBitThrowaway),
	.operandA(ReadData1),
	.operandB(mux2Out),
	.command(alu2SLT));

datamemory dm (
	.clk(clk),
	.dataOut(dmOut),
	.address(alu3Out),
	.writeEnable(dm_we),
	.dataIn(ReadData2));
	
signextend signExtender (
	.a(imm),
	.result(signExtendImmediate));
	
wire [33:0] signExtendImmediate;
	
assign concatSignExtend = {signExtendImmediate, 2'b00);

wire [33:0] mux0Out;

twoToOneMux multiplexer0 (
	.out(mux0Out),
	.in1(concatSignExtend),
	.in2(34'b0),
	.slt(mux0));
	
wire [31:0] alu0Out;
	
ALU alu0 (
	.result(alu0Out),
	.carryout(oneBitThrowaway),
	.zero(oneBitThrowaway),
	.overflow(oneBitThrowaway),
	.operandA(alu1Out),
	.operandB(mux0Out),
	.command(alu0Slt));
	
assign pcMuxIn2 = {alu1Out, instruction[25:0], 2'b0};
	
fourToOneMux pcMux (
	.out(pcMuxOut),
	.in1(ReadData1),
	.in2(pcMuxIn2),
	.in3(alu0Out),
	.in4(thirtyTwoBitThrowaway),
	.slt(PCMux));
	
ALU alu3 (
	.result(alu3Out),
	.carryout(oneBitThrowaway),
	.zero(oneBitThrowaway),
	.overflow(oneBitThrowaway),
	.operandA(32'b4),
	.operandB(alu1Out),
	.command(alu3Slt));

endmodule