module adder1bit // 1 bit input adder
(
    output sum,  // output
    output cout, // carry out
    input a,  // input1
    input b,  // input2
    input cin // carry in
);

	assign sum = ( ((a^b)^cin) | (a&b&cin) );
	assign cout = ( cin & (a|b) ) | ( ~cin & (a&b) );

endmodule