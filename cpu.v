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

dff pc #(32) (
	.clk(clk),   
	.ce(we_on),
	.dataIn(pc_next),
	.dataOut(pc_curr));

instruction_memory instr_mem (
	.regWE(we_off),
	.Addr(pc_curr),
	.DataIn(32'b0),
	.DataOut(instruction));

// instruction decoder
wire[31:0] instruction;
wire[5:0] opcode;
wire[4:0] rs;
wire[4:0] rt;
wire[4:0] rd;
wire[15:0] imm;
wire[25:0] addr;
wire[5:0] funct;

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
wire [2:0] ALU0, ALU1, ALU2, ALU3;
wire mux1, writeback;
wire [1:0] mux2, mux3, PCmux;
wire reg_we, dm_we;

CPUcontroller controller (
	.opcode(opcode),
	.funct(funct),
	.ALU0(ALU0),
	.ALU1(ALU1),
	.ALU2(ALU2),
	.ALU3(ALU3),
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

regfile register_file (
	.ReadData1(ReadData1),
	.ReadData2(ReadData2),
	.AllOutputs(registers),
	.WriteData(WriteData),
	.ReadRegister1(ReadRegister1),
	.ReadRegister2(ReadRegister2),
	.WriteRegister(WriteRegister),
	.RegWrite(reg_we),
	.Clk(clk));

endmodule