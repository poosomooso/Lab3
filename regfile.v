//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

`include "multiplexer.v"
`include "register.v"
`include "decoders.v"

module regfile
(
output[31:0]	ReadData1,		// Contents of first register read
output[31:0]	ReadData2,		// Contents of second register read
output[1023:0]	AllOutputs,
input[31:0]		WriteData,		// Contents to write to register
input[4:0]		ReadRegister1,	// Address of first register to read
input[4:0]		ReadRegister2,	// Address of second register to read
input[4:0]		WriteRegister,	// Address of register to write
input			RegWrite,		// Enable writing of register when High
input			Clk				// Clock (Positive Edge Triggered)
);


//outputs
wire[31:0] reg0out, reg1out, reg2out, reg3out, reg4out, 
	reg5out, reg6out, reg7out, reg8out, reg9out,
	reg10out, reg11out, reg12out, reg13out, reg14out, 
	reg15out, reg16out, reg17out, reg18out, reg19out,
	reg20out, reg21out, reg22out, reg23out, reg24out, 
	reg25out, reg26out, reg27out, reg28out, reg29out,
	reg30out, reg31out;

assign AllOutputs[1023:0] = {
reg31out, reg30out, reg29out, reg28out, 
reg27out, reg26out, reg25out, reg24out, 
reg23out, reg22out, reg21out, reg20out, 
reg19out, reg18out, reg17out, reg16out, 
reg15out, reg14out, reg13out, reg12out, 
reg11out, reg10out, reg9out, reg8out, 
reg7out, reg6out, reg5out, reg4out, 
reg3out, reg2out, reg1out, reg0out };


// enable writes
wire[31:0] regwrenable;
decoder1to32 wrdecoder (regwrenable, RegWrite, WriteRegister);

// registers
register32zero reg0 (reg0out, WriteData, regwrenable[0], Clk);
register32 reg1 (reg1out, WriteData, regwrenable[1], Clk);
register32 reg2 (reg2out, WriteData, regwrenable[2], Clk);
register32 reg3 (reg3out, WriteData, regwrenable[3], Clk);
register32 reg4 (reg4out, WriteData, regwrenable[4], Clk);
register32 reg5 (reg5out, WriteData, regwrenable[5], Clk);
register32 reg6 (reg6out, WriteData, regwrenable[6], Clk);
register32 reg7 (reg7out, WriteData, regwrenable[7], Clk);
register32 reg8 (reg8out, WriteData, regwrenable[8], Clk);
register32 reg9 (reg9out, WriteData, regwrenable[9], Clk);
register32 reg10 (reg10out, WriteData, regwrenable[10], Clk);
register32 reg11 (reg11out, WriteData, regwrenable[11], Clk);
register32 reg12 (reg12out, WriteData, regwrenable[12], Clk);
register32 reg13 (reg13out, WriteData, regwrenable[13], Clk);
register32 reg14 (reg14out, WriteData, regwrenable[14], Clk);
register32 reg15 (reg15out, WriteData, regwrenable[15], Clk);
register32 reg16 (reg16out, WriteData, regwrenable[16], Clk);
register32 reg17 (reg17out, WriteData, regwrenable[17], Clk);
register32 reg18 (reg18out, WriteData, regwrenable[18], Clk);
register32 reg19 (reg19out, WriteData, regwrenable[19], Clk);
register32 reg20 (reg20out, WriteData, regwrenable[20], Clk);
register32 reg21 (reg21out, WriteData, regwrenable[21], Clk);
register32 reg22 (reg22out, WriteData, regwrenable[22], Clk);
register32 reg23 (reg23out, WriteData, regwrenable[23], Clk);
register32 reg24 (reg24out, WriteData, regwrenable[24], Clk);
register32 reg25 (reg25out, WriteData, regwrenable[25], Clk);
register32 reg26 (reg26out, WriteData, regwrenable[26], Clk);
register32 reg27 (reg27out, WriteData, regwrenable[27], Clk);
register32 #(.init(32'h1800)) reg28 (reg28out, WriteData, regwrenable[28], Clk);
register32 #(.init(32'h3ffc)) reg29 (reg29out, WriteData, regwrenable[29], Clk);
register32 reg30 (reg30out, WriteData, regwrenable[30], Clk);
register32 reg31 (reg31out, WriteData, regwrenable[31], Clk);


// reads
mux32to1by32 read1Mux (ReadData1, ReadRegister1, 
	reg0out, reg1out, reg2out, reg3out, reg4out, 
	reg5out, reg6out, reg7out, reg8out, reg9out,
	reg10out, reg11out, reg12out, reg13out, reg14out, 
	reg15out, reg16out, reg17out, reg18out, reg19out,
	reg20out, reg21out, reg22out, reg23out, reg24out, 
	reg25out, reg26out, reg27out, reg28out, reg29out,
	reg30out, reg31out);

mux32to1by32 read2Mux (ReadData2, ReadRegister2, 
	reg0out, reg1out, reg2out, reg3out, reg4out, 
	reg5out, reg6out, reg7out, reg8out, reg9out,
	reg10out, reg11out, reg12out, reg13out, reg14out, 
	reg15out, reg16out, reg17out, reg18out, reg19out,
	reg20out, reg21out, reg22out, reg23out, reg24out, 
	reg25out, reg26out, reg27out, reg28out, reg29out,
	reg30out, reg31out);

endmodule