module fourToOneMux #(parameter DATA_WIDTH = 32) (out,in1,in2,in3,in4,slt);
	output [DATA_WIDTH-1:0] out;
	input [DATA_WIDTH-1:0] in1,in2,in3,in4;
	input [1:0] slt;
	
	reg [DATA_WIDTH-1:0] out;
	
	always @ (*) begin
		case(slt)
			2'b00:out = in1;
			2'b01:out = in2;
			2'b10:out = in3;
			2'b11:out = in4;
		endcase
	end
endmodule
		
	
	