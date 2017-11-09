module Mux2input // Multiplexer with 4 inputs (2 bits address)
#(
    parameter width  = 32 // default width is 32 bit
)
(
	output[width-1:0] out,
	input address,
	input[width-1:0] in0, in1
);
	if (address == 0) begin
		assign out = in0;
	end
	else begin
		assign out = in1;
	end
endmodule

module Mux4input // Multiplexer with 4 inputs (2 bits address)
#(
    parameter width  = 32 // default width is 32 bit
)
(
    output out,
    input address0, address1,
    input in0, in1, in2, in3
);
    wire[width-1:0] out0;
    wire[width-1:0] out1;

    twoInputMux mux1(out0, address0, in0, in1);
    twoInputMux mux2(out1, address0, in2, in3);
    twoInputMux mux3(out, address1, out0, out1);
endmodule