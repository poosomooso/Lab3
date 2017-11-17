module twoToOneMux #(parameter DATA_WIDTH = 32) (out,in1,in2,slt);
	output [DATA_WIDTH-1:0] out;
	input [DATA_WIDTH-1:0] in1,in2;
	input slt;
	
	assign out = slt ? in2 : in1;
endmodule
		