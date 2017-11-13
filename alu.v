`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

`include "adder.v"


module ALUcontrolLUT // control Lookup Table within ALU unit
(
	output reg[2:0] muxindex,
	output reg		invertB, 

	input[2:0]		ALUcommand
);

	always @(ALUcommand) begin
	    case (ALUcommand)
	    	`ADD:  begin muxindex = 0; invertB=0; end    
	      	`SUB:  begin muxindex = 0; invertB=1; end
	     	`XOR:  begin muxindex = 2; invertB=0; end    
		    `SLT:  begin muxindex = 3; invertB=1; end
		    `AND:  begin muxindex = 4; invertB=0; end    
		    `NAND: begin muxindex = 5; invertB=0; end
		    `NOR:  begin muxindex = 6; invertB=0; end    
		    `OR:   begin muxindex = 7; invertB=0; end
	    endcase
	end
endmodule

module ALUunit // The bitslice ALU unit
(
	output bitR, // each bit of result
	output carryout, // carryout flag for ADD, SUB, SLT

	input bitA, 	// each bit of operandA
	input bitB, 	// each bit of operandB
	input carryin, 	// carryin input for ADD, SUB, SLT
	input less, 	// a result bit in SLT command.
	input[2:0] muxindex,
	input invertBflag
);

	wire inputB;		// B input for adder
	wire[7:0] muxinput;

	assign inputB = bitB^invertBflag;

	adder1bit adder(muxinput[`ADD], carryout, bitA, inputB, carryin); // 1 bit adder for ADD, SUB, SLT

	assign muxinput[`SLT] = less;
	assign muxinput[`XOR] = bitA^bitB;
	assign muxinput[`AND] = bitA&bitB;
	assign muxinput[`NAND] = ~muxinput[`AND];
	assign muxinput[`OR] = bitA|bitB;
	assign muxinput[`NOR] = ~muxinput[`OR];

	mux8input #(1) mux(bitR, muxindex, muxinput[0], muxinput[1], muxinput[2], muxinput[3],
									   muxinput[4], muxinput[5], muxinput[6], muxinput[7]);


endmodule

module lastALUunit // last ALU unit, which has an ALU unit with outputs of SLT value and overflow flag.
(
	output bitR,
	output carryout,
	output overflow,
	output slt, // signal for less signal of the first ALU unit

	input bitA,
	input bitB,
	input carryin,
	input less,
	input[2:0] muxindex,
	input invertBflag
);

	ALUunit basic_unit(bitR, carryout, bitA, bitB, carryin, less, muxindex, invertBflag);
	assign overflow = carryin^carryout;

	wire slt_result;  //sum of A, ~B and carryin, used when the command is SLT because bitR is always 0 for SLT.
	wire slt_carryout;//not used variable
	wire notB;//inverted B, used when the command is SLT 

	adder1bit slt_adder(slt_result, slt_carryout, bitA, ~bitB, carryin);
	assign slt = slt_result^overflow;

endmodule


module ALU // total ALU which has 32 basic ALU units and control unit.
#(
    parameter width  = 32
)
(
	output[width-1:0] 	result,
	output 	 	  		carryout,
	output        		zero,
	output       		overflow,

	input[width-1:0]   	operandA,
	input[width-1:0]	operandB,
	input[2:0]    		command
);

	wire[width-2:0]	internal_carryout; //carryout of each ALU unit except the last one
	wire[2:0] 		muxindex;	//input address of MUX for every ALU unit
	wire 			invertBflag;//invertB flag input for every ALU unit
	wire 			set_SLT;	//less input for the first ALU unit

	ALUcontrolLUT controlLUT(muxindex, invertBflag, command);

	ALUunit firstunit(
		result[0], internal_carryout[0], // output: result, carryout
		operandA[0], operandB[0], invertBflag, set_SLT, muxindex, invertBflag
	);
	
	//// construct 32 ALU units
	genvar i;
	generate // 2nd to 31st adder instantiation 
		for(i=1; i<width-1; i=i+1) begin: generate_alu_unit
			ALUunit unit(
				result[i],
				internal_carryout[i],//carryout
				operandA[i],
				operandB[i],
				internal_carryout[i-1],//carryin
				0, 			//result for SLT command
				muxindex,
				invertBflag
			);
		end
	endgenerate
	lastALUunit lastunit(
		result[width-1], carryout, overflow, set_SLT, // output: result, carryout, overflow, slt
		operandA[width-1], operandB[width-1], internal_carryout[width-2], 0, muxindex, invertBflag
	);

	/// make logic for zero flag
	wire[width-2:0] wire_for_zero;
	wire[width-1:0] inverted_result;
	assign wire_for_zero[0] = ~(result[0]|result[1]);
	generate
		for(i=1; i<width-1; i=i+1) begin: generate_zero_flag
			assign wire_for_zero[i] = ~result[i+1] & wire_for_zero[i-1];
		end
	endgenerate
	assign zero = wire_for_zero[width-2];

endmodule
