`include "dff.v"
`include "instruction_memory.v"
`include "instructiondecoder.v"
`include "CPUcontroller.v"
`include "adder.v"
`include "datamemory.v"
`include "signextend.v"
`include "regfile.v"


module CPU (
	input clk,
	output [1023:0] registers
	// output reg[31:0] registers[1023:0]
);

reg we_on = 1'b1;
reg we_off = 1'b0;

wire[31:0] pc_next, pc_curr;
wire[31:0] instruction;

wire[5:0] opcode;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm;
wire[25:0] addr;
wire[5:0] funct;

PCReg #(32) pc (
	.clk(clk),   
	.ce(we_on),
	.dataIn(pc_next),
	.dataOut(pc_curr));

wire [31:0] pcPlus4;
assign pcPlus4 = pc_curr + 4;

instruction_memory instrMem (
	.regWE(we_off),
	.Addr(pc_curr),
	.DataIn(32'b0),
	.DataOut(instruction));

InstructionDecoder instrDecoder (
	.instruction(instruction),
	.opcode(opcode),
	.rs(rs),
	.rt(rt),
	.rd(rd),
	.imm(imm),
	.addr(addr),
	.funct(funct));

wire [2:0] alu0op, alu1op, mainAluop, alu3op;
wire mux1, writeback, notBNE;
wire [1:0] mux2, mux3, PCmux;
wire reg_we, dm_we;

CPUcontroller controller (
	.opcode(opcode),
	.funct(funct),
	.ALU0(alu0op),
	.ALU1(alu1op),
	.ALU2(alu3op),
	.ALU3(mainAluop),
	.PCmux(PCmux),
	.notBNE(notBNE),
	.mux1(mux1),
	.mux2(mux2),
	.mux3(mux3),
	.writeback(writeback),
	.reg_we(reg_we),
	.dm_we(dm_we));

wire[31:0] dataA;
wire[31:0] dataB;
wire[31:0] dataWrite;
wire[31:0] writebackData;
wire[4:0] writeRegister;
wire[4:0] throwaway;

fourToOneMux #(.DATA_WIDTH(5)) dwRegIn(
	.out(writeRegister),
	.in1(rt),
	.in2(rd),
	.in3(5'd31), //for jal
	.in4(throwaway),
	.slt(mux3));

regfile registerFile (
	.ReadData1(dataA),
	.ReadData2(dataB),
	.AllOutputs(registers),
	.WriteData(dataWrite),
	.ReadRegister1(rs),
	.ReadRegister2(rt),
	.WriteRegister(writeRegister),
	.RegWrite(reg_we),
	.Clk(clk));

wire [31:0] thirtyTwoBitThrowaway;
wire [31:0] signExtendImmediate;
wire [31:0] zeroExtendImmediate;
assign zeroExtendImmediate = {16'b0, imm};
wire [31:0] operandB;
	
fourToOneMux operand2Mux (
	.out(operandB),
	.in1(dataB),
	.in2(zeroExtendImmediate),
	.in3(signExtendImmediate),
	.in4(thirtyTwoBitThrowaway),
	.slt(mux2));
	
wire oneBitThrowaway;
wire [2:0] alu3SLT;
wire [31:0] mainAluOut;
wire [31:0] dmOut;
wire offsetMuxSelect;

ALU mainAlu (
	.result(mainAluOut),
	.carryout(oneBitThrowaway),
	.zero(offsetMuxSelect),
	.overflow(oneBitThrowaway),
	.operandA(dataA),
	.operandB(operandB),
	.command(mainAluop));

datamemory #(
    .addresswidth(32),
    .depth(1023),
    .width(32)
    ) dm (
	.clk(clk),
	.dataOut(dmOut),
	.address(mainAluOut),
	.writeEnable(dm_we),
	.dataIn(dataB));
	
twoToOneMux opMultiplexer (
	.out(writebackData),
	.in1(mainAluOut),
	.in2(dmOut),
	.slt(writeback));

twoToOneMux dataWriteMux(
	.out(dataWrite),
	.in1(pcPlus8),
	.in2(writebackData),
	.slt(mux1));
	
signextend signExtender (
	.a(imm),
	.result(signExtendImmediate));
	
wire [31:0] concatSignExtend;
assign concatSignExtend = {signExtendImmediate[29:0], 2'b00};

wire [31:0] instrOffset;

twoToOneMux instrOffsetMux (
	.out(instrOffset),
	.in1(34'b0),
	.in2(concatSignExtend),
	.slt(offsetMuxSelect || notBNE));
	
wire [31:0] alu0Out;
	
wire [31:0] jumpAddr;
assign jumpAddr = {pcPlus4[31:28], instruction[25:0], 2'b0};
	
fourToOneMux pcMux (
	.out(pc_next),
	.in1(dataA),
	.in2(jumpAddr),
	.in3(pcPlus4 + instrOffset),
	.in4(thirtyTwoBitThrowaway),
	.slt(PCmux));
	
wire [31:0] pcPlus8;
assign pcPlus8 = pcPlus4 + 4;

endmodule